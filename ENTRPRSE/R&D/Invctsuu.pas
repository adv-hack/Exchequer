Unit InvCtSuU;

{$I DEFOVR.Inc}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 01/11/96                      }
{                                                              }
{             + Invoicing Body Control Support Unit +          }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  Windows,
  Dialogs,
  SysUtils,
  Classes,
  GlobVar,
  VarConst,
  VarRec2U,
   {$IFDEF STK}
     {$IFNDEF EXDLL}
       StockLevelsU,
     {$ENDIF}
   {$ENDIF}
   {$IFDEF SOPDLL}
      StockLevelsU,
   {$ENDIF}
  BodgeFlags,
  Exbtth1U;

  {MiscU;}



{$IFDEF STK}


  {$IFDEf PF_On}

    Procedure Job_StockEffect(Var   StockPos  :  StockPosType;
                                    IdR       :  IDetail);

  {$ENDIF}

  Procedure Stock_Effect(Var  StockPos  :  StockPosType;
                              IdR       :  IDetail;
                              DQty      :  Real;
                              ShowSign  :  Boolean);


  Procedure Deduct_AdjStk(Var  Idr     :  IDetail;
                               LInv    :  InvRec;
                               Deduct  :  Boolean);

  Procedure Deduct_WORStk(Var  Idr     :  IDetail;
                               LInv    :  InvRec;
                               Deduct  :  Boolean);

 //PR: 08/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
 Procedure Stock_Deduct(Var IdR     :  IDetail;
                            LInv    :  InvRec;
                            Deduct,
                            GetSRec :  Boolean;
                            Mode    :  Byte;
                            ExLocal : TdPostExLocalPtr = nil);


 Procedure Gen_StockDeduct(Var   Idr     :  IDetail;
                                 LInv    :  InvRec;
                                 Level   :  LongInt;
                                 Mode    :  Byte;
                           Var   BOMOCost:  Double;
                                 StkFolio,
                                 ABLineNo:  LongInt;
                           Const BodgeFlag : LongInt = StkDedNoBodge);


 Procedure Delete_StockLinks (Code  :  AnyStr;
                              Fnum  :  Integer;
                              KLen  :  Integer;
                              KeyPth:  Integer;
                              DelInv:  Boolean;
                              InvR  :  InvRec;
                              Mode  :  Byte);

{$IFDEF SOPDLL}
  {$UNDEF EXDLL}
{$ENDIF}

{$IFNDEF EXDLL}
Procedure Check_StockCtrl(SCode    :  Str20;
                            DQty     :  Real;
                            Mode     :  Byte;
                        Var FLowStk  :  Boolean;
                            DocHed   :  DocTypes;
                            IdR      :  IDetail;
                            MsgH     :  Longint;
                            OnSelectAlternateStock: TSelectAlternateStockProc = nil;
                            Edit     : Boolean = False);


{$IFDEF SOP}
Type
    TOpoLineCtrl =  ^oOpoLineCtrl;

    oOpoLineCtrl =  Object
                      OStockCode  :  Str20;
                      OLineQty    :  Double;
                      oSetQty     :  Boolean;
                      oSetCurr    :  Byte;


                      Constructor Create(StkWarnPtr  :  Pointer);

                      Destructor Destroy;

                      Function MapToStkWarn  :  Boolean;

                      Function GetSelMLocRec(Var SMLoc  :  MLocRec)  :  Boolean;

                      Private
                        oStkWarnPtr  :  Pointer;

                    end; {Object..}

{$ENDIF}

{$ENDIF}
{$IFDEF SOPDLL}
  {$DEFINE EXDLL}
{$ENDIF}


  {$IFDEF SOP}

    { ===== Proc to update all Serial nos with new currency and xrate ===== }

    Procedure UpdateSNos(InvR       :  InvRec;
                         IdR        :  IDetail;
                         OutMode    :  Boolean);
  {$ENDIF}

{$ENDIF}





 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   Controls,
   BTrvU2,
   ETStrU,
   ETDateU,
   ETMiscU,
   BTKeys1U,
   ComnUnit,
   ComnU2,

   InvListU,


   {$IFDEF PF_On}

     InvLst2U,

   {$ENDIF}


   CurrncyU,

   {$IFDEF SOP}
     InvLst3U,
   {$ENDIF}

   {$IFNDEF OC2_On}


     {$IFDEF STK}

       {$IFDEF Pf_On}

         FIFOL2U,

         CuStkA3U,
         {$IFNDEF EXDLL} { HM 02/02/00 }
         StkLockU,

         {$IFDEF SOP}
           SOPCt4U,
           
         {$ENDIF}

         {$ENDIF}

       {$ENDIF}

     {$ENDIF}

   {$ENDIF}

   SysU2,

   BTSupU1,

   {$IFDEF STK}
     {$IFNDEF EXDLL}
       StkWarnU,
     {$ENDIF}
   {$ENDIF}

   {$IFDEF SOPDLL}
      StkWarnU,
   {$ENDIF}


   {$IFNDEF EXDLL}
     {$IFNDEF EBAD}
     ExThrd2U,
     {$ENDIF}
   {$ENDIF}

   {$IFDEF EXDLL}
     //PR: 13/10/2011 Change from EntDllSP using copy of this unit to using this unit missed that it should use
     //Stock_MlocDeduct function in InvLst3U rather than in BTS1 which is the standard TK function.  ABSEXCH-11976
     {$IFDEF SOPDLL}
     InvLst3U,
     {$ELSE}
     // HM 04/07/00: Added on behalf on SM as she didn't want to change it herself!
     BTS1,
     {$ENDIF}
     Profile,
     SQLUtils,
     TKSQLCallerU,
   {$ENDIF}

   InvCT2SU;




const
  //PR: 31/10/2011 v6.9 Added stReorderPrice which had been missed out ABSEXCH-11941
  SQL_UPDATE_STOCK = 'UPDATE [COMPANY].[Stock] SET stQtyInStock = %g, stQtyOnOrder = %g, stQtyAllocated = %g, ' +
                      'stQtyPicked = %g, stMinReorderFlag = %d,  stCostPriceCurrency = %d, stCostPrice = %.15f, ' +
                      'stReorderPrice = %.15f ' +
                      'WHERE stFolioNum = %d';

  SQL_STOCK_COLUMNS = 'stQtyInStock, stQtyOnOrder, stQtyAllocated, stQtyPicked, stMinReorderFlag, stCostPriceCurrency, stCostPrice,' +
                       'stReorderPrice';




{$IFDEF STK}


  {$IFDEF PF_On}


    { ==== Procdure to Artificialy show stock as going in/out for
           purchase lines with a job code ==== }

    Procedure Job_StockEffect(Var   StockPos  :  StockPosType;
                                    IdR       :  IDetail);


    Begin

      With IdR do
        If  (Not Emptykey(JobCode,JobKeyLen)) and (JBCostOn) and (DeductQty=0.0) and (IdDocHed In StkInSet+PurchSet) then
        Begin
          StockPos[1]:=(Qty_OS(IdR)*QtyMul)*StkAdjCnst[IdDocHed];
          StockPos[2]:=StockPos[1];

        end;

    end;

  {$ENDIF}


  { ==== Procedure to Position Stock Deduct Qty's ==== }


  Procedure Stock_Effect(Var  StockPos  :  StockPosType;
                              IdR       :  IDetail;
                              DQty      :  Real;
                              ShowSign  :  Boolean);


  Var

    Mode   :  Byte;

    DCnst  :  Integer;
  Begin

    DCnst:=1;

    Mode:=0;

    With IdR do
    Begin

      If (ShowSign) and (IdDocHed In StkOpoSet) then
        DCnst:=DocNotCnst;

      Blank(StockPos,Sizeof(StockPos));

      If (Not (IdDocHed In [Adj]+StkExcSet)) then
      Begin

        Mode:=1+(1*Ord(IdDocHed In StkOutSet))
               +(2*Ord(IdDocHed In StkAllSet))
               +(3*Ord(IdDocHed In StkOrdSet));

        StockPos[Mode]:=(DQty*DCnst);

        If (IdDocHed In StkAllSet) then {* Set Qty Picked value *}
          StockPos[5]:=(QtyPick*QtyMul*DCnst);

      end
      else
        If (IdDocHed In [Adj]) then
        Begin

          Mode:=1+Ord(((DQty*StkAdjCnst[IdDocHed])<0));

          If (ShowSign) then
            StockPos[Mode]:=Abs(DQty)
          else
            StockPos[Mode]:=DQty;
        end
        else
          If (IdDocHed = WOR) then
          Begin
            If (ABSLineNo=1) then
              StockPos[4]:=Qty_Os(IdR)*DCnst {If its the first line, we need to increase on order}
            else
              StockPos[6]:=Qty_Os(IdR)*DCnst; {Allocated to works order}


            StockPos[7]:=(QtyDel-QtyWOff)*DCnst; {Isseued less built to works order}
            StockPos[8]:=QtyPick*DCnst; {Issued now to works order}
          end
          else
            If (IdDocHed In StkRetSplit) then {* Process return *}
            Begin
              Mode:=9+Ord(IdDocHed=PRN);

              StockPos[Mode]:=Qty_Os(IdR)*DCnst; {+/- ?RN returns level}

              StockPos[1+Ord((IdDocHed In StkRetPurchSplit))]:=(DQty*DCnst);   {PRN auto affects stock out when its returned - replaced by Adj}

            end;

          

    end; {With..}

  end; {Proc..}


  Procedure Deduct_AdjStk(Var  Idr     :  IDetail;
                               LInv    :  InvRec;
                               Deduct  :  Boolean);



Begin

    If (Not EmptyKey(Idr.StockCode,StkKeyLen)) then
      Stock_Deduct(Idr,LInv,Deduct,BOn,0);

end;



Procedure Deduct_WORStk(Var  Idr     :  IDetail;
                             LInv    :  InvRec;
                             Deduct  :  Boolean);



Begin

    If (Not EmptyKey(Idr.StockCode,StkKeyLen)) then
      Stock_Deduct(Idr,LInv,Deduct,BOn,3);

end;



  { ==== Procedure to Control Stock_Deduct ==== }
  //PR: 08/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
  Procedure Stock_Deduct(Var IdR     :  IDetail;
                             LInv    :  InvRec;
                             Deduct,
                             GetSRec :  Boolean;
                             Mode    :  Byte;
                             ExLocal : TdPostExLocalPtr = nil);



  Const
    Fnum     =  StockF;

    Keypath  =  StkCodeK;



  Var
    n,FIFOMode,
    COSDec,UOR
             :  Byte;

    KeyS     :  Str255;

    DCnst    :  Integer;

    StockPos :  StockPosType;

    DiscValue,
    Rnum,
    QtyCheck :  Real;

    Locked   :  Boolean;

    LAddr    :  LongInt;

    LocStkR  :  StockRec;

    sQuery   : AnsiString;

    //PR: 05/09/2014 Order Payments T056 Indicates if we're using the ExLocal
    UsingExLocal : Boolean;


  Begin

    n:=0;

    If (Deduct) then
      DCnst:=1
    else
      DCnst:=-1;

    Rnum:=0;

    DiscValue:=0;

    COSDec:=0;

    QtyCheck:=0;

    FIFOMode:=0;

    UOR:=0;

    //PR: 05/09/2014 Order Payments T056
    UsingExLocal := Assigned(ExLocal);

    With IdR do
    Begin

      If (GetSRec) then
      Begin
        {$IFDEF EXDLL}
        Profiler.StartFunc('GetStockRec');
        {$ENDIF}
        KeyS:=StockCode;

        Locked:=BOff;

        Ok:=GetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);
        {$IFDEF EXDLL}
        if SQLUtils.UsingSQL and Ok and Locked then
        begin
          //PR: Unlock record then lock again using SQL - need to do this as not locking record
          //in call above causes emulator to crash when finding a FIFO record in ExStkChk in FIFO_Control.
          Status := UnLockMulTiSing(F[FNum], FNum, LAddr);
          Ok := SQLCaller(StockF).Lock('Stock', LAddr, SQL_STOCK_COLUMNS);
          Locked := Ok;
        end;

        Profiler.EndFunc('GetStockRec');
        {$ENDIF}
      end
      else
      Begin

        Ok:=BOn; Locked:=BOn;

      end;

      If (Ok) and (Locked) and (Stock.StockType<>StkGrpCode) then
      With Stock do
      Begin

        LocStkR:=Stock;

        {* Check to see if stock has been edited before continuing *}
        {$IFNDEF EXDLL}
          {$IFNDEF EBAD}
          Close_StockEdit(Stock);
          {$ENDIF}
        {$ENDIF}

        If (Deduct) and (Mode=0) then
        Begin


          If (((IdDocHed In SalesSplit) and ((Not ShowAsKit) or (StockType<>StkBillCode))
             and  (Idr.LineNo<>StkLineNo))
             or ((Syss.DeadBOM) and (IdR.LineNo=StkLineNo) and (Syss.AutoValStk))
             or ((IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo))) then
                                                   {* Only attribute costprice to Non B/M items,
                                                      & non kit items, or Generated Adj Lines, as generated
                                                      lines will never have a costprice, as this is
                                                      accounted for in the B/M Header *}

                                                   {* V4.31 alters this by working on the lines to get accuracy *}


          Begin


            Rnum:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,UsePack),
                                  Stock.PCurrency,Idr.Currency,UseCoDayRate);

            If (IdDocHed In StkAdjSplit) then
              COSDec:=Syss.NoCosDec
            else
              COSDec:=Syss.NoNetDec;

            If (Idr.CostPrice=0) and ((Not Is_SERNo(Stock.StkValType)) or (IdR.SerialQty=0)) then
            {* Only update when line is new, otherwise any manual settings get overidden *}
              IdR.CostPrice:=Round_Up(Calc_IdQty(Rnum,QtyMul,Not UsePack ),COSDec);


          end;

          With IdR do
            // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
            //DiscValue:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);
            DiscValue := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                                         Discount, DiscountChr,
                                         Discount2, Discount2Chr,
                                         Discount3, Discount3Chr);

          If (IdDocHed In StkPUpSet-[WOR])  or ((IdDocHed In [ADJ]) and (Qty>0)) then
          Begin

            If (FIFO_Mode(StkValType)=1) then  {* This needs to change for FIFO *}
            Begin

              With IdR do
              Begin
                UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                Rnum:=Conv_TCurr((IdR.NetValue+IdR.CostPrice-DiscValue),XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                If (IdDocHed In [ADJ]) and (Stock.BuyUnit<>0.0) and (Not CalcPack) then {v5.52. As ADJ is unit price only, factor in any buying units for priced by sales unit item}
                Begin
                  Rnum:=Calc_IdQty(Rnum,Stock.BuyUnit,BOn);

                end;

              end;


              Rnum:=Round_Up(Currency_ConvFT(Rnum,0,Stock.PCurrency,UseCoDayRate),Syss.NoCosDec);

              If (Rnum<>Stock.CostPrice) then
                Update_UpChange(BOn);

              Stock.CostPrice:=Rnum;
            end;


          end;
                                    {Removed checking of POR in v5.50}
          If (IdDocHed In StkPUpSet{+[POR]}-[WOR,PRN]) and (Not Syss.ManROCP) then {Auto update ro price}
          Begin
            With IdR do
              Rnum:=Conv_TCurr((IdR.NetValue-DiscValue),XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

            Rnum:=Round_Up(Currency_ConvFT(Rnum,0,Stock.ROCurrency,UseCoDayRate),Syss.NoCOSDec);

            Stock.ROCPrice:=Rnum;
          end;


          If (Stock.StockType In StkProdSet) then
          Begin



            If (IdDocHed In StkAllSet+StkOrdSet) then
            Begin

              Rnum:=FreeStock(Stock);

              QtyCheck:=(Qty_OS(IdR)*QtyMul);


            end
            else
            Begin

              Rnum:=QtyInStock;

              QtyCheck:=(Qty_OS(IdR)*QtyMul*StkAdjCnst[IdDocHed]*DocNotCnst);

              {$IFDEF SOP}
                {* b560.057 As this is a deduct live BOM situation we must limit the deduct stock level to that available at the specific location *}

                If (StockType = StkBillCode) and (Not (IdDocHed In PurchSplit)) and (Syss.DeadBOM)
                and {(Not (IdDocHed In StkAdjSplit)) and }(Not EmptyKey(MLocStk,MLocKeyLen)) and (Syss.UseMLoc) then
                Begin
                  LocStkR:=Stock;

                  Stock_LocSubst(LocStkR,MLocStk);

                  Rnum:=LocStkR.QtyInStock;
                end;

              {$ENDIF}

            end;




            If (StockType = StkBillCode) and ((Rnum<QtyCheck) or (QtyCheck<0))
                and (Not (IdDocHed In PurchSplit)) and ((Syss.DeadBOM) or (ShowasKit))
                and ((Not (IdDocHed In StkAdjSplit)) or (LineNo=StkLineNo))
                and (Not (IdDocHed In StkRetSplit)) then
            Begin

              If (Rnum>0) and (QtyCheck>=0) then
              Begin
                DeductQty:=Rnum;

                If (IdDocHed In StkAdjSplit) then {* Force a reversal *}
                  DeductQty:=DeductQty*DocNotCnst;

              end
              else
                DeductQty:=0;

            end
            else
              If (StockType = StkBillCode) and (IdDocHed In PurchSplit) and (KitOnPurch) then
                DeductQty:=0
              else
                If (IdDocHed In StkRetSplit) then
                Begin
                  If (IdDocHed In StkRetPurchSplit) then
                    DeductQty:=(Qty)*QtyMul;
                  {else
                    DeductQty:=QtyDel*QtyMul;}
                end
                else
                  DeductQty:=(Qty_OS(IdR)*QtyMul);



          end;


          {$IFDEF PF_On}

            {* Treat Pin type stk movements as being issued straight to job, if jobcode present *}

            {*EN420}

            If ((Not EmptyKey(JobCode,JobKeyLen)) and (IdDoched In StkInSet+PurchSet) and (JBCostOn))
              or (Not AfterPurge(IdR.PYr,0)) then
              DeductQty:=0;

          {$ELSE}
              If (Not AfterPurge(IdR.PYr,0)) then
                DeductQty:=0;

          {$ENDIF}


        end;

        {$IFDEF EXDLL}
        Profiler.StartFunc('Rest of deduct');
        {$ENDIF}
        If (Stock.StockType In StkProdSet) then
        Begin
{$IFDEF EXDLL}
   Profiler.StartFunc('Stock Effect');
          Stock_Effect(StockPos,IdR,DeductQty,BOff);
   Profiler.EndFunc('Stock Effect');
{$ELSE}
          Stock_Effect(StockPos,IdR,DeductQty,BOff);
{$ENDIF}
          Case Mode of
            0,2,3,99
               :  Begin
                    {*EN420}

                    If (AfterPurge(IdR.PYr,0)) then
                      For n:=1 to 2 do
                      QtyInStock:=QtyInStock+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);

                    If (Mode<>3) then
                      QtyAllocated:=QtyAllocated+(StockPos[3]*StkAdjCnst[IdDocHed]*DCnst);

                    QtyOnOrder:=QtyOnOrder+(StockPos[4]*StkAdjCnst[IdDocHed]*DCnst);

                    QtyPicked:=QtyPicked+(StockPos[5]*StkAdjCnst[IdDocHed]*DCnst);

                    {$IFDEF WOP}
                      QtyAllocWOR:=QtyAllocWOR+(StockPos[6]*StkAdjCnst[IdDocHed]*DCnst);
                      QtyIssueWOR:=QtyIssueWOR+(StockPos[7]*StkAdjCnst[IdDocHed]*DCnst);
                      QtyPickWOR:=QtyPickWOR+(StockPos[8]*StkAdjCnst[IdDocHed]*DCnst);

                    {$ENDIF}

                    {$IFDEF RET}
                      QtyReturn:=QtyReturn+(StockPos[9]*DCnst);
                      QtyPReturn:=QtyPReturn+(StockPos[10]*DCnst);

                    {$ENDIF}


                    {$IFDEF PF_On}

                      Rnum:=0;

                      FIFOMode:=FIFO_Mode(SetStkVal(StkValType,SerNoWAvg,BOn));

                      If (AfterPurge(IdR.PYr,0)) then
                        Case FIFOMode of

                        2,3  :  Begin  {* Maintain FIFO/LIFO db *}
                                  For n:=1 to 2 do
                                    Rnum:=Rnum+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);



                                  If (Rnum<>0) and (Is_FIFO(StkValType)) then
                                  begin
                                    //PR: 05/09/2014 Order Payments T056 Pass ExLocal to function
                                    FIFO_Control(IdR,Stock,LInv,Rnum,Mode,Deduct, ExLocal);
                                  end;
                                end;

                        4,5  :  Begin  {* Maintain Weighted Average Cost Price *}

                                  Rnum:=(StockPos[(FIFOMode-3)]*StkAdjCnst[IdDocHed]*DCnst);

                                  Case FIFOMode of

                                    4  :  Begin
                                            If (Rnum=0.0) and (IdDocHed In SalesCreditSet) then
                                            Begin
                                              Rnum:=(StockPos[(FIFOMode-2)]*StkAdjCnst[IdDocHed]*DCnst);

                                            end;


                                            If (Rnum<>0) then
                                              FIFO_AvgVal(Stock,IdR,Rnum);
                                          end;

                                    {$IFDEF SOP}   {* Update Next Cost price for Ser No, when either buying or selling
                                                      Simply gets next Sno Cost Price *}

                                      5:  If (Mode=0) and (Deduct) then
                                            FIFO_SERUp(Stock,IdR, ExLocal);

                                    {$ENDIF}

                                  end; {Case..}

                                end;

                      end; {Case..}


                    {$ENDIF}

                  end;

            1  :  Begin

                    For n:=1 to 2 do
                      QtyPosted:=QtyPosted+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);

                   end;

          end; {Case..}
        {$IFDEF EXDLL}
        Profiler.EndFunc('Rest of deduct');
        {$ENDIF}

          {$IFDEF SOP}
            //PR: 08/09/2014 Order Payments T056 Pass ExLocal to function
            If (Syss.UseMLoc) and (Not EmptyKey(MLocStk,MLocKeyLen)) and (Mode In [0..3,99]) then
              Stock_MLocDeduct(IdR,StockPos,DCnst,GetSRec,Mode, ExLocal);
          {$ELSE}
            // HM 04/07/00: Added on behalf on SM as she didn't want to change it herself!
            {$IFDEF EXDLL}
        Profiler.StartFunc('Stock_MLocDeduct');
             //PR: 13/10/2011 EntDllSp should use Stock_MlocDeduct function in InvLst3U rather than in BTS1.  ABSEXCH-11976
            {$IFDEF SOPDLL}
              If (Syss.UseMLoc) and (Not EmptyKey(MLocStk,MLocKeyLen)) and (Mode In [0..3,99]) then
                Stock_MLocDeduct(IdR,StockPos,DCnst,GetSRec,Mode);
             {$ELSE}
              If DeductMLoc and (Not EmptyKey(MLocStk,MLocKeyLen)) and (Mode In [0..3,99]) then
                Stock_MLocDeduct(IdR,DeductQty,DCnst,GetSRec,Mode);
             {$ENDIF}
        Profiler.EndFunc('Stock_MLocDeduct');
            {$ENDIF}
          {$ENDIF}

          {* v4.30c. Added other wise wait all stock reversal of
                     Qty picked caused deductqty to be reset incorrectly
                     Mode 3 only deals with updating qty picked... *}

          If (Not Deduct) and (Not (Mode In [3,99])) then
            DeductQty:=0;
        end;


        If (GetSRec) then
        Begin

          MinFlg:=((FreeStock(Stock)<QtyMin)) and (QtyMin<>0);

          {* Update last edited flag *}

          {$IFNDEF EXDLL}
            {$IFDEF SOP}
              If (fStopSUpdate<>2) then
            {$ENDIF}
              Begin
                LastUsed:=Today;
                TimeChange:=TimeNowStr;
              end;
          {$ENDIF}
        {$IFDEF EXDLL}
        Profiler.StartFunc('Stock_Deduct - PutRec');
//          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
        if SQLUtils.UsingSQL then
        begin
          //PR: 31/10/2011 v6.9 Added stReorderPrice which had been missed out ABSEXCH-11941
          with Stock do
            sQuery := Format(SQL_UPDATE_STOCK, [QtyInStock,
                                                QtyOnOrder,
                                                QtyAllocated,
                                                QtyPicked,
                                                Ord(MinFlg),
                                                PCurrency,
                                                CostPrice,
                                                ROCPrice,
                                                StockFolio]);
          Status := SQLCaller(StockF).ExecSQLWithCommand(sQuery, SQLCaller(StockF).CoCode);
          SQLCaller(StockF).Commit;
        end
        else
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Profiler.EndFunc('Stock_Deduct - PutRec');
        {$ELSE}

          //PR: 05/09/2014 Order Payments T056
          if UsingExLocal then
          begin
            //Unlock global record
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


            //find and lock record in ExLocal
            Ok:=ExLocal.LGetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            if OK and Locked then
            begin
              //Replace existing LStock with amended Stock record
              ExLocal.LStock := Stock;

              //Store
              Status := ExLocal.LPut_Rec(FNum, KeyPath);
            end;
          end
          else //Standard functionality
            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
        {$ENDIF}

          Report_BError(Fnum,Status);

        {$IFDEF EXDLL}
        Profiler.StartFunc('Stock_Deduct - UnlockRec');
        {$ENDIF}
          //Unlock stock record
          if UsingExLocal then
            Status := ExLocal.LUnLockMLock(FNum)
          else
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        {$IFDEF EXDLL}
        Profiler.EndFunc('Stock_Deduct - UnlockRec');
        {$ENDIF}

        end;
      end {If Can't Find/Lock..}
      else
        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);



    end; {With IdR..}
  end; {Proc..}



  { ==== Procedure to deduct stock and generate any hidden batch lines invoice ==== }

  { == Any changes here must be reflected in the import module == }

  Procedure Gen_StockDeduct(Var   Idr     :  IDetail;
                                  LInv    :  InvRec;
                                  Level   :  LongInt;
                                  Mode    :  Byte;
                            Var   BOMOCost:  Double;
                                  StkFolio,
                                  ABLineNo:  LongInt;
                            Const BodgeFlag : LongInt = StkDedNoBodge);




  Const

    Fnum     =  PWrdF;

    Keypath  =  PwK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;

    Fnum3    =  IDetailF;
    Keypath3 =  IdFolioK;



  Var

    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    RecAddr  :  LongInt;

    QtyShort,
    QtyGCost :  Real;

    OwnCost,
    KitOCost :  Double;


    TmpStock :  ^StockRec;
    TmpId    :  ^Idetail;


  Begin

    KeyS:='';

    KeyChk:='';

    KeyStk:='';

    RecAddr:=0;

    New(TmpStock);
    New(TmpId);


    QtyShort:=0;

    QtyGCost:=0;

    If (Level=0) then
      BOMOCost:=0;

    KitOCost:=0;
    OwnCost:=0;



    If (Idr.IdDocHed In StkAdjSplit) and (Idr.KitLink=1) and (Level=0) then
    Begin

      QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[Idr.IdDocHed]*DocNotCnst));

      GetStock(Application.MainForm,Idr.StockCode,Idr.StockCode,-1);

    end
    else
    Begin
      {* This will be different from Ex, as Ex non SPOP deletes the lines first hence why
         a deduct needs to take place here as well *}

      If (Level=0) then {* Assume stock already deducted from line entry *}
        GetStock(Application.MainForm,Idr.StockCode,Idr.StockCode,-1)
      else
        Stock_Deduct(Idr,LInv,BOn,BOn,0);

      If ((BodgeFlag And StkDedRecreateSORHiddenLines) = StkDedRecreateSORHiddenLines) Then
      Begin
        // MH 25/05/2010: Modified calculation of QtyShort when recreating the hidden BoM lines
        //                during Deliver Picked Orders as it was incorrectly calculating the
        //                remainder as DeductQty is already included within QtyDel.
        QtyShort := (Qty_OS(Idr) * Idr.QtyMul);
        If Not (Idr.IdDocHed In [POR,SOR]) Then
          QtyShort := QtyShort - Idr.DeductQty;
      End // If ((BodgeFlag And StkDedRecreateSORHiddenLines) = StkDedRecreateSORHiddenLines)
      Else
        QtyShort:=((Qty_OS(Idr)*Idr.QtyMul)-Idr.DeductQty);

      {* If own stock exsits, the record cost contribution of that *}
      If (Idr.IdDocHed In StkAdjSplit) and (Stock.StockType=StkBillCode) and (Round_Up(Idr.DeductQty,Syss.NoQtyDec)<>0.0) then
      Begin
        OwnCost:=(Idr.CostPrice*(ABS(Idr.DeductQty)-1)); {* One less as idr.costprice will account for one of them *}
      end;

      {* EN422. At this point if none are from stock we need to zero the cost of this line, as it is already being taken into account by
                Own cost, and hence will be taken in to account twice? *}

      {* EX423. An additional check made so that description only items do not have cost reset at this point. *}

      If (IdR.DeductQty=0) and (Stock.StockType<>StkDescCode) then
        IdR.CostPrice:=0.0;


    end;

    TmpStock^:=Stock;

    TmpId^:=Idr;



    If (Stock.StockType=StkBillCode) and ((Not Stock.ShowasKit) or (Level>0))
      and (LInv.InvDocHed In SalesSplit+StkAdjSplit-StkExcSet) and (QtyShort<>0) then
    With TmpStock^ do
    Begin


      If ((LInv.InvDocHed In StkAdjSplit) {and (Syss.AutoValStk) EN552}) and (Level=0) then
        TmpId^.CostPrice:=0;

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With Password.BillMatRec do
      Begin
          //PR: 05/05/2015 ABSEXCH-16335 Take out Application.ProcessMessages so that procedure finishes before any other
          //                             events execute. 
//        Application.ProcessMessages;

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        KeySTk:=BillLink;

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

        If (StatusOk) then
        Begin
          With Idr do
          Begin

            StockCode:=Stock.StockCode;

            LineNo:=StkLineNo;

            Desc:=Stock.Desc[1];

            NetValue:=0;

            CostPrice:=0;

            VAT:=0;

            Discount:=0;

            DiscountChr:=C0;

            // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
            Discount2:=0;
            Discount3Chr:=C0;
            Discount3:=0;
            Discount3Chr:=C0;

            NomMode:=StkAdjNomMode;

            If (Stock.StockType=StkBillCode) then
              NomCode:=Stock.NomCodeS[5]
            else
              NomCode:=Stock.NomCodeS[4];

            Blank(CCDep,Sizeof(CCDep));  {* EL v6.01 The CC/Dep on a hidden line must be blank as this status is used to identify such lines once the line becomes posted *}

            Qty:=(QtyShort*QtyUsed);

            QtyMul:=1;
            QtyPack:=QtyMul;
            PriceMulX:=1.0;
            QtyDel:=0;
            QtyWOff:=0;
            QtyPick:=0;
            QtyPWOff:=0;
            SerialQty:=0;

            BinQty:=0.0;

            DeductQty:=0.0;

            B2BLink:=0; B2BLineNo:=0;

            If (Mode=0) then  {* Switch off ABS LineNo Control *}
            Begin

              ABSLineNo:=0;

              {$IFDEF SOP}
                KitLink:=StkFolio;
              {$ELSE}
                KitLink:=0;
              {$ENDIF}


              SOPLink:=0;   {* Reset any link *}

              SOPLineNo:=ABLineNo;
            end
            else
              If (Level=0) then  {* Set Kit folio so it is treated as part of a batch *}
                KitLink:=TmpStock^.StockFolio;


          end;


          If (Stock.StockType=StkBillCode) then
          Begin

            Gen_StockDeduct(Idr,LInv,Succ(Level),Mode,KitOCost,StkFolio,ABLineNo);

            SetDataRecOfs(Fnum,RecAddr);

            Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

            QtyGCost:=1;  {* Set Cost to 1 here, as BOM will return total cost for Qty *}

          end
          else
          Begin
            Stock_Deduct(Idr,LInv,BOn,BOn,0);

            // CJS/PR 22/04/2014 ABSEXCH-15060 Add check for un-building bom
            If ((LInv.InvDocHed In StkAdjSplit) {and (Syss.AutoValStk) EN552}) then
            Begin
              if (TmpId.KitLink = 1) and (TmpId.Qty < 0) then
                QtyGCost := IdR.Qty
              else
                QtyGCost:=Idr.Qty*DocNotCnst; {v5.50.001. Negatte stock effect sign to take into account any negative lines}
            end
            else
              QtyGCost:=ABS(Idr.Qty);

          end;

          {* Calculate an adjustment BOM cost price by recalculating the BOM
             contents *}

          If ((LInv.InvDocHed In StkAdjSplit) {and (Syss.AutoValStk) EN552}) then
          Begin
            If (Level=0) then
              TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyGCost)+KitOCost+OwnCost
            else
              OwnCost:=OwnCost+(Idr.CostPrice*QtyGCost)+KitOCost;

            If (Is_SERNo(Stock.StkValType)) then
              IdR.SSDUpLift:=IdR.CostPrice; {* Store here original price so we can recaluclate if SN *}
          end
          else
            If (Not (LInv.InvDocHed In SalesSplit)) or (Not Syss.autoValStk) then
              Idr.CostPrice:=0;  {* Reset Cost price again, incase it has been set by
                            an adjustment valuation *}

          KitOCost:=0;

          Status:=Add_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3);

          
        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      Stock:=TmpStock^;

      Idr:=TmpId^;

    end; {If Kit or Normal Product ..}

    BOMOCost:=BOMOCost+OwnCost;

    Dispose(TmpStock);

    Dispose(TmpId);


  end; {Proc..}






{ ================== Procedure to Delete all Records Matching a given Code ============= }



Procedure Delete_StockLinks (Code  :  AnyStr;
                             Fnum  :  Integer;
                             KLen  :  Integer;
                             KeyPth:  Integer;
                             DelInv:  Boolean;
                             InvR  :  InvRec;
                             Mode  :  Byte);

Var
  KeyS  :  AnyStr;

  ChngeSQUS,
  Locked:  Boolean;

  B_Func,
  QDC,
  NDC,
  VDC   :  Integer;

  TmpId :  IDetail;

  LAddr,
  RecAddr
        :  LongInt;
  dNum  : Double;

  {$IFDEF SOP}
    CommitPtr
        :  Pointer;
  {$ENDIF}

Begin
  KeyS:=Code;

  dNum  := 0.0; QDC:=1; NDC:=1; VDC:=1;
  RecAddr:=0;

  {$IFDEF SOP}
    CommitPtr:=nil;

    {$IFNDEF EXDLL}

    {$B-}
      If (CommitAct) and (Mode=1) and (InvR.InvDocHed=POR) then
    {$B+}
        CommitPtr:=Conv_Create_CommitObject(BOff,nil);

    {$ENDIF}

  {$ENDIF}

  TmpId:=Id;

  B_Func:=B_GetNext;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) and ((Not DelInv) or ((DelInv) and (Id.LineNo<> RecieptCode))) do
  Begin
    {$IFDEF PF_On}

      {* This section must be placed here, as otherwise the preserv pos
         inside Stock_addcust anal will be preserving a deleted pos... *}

      If  (Mode In [0,1]) then
      Begin
        If (Mode=1) then
        Begin{* Force this through as otherwise no SA update will take place, v4.30c *}
          Id.IDDocHed:=InvR.InvDocHed;
          Id.Pdate:=InvR.TransDate;
        end;

        Stock_AddCustAnal(Id,BOn,1-Mode);
      end;

    {$ENDIF}


    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked,LAddr);

    If (Ok) and (Locked) then
    Begin

      If (Not EmptyKey(Id.StockCode,StkKeyLen)) then
        Stock_Deduct(Id,InvR,BOff,BOn,0);  {* Remove Stock *}

      Case Mode of

        0  :  Begin
                Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);


                {$IFDEF PF_On}

                  If (Not EmptyKey(Id.JobCode,JobKeyLen)) and (StatusOk) then
                    Delete_JobAct(Id);

                {$ENDIF}

              end;

        1  :  Begin   {* SQU Conversion *}

                If (Id.LineNo<>StkLineNo) then {* Ignore auto deduct lines as these will be recreated *}
                Begin
                  With Id do
                    ChngeSQUS:=(IdDocHed In QuotesSet) and (Inv.InvdocHed In [SCR,PCR]);

                    {Changed v4.32 so that -ve lines catered for correctly}
                    {ChngeSQUS:=(IdDocHed In QuotesSet) and (Inv.InvdocHed In [SCR,PCR]) and ((Qty<0.0) or (NetValue<0.0));}



                  Id.IDDocHed:=InvR.InvDocHed;

                  {$IFDEF PF_On}

                    If (Not EmptyKey(Id.JobCode,JobKeyLen)) then
                      Delete_JobAct(Id);

                  {$ENDIF}

                  Id.FolioRef:=InvR.FolioNum;

                  Id.DocPRef:=InvR.OurRef;

                  Id.LineType:=StkLineType[Id.IdDocHed];

                  If (Id.IdDocHed In OrderSet) then
                    Id.PDate:=Inv.DueDate
                  else
                    Id.PDate:=Inv.TransDate;

                  Id.CustCode:=InvR.CustCode;

                  If (ChngeSQUS) then
                  With Id do
                  Begin
                    QDC:=1; NDC:=1; VDC:=-1;

                    If ((Qty<0) and (NetValue>=0.0)) or
                     ((Qty>=0.0) and (NetValue>=0.0)) then
                      QDC:=-1
                    else
                      If ((Qty>=0.0) and (NetValue<0)) or
                      ((Qty<0.0) and (NetValue<0.0)) then
                        NDC:=-1;

                    Qty:=Qty*QDC;
                    NetValue:=NetValue*NDC;
                    VAT:=VAT*VDC;


                    Payment:=DocPayType[IdDocHed];
                    UseORate:=Inv.UseORate;
                    CXRate:=Inv.CXRate;
                    CurrTriR:=Inv.CurrTriR;

                  end;


                  If (Not EmptyKey(Id.StockCode,StkKeyLen)) then
                  Begin

                    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve Position *}

                    {.$IFDEF SOP} {Removed Ent Only! as otherwise quotes to inv do not affect stock}

                      Stock_Deduct(Id,InvR,BOn,BOn,0);  {* Remove Stock on SOP lines *}

                    {.$ENDIF}

                    TmpId:=Id;

                    Gen_StockDeduct(Id,InvR,0,0,dNum,Stock.StockFolio,Id.ABSLineNo);  {* Remove Stock *}

                    {* v4.23k, Gen_StockDeduct zeros cost price, so we preserve it here... *}

                    Id.CostPrice:=TmpId.CostPrice;

                    TmpId:=Id;

                    SetDataRecOfs(Fnum,RecAddr);

                    Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,0);

                    Id:=TmpId;

                  end;


                  {v500.002. Attempt to preserve ledger position by deleting old line first, and adding newly converted line second}

                  Status:=Delete_Rec(F[Fnum],Fnum,Keypth);

                  Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth);


                  {Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr); v500.002. no need to unlock as we have deleted original}

                  {$IFDEF PF_On}

                     If (JbCostOn) and (DetLTotal(Id,BOff,BOff,0.0)<>0) and (Id.KitLink=0) and (StatusOk) then
                       Update_JobAct(Id,InvR);

                  {$ENDIF}


                  {$IFDEF SOP}
                    {$IFNDEF EXDLL} {Update live commitment from new POR}
                      Conv_Update_LiveCommit(Id,1,CommitPtr);
                    {$ENDIF}
                  {$ENDIF}

                end
                else
                  Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);

                  Report_BError(Fnum,Status);

                  If (StatusOk) and (Id.LineNo<>StkLineNo) then
                    B_Func:=B_GetGEq
                  else
                    B_Func:=B_GetNext;

              end;

        2  :  Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


      end; {Case..}


    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


  end;


  {$IFDEF SOP}
    {$IFNDEF EXDLL}

      If (Assigned(CommitPtr)) then {Remove the commit object}
        Conv_Create_CommitObject(BOn,CommitPtr);

    {$ENDIF}

  {$ENDIF}



end;

{$IFDEF SOPDLL}
  {$UNDEF EXDLL}
{$ENDIF}

{$IFNDEF EXDLL}
{ =============== Quick Check on Stock Levels ============= }

Procedure Check_Stock(SCode   :  Str20;
                      DQty    :  Real;
                      Mode    :  Integer;
                  Var FLowStk :  Boolean;
                      IdR     :  IDetail;
                      InBom   :  Boolean;
                      MsgH    :  LongInt);





Var
  CallLocSplit,
  ShowLocBtn,
  PrevHState,
  GotStock :  Boolean;

  DCnst    :  Integer;

  Rnum,
  Need  :  Real;  

  WForm    :  TStkWarn;

  LocStr   :  Str20;

  TmpStk   :  ^StockRec;

  QtyReqPtr
           :  ^Double;

  mrResult :  Word;

  //PR: 16/03/2012 ABSEXCH-12399
  LStockFormDisplayed : Boolean;

Begin
  LStockFormDisplayed := False;
  GotStock:=BOff;

  ShowLocBtn:=BOff;

  LocStr:='';

  New(TmpStk);

  TmpStk^:=Stock;

  QtyReqPtr:=nil;

  CallLocSplit:=BOff;

  DCnst:=1;

  If (IdR.IdDocHed In OrderSet+QuotesSet+StkAdjSplit) then
    DCnst:=-1;

  With Stock do
  Begin
    {$IFDEF SOP} {* Replace global levels with location levels *}
      
      {SS 05/07/2016 2016-R3
       ABSEXCH-16429:SORs can be picked beyond available In-Stock quantity: in turn allowing negative quantity via SDNs despite the User-profile prohibiting it.
       - Refresh Location data before it apply on Stock record. Since in the cached data does not reflect current state.}
      InvLst3U.ResetCache;
      InvLst3U.UseCache := True;

      Stock_LocSubst(Stock,IdR.MLocStk);

      If (Not EmptyKey(IdR.MLocStk,MLocKeyLen)) and (Syss.UseMLoc) then
      Begin
        LocStr:='At Location : '+IdR.MLocStk+'';
                                                                                                                                             {Must be coming from TeleSales}
        ShowLocBtn:=((Not InBOM) and (Not ShowAsKit) and ((Mode<>2) or ((Mode=2) and CheckNegStk and (Not (IdR.IdDocHed  In OrderSet)))) and (IdR.FolioRef<>0));
      end;

    {$ENDIF}


    Case Mode of

      2,3:
      begin
        Rnum:=Round_Up(QtyInStock-QtyPicked-QtyPickWOR,Syss.NoQtyDec); {* Do not base check on Free Stock *}
      end


      else  Rnum:=FreeStock(Stock);

    end;

    GotStock:=(((Rnum+(DQty*StkAdjCnst[IdR.IdDocHed ]*DCnst))>=0) or (StockType In [StkGrpCode,StkDescCode]));

    FLowStk:=(FLowStk or Not GotStock);

    {$IFDEF DBD}
      If (FLowStk) and (Debug) then
        MessageBeep(0);
    {$ENDIF}

    If (Not GotStock) and (Mode>0) then
    Begin
      If (IdR.IdDocHed=WOR) then
        Need:=((DQty*DocNotCnst)-Rnum)
      else
        Need:=(DQty-Rnum);

      WForm:=TStkWarn.Create(Application.MainForm);

      try
        With WForm do
        Begin
          //HV and R Jha 06/01/2016, JIRA-2526, Stock - Bin Availability / Equivalents blank via 'AGE' button on stock lisl and telesales screen.
          ShowBinAvailability;
          LocBtn.Visible:=ShowLocBtn;

          fPHandle:=MsgH;

          If (Not EmptyKey(IdR.MLocStk,MLocKeyLen)) and (Syss.UseMLoc) then
            fLocFilt:=IdR.MLocStk;

          Caption:=Caption+dbFormatName(StockCode,Desc[1]);
          Pan1.Caption:=LocStr;
          Pan2.Caption:=LocStr;

          {$IFDEF SOP}

            fPCode:=SCode;
            fQAL:=CaseQty(Stock,AllocStock(Stock));
            fQOO:=CaseQty(Stock,QtyOnOrder);

            If (ShowLocBtn) then
            Begin
              New(QtyReqPtr);
              {QtyReqPtr^:=DQty;}
              QtyReqPtr^:=Need;
            end;

            Id4QPF.Visible:=BOn;
            PickLab.Visible:=BOn;
            Id4QPF.Value:=CaseQty(Stock,QtyPicked);

            If (Mode=2) then
            Begin
              Id4QOF.Value:=CaseQty(Stock,QtyInStock);
              Id4QAF.Value:=CaseQty(Stock,AllocStock(Stock));

              Id4QFF.Value:=CaseQty(Stock,Rnum);
              Id4QNF.Value:=CaseQty(Stock,Need);
              Id4QOSF.Value:=CaseQty(Stock,QtyOnOrder);
              Id4QPWF.Value:=CaseQty(Stock,QtyPickWOR);
              Id4QAWF.Value:=CaseQty(Stock,WOPAllocStock(Stock));
              Id4QIWF.Value:=CaseQty(Stock,QtyIssueWOR);

            end
            else

          {$ENDIF}

          Begin
            Id4QOF.Value:=CaseQty(Stock,QtyInStock);
            Id4QAF.Value:=CaseQty(Stock,AllocStock(Stock));
            Id4QFF.Value:=CaseQty(Stock,Rnum);
            Id4QNF.Value:=CaseQty(Stock,Need);
            Id4QOSF.Value:=CaseQty(Stock,QtyOnOrder);
            Id4QPWF.Value:=CaseQty(Stock,QtyPickWOR);
            Id4QAWF.Value:=CaseQty(Stock,WOPAllocStock(Stock));
            Id4QIWF.Value:=CaseQty(Stock,QtyIssueWOR);

          end;

          SetAllowHotKey(BOff,PrevHState);
          Set_BackThreadMVisible(BOn);
         
          mrResult:=ShowModal;

          SetAllowHotKey(BOn,PrevHState);

          Set_BackThreadMVisible(BOff);

          If (Not (mrResult In [mrOk,mrYes])) then
            Addch:=Esc;

          If (ShowLocBtn) then
          Begin
            If (mrResult=mrYes) then
              CallLocSplit:=BOn
            else
              Dispose(QtyReqPtr);
          end;
        end; {With..}

      finally
        //PR: 16/03/2012 ABSEXCH-12399 Was the stock window displayed
        LStockFormDisplayed := WForm.StockFormDisplayed;
        WForm.Free;

      end; {try..}


    end;
  end; {If Found Ok..}

  Stock:=TmpStk^;

  Dispose(TmpStk);

  If (CallLocSplit) then
    SendMessage(MsgH,WM_CustGetRec,212,LongInt(QtyReqPtr))
  else //PR: 16/03/2012 ABSEXCH-12399 Tell Transaction Line form that the stock window was displayed so that it can set focus correctly.
  if LStockFormDisplayed then
    SendMessage(MsgH, WM_CustGetRec, 1130, 0);

end; {Proc..}
{$ENDIF}


  { ==== Procedure to Check all sub assy Lines ==== }

  { Mode 3 representas a stk adj with a qty going in, ie poss drawing in components,
    This is with a qty in the in box. It will never come here for qty out, as this puts
    them back,... *}

  {$IFNDEF EXDLL}
  Procedure Check_SubAssy(DQty      :  Real;
                          Mode      :  Byte;
                      Var FLowStk   :  Boolean;
                          IdR       :  Idetail;
                          MsgH      :  LongInt);



  Const

    Fnum     =  PWrdF;

    Keypath  =  PwK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;



  Var

    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    DCnst    :  Integer;

    RecAddr  :  LongInt;

    BOMFLowStk,
    ThisFLowStk,
    WasMode3,
    WasFLowStk,
    GotStock :  Boolean;

    QtyShort,
    Rnum     :  Real;

    MLStk,
    TmpStock :  ^StockRec;


  Begin

    Addch:=ResetKey;

    KeyS:='';

    KeyChk:='';

    KeyStk:='';

    RecAddr:=0;

    GotStock:=BOff;  WasMode3:=(Mode=3);

    
    QtyShort:=0;

    DCnst:=1;

    New(MLStk);

    MLStk^:=Stock;

    WasFLowStk:=FLowStk;  ThisFLowStk:=BOff;  BOMFLowStk:=BOff;


    If (IdR.IdDocHed In QuotesSet+OrderSet+StkAdjSplit) then
      DCnst:=-1;

    {$IFDEF SOP} {* Replace global levels with location levels *}

      Stock_LocSubst(Stock,IdR.MLocStk);

    {$ENDIF}


    Case Mode of

      2,3
         :  With Stock do
              Rnum:=(QtyInStock-QtyPicked);  {* Do not base check on Free Stock *}

      else  Rnum:=FreeStock(Stock);

    end;


    If (Mode=3) then
    Begin
      DQty:=(DQty*DCnst);

      {* v4.31.004 If we are building then we are deducting components *}
      If (Stock.StockType=StkBillCode) {and (Syss.DeadBOM)} and (IdR.KitLink=1) and (DQty>0) then
        Rnum:=0.0;
    end;

    GotStock:=((Rnum+(DQty*StkAdjCnst[IdR.IdDocHed]*DCnst))>=0);

    {* Ammedned v4.21 *FLowStk:=((Not GotStock or FLowStk) and (Mode<>3));}

    FLowStk:=((Not GotStock or FLowStk) and (Mode<>3) and ((Not Syss.DeadBOM) or (Stock.StockType<>StkBillCode)));

    {$IFDEF DBD}
      If (FLowStk) and (Debug) then
        MessageBeep(0);
    {$ENDIF}


    {* Ammedned v5.50 *(Not GotStock) or Mode =3}
    {If Deduct comp was switched off, on a build stk adj with sub boms, the checking only checked the components, but the
     the stk deduction rotuine only took stock from level 1. A check placed if we have desended down a level from an adj build
     Do not go any further *}

    If ((Not GotStock) and ((Syss.DeadBOM) or (IdR.IdDocHed<>ADJ))) or (Mode=3)  then
    Begin

      New(TmpStock);

      TmpStock^:=Stock;

      QtyShort:=(DQty-Rnum);

      {If (Mode=3) then * Ammended v4.21
        QtyShort:=QtyShort*DCnst;}


      If (Mode=3) then
        Mode:=2;

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(Stock.StockFolio)));

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Addch<>Esc) and (Not BOMFLowStk) do
      With Password.BillMatRec do
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        KeySTk:=BillLink;

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

        If (StatusOk) then
        Begin

          If (Stock.StockType=StkBillCode) then
          Begin

            Check_SubAssy(QtyShort*QtyUsed,Mode,FLowStk,IdR,MsgH);

            {* v5.50 as we are not going to component level, preserve any BOM level failures here for ADJ builds,
                     warn, and  break loop *}
            If (Not BOMFLowStk)  and (FLowStk) then
            Begin
              BOMFLowStk:=BOn;

              If (Not Syss.DeadBOM) and (WasMode3) then
                Check_Stock(Stock.StockCode,(QtyShort*QtyUsed),Mode,FLowStk,IdR,BOn,MsgH);

            end;

            SetDataRecOfs(Fnum,RecAddr);

            Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          end
          else
            Check_Stock(Stock.StockCode,(QtyShort*QtyUsed),Mode,ThisFLowStk,IdR,BOn,MsgH);


        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      Stock:=TmpStock^;

      Dispose(TmpStock);

                                       {*v4.32.001 additional check placed here for Syss.DeadBOM as Flowstk does not get set by the parent bom*}
                                       {* v5.50 pass in a BOM level failure as well if we are not deducting down within an adj build *}
      If (Not WasFLowStk) and (FLowStk or Syss.DeadBOM or WasMode3) then
        FLowStk:=ThisFLowStk or BOMFLowStk;


    end; {If Kit or Normal Product ..}

    Stock:=MLStk^;

    Dispose(MLStk);
  end; {Proc..}
  {$ENDIF}


  { ======= Procedure to Control Checking of Stock Levels ====== }

  {$IFNDEF EXDLL}
  Procedure Check_StockCtrl(SCode    :  Str20;
                            DQty     :  Real;
                            Mode     :  Byte;
                        Var FLowStk  :  Boolean;
                            DocHed   :  DocTypes;
                            IdR      :  IDetail;
                            MsgH     :  LongInt;
                            OnSelectAlternateStock: TSelectAlternateStockProc;
                            Edit     : Boolean);

  var
    StockLevelsFrm: TStockLevelsFrm;
  Begin
    // For Adjustment lines, call the new routines, otherwise use the existing
    // routines.
    if (DocHed = ADJ) then
    begin
      Screen.Cursor := crHourglass;
      StockLevelsFrm := TStockLevelsFrm.Create(Application.MainForm);
      try
        if not StockLevelsFrm.Check(IdR, DQty, Mode, MsgH, Edit) then
        begin
          StockLevelsFrm.OnSelectAlternateStock := OnSelectAlternateStock;
          StockLevelsFrm.ShowModal;
          FLowStk := True;
        end;
      finally
        Screen.Cursor := crDefault;
        StockLevelsFrm.Free;
        Addch:=Esc;
      end;
    end
    else
    begin
      If (GetStock(Application.MainForm,SCode,SCode,-1)) then
      Begin
        If ((Stock.StockType=StkBillCode) and ((Syss.DeadBOM) or (Mode=3)) and ((DQty<0) or (Mode<>3))) then
          Check_SubAssy(DQty,Mode,FLowStk,IdR,MsgH)
        else
          Check_Stock(Scode,DQty,Mode,FLowStk,IdR,BOff,MsgH);
      end; {Ok..}

      If (Not CheckNegStk) or (Not (DocHed In StkDedSet+StkAdjSplit+WOPSplit+StkRetPurchSplit)) then {* Do not flag -ve stk if allowed *}
        FLowStk:=BOff;

      Addch:=ResetKey;
    end;
  end; {Proc..}


  {$IFDEF SOP}
    { == Routines to grab currently highlighted opportunity item and return it to the calling line == }

    Constructor oOpoLineCtrl.Create(StkWarnPtr  :  Pointer);

    Begin
      OStockCode:='';
      OLineQty:=0.0;

      oStkWarnPtr:=StkWarnPtr;
    end;

    Destructor oOpoLineCtrl.Destroy;

    Begin

    end;


    Function oOpoLineCtrl.MapToStkWarn  :  Boolean;

    Var
      oStkWarnO  :  TStkWarn;
    Begin
      Result:=BOff;

      If (Assigned(OStkWarnPtr)) then
      Begin
        oStkWarnO:=TStkWarn(oStkWarnPtr);

        try
          With oStkWarnO do
          Begin
            If (ODOLine2.ItemCount>0) and (ODOLine2.SelectedItem>=0)  then
            Begin
              If ReturnObjectEquiv then
              Begin
                Result:=BOn;
                OStockCode:=fpOSCode;
                OLineQty:=fpOSQty;
                oSetQty:=fpSetQty;
                oSetCurr:=fpSetCurr;
              end;
            end;
          end;
        except;
          Result:=BOff;

        end; {try..}

      end;
    end;


    Function oOpoLineCtrl.GetSelMLocRec(Var SMLoc  :  MLocRec)  :  Boolean;

    Var
      oStkWarnO  :  TStkWarn;
    Begin
      Result:=BOff;

      If (Assigned(OStkWarnPtr)) then
      Begin
        oStkWarnO:=TStkWarn(oStkWarnPtr);

        try
          With oStkWarnO do
          Begin
            If (ODOLine2.ItemCount>0) and (ODOLine2.SelectedItem>=0)  then
            Begin
              SMLoc:=ReturnObjectMLoc;

              Result:=(SMLoc.sdbStkRec.sdCode1<>'');
            end;
          end;
        except;
          Result:=BOff;

        end; {try..}

      end;
    end;



  {$ENDIF}


  {$ENDIF}

{$IFDEF SOPDLL}
  {$DEFINE EXDLL}
{$ENDIF}

  {$IFDEF SOP}

    { ===== Proc to update all Serial nos with new currency and xrate ===== }

    Procedure UpdateSNos(InvR       :  InvRec;
                         IdR        :  IDetail;
                         OutMode    :  Boolean);


    Const
      Fnum      = MiscF;
      Keypath   = MIK;

    Var
      KeyS,KeyChk  :  Str255;

      DiscP,
      Rnum,
      SerCount     :  Double;
      FoundOk,
      FoundAll,
      LOk,
      Locked       :  Boolean;

      LAddr        :  LongInt;


    Begin

      FoundAll:=(IdR.SerialQty=0.0);  SerCount:=0.0;

      LAddr:=0; Rnum:=0.0; DiscP:=0.0;

      If (IdR.StockCode<>Stock.StockCode) and (Not FoundAll) then
      Begin
        FoundAll:=Not Global_GetMainRec(StockF,IdR.StockCode);
      end;

      If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
      Begin

        If (OutMode) then
          KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1)
        else
          KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio));


        KeyS:=KeyChk+NdxWeight;


        Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
        With MiscRecs^.SerialRec do
        Begin
          Application.ProcessMessages;

          With InvR,IdR do
            If (OutMode) then
              FoundOk:=((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=SOPLineNo)
                                     and ((Not BatchRec) or (BatchChild)))
            else
              FoundOk:=((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo));
          If (FoundOk) then
          With InvR,IdR do
          Begin
            LOK := True;
            If (Not OutMode) then
              LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If ((LOk) and (Locked)) or (OutMode) then
            Begin


              If (OutMode) then
              Begin

              end
              else
              Begin
                CurCost:=InvR.Currency;

                SerCRates:=CXRate;

                SerTriR:=CurrTriR;

                If (SerCRates[BOff]=0.0) then
                Begin
                  SerCRates[BOff]:=SyssCurr^.Currencies[CurCost].CRates[BOff];
                  SetTriRec(CurCost,SUseORate,SerTriR);
                end;

                //PR 18/12/2008 For sales credit docs, the cost has been set manually so don't override it.
                if not (InvR.InvDocHed in SalesCreditSet) then
                begin
                  {*v5.70 also synchronise cost price & Location *}

                  // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
                  //DiscP:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);
                  DiscP := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                                           Discount, DiscountChr,
                                           Discount2, Discount2Chr,
                                           Discount3, Discount3Chr);

                  If (ShowCase) then
                    Rnum:=Round_Up(Calc_StkCP((NetValue-DiscP),QtyPack,UsePack)+Idr.CostPrice,Syss.NoCosDec)
                  else
                    Rnum:=Round_Up(Calc_StkCP((NetValue-DiscP+Idr.CostPrice),QtyMul,UsePack),Syss.NoCosDec);

                  SerCost:=Rnum;
                end; //not SCR


                If (Syss.UseMLoc) and (Not EmptyKey(MLocStk,MLocKeyLen)) then
                Begin
                  If (OutMode) then
                    OutMLoc:=MLocStk
                  else
                    InMLoc:=MLocStk;
                end;
                  
                Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

                Report_BError(Fnum,Status);

                Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

              end;


              If (Not BatchChild) or (OutMode) then
              Begin
                If (BatchRec) then
                Begin
                  If (OutMode) then
                    SerCount:=SerCount+QtyUsed
                  else
                    SerCount:=SerCount+BuyQty;
                end
                else
                  SerCount:=SerCount+1.0;
              end;
            end; {If Locked..}
          end;

          FoundAll:=(SerCount>=IdR.SerialQty);

          If (Not FoundAll) then
            Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}
      end; {If SNo..}


    end; {Proc..}


  {$ENDIF}

{$IFDEF SOPDLL}
  {$DEFINE EXDLL}
{$ENDIF}

{$ENDIF}

end.
