Unit InvLst3U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 12/11/96                      }
{                                                              }
{                  General List Controller III                 }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


{$I DEFOVR.Inc}

Interface

Uses

  GlobVar,
  VARRec2U,
  VarConst,
  BtrvU2,
  ETMiscU;



Function FreeMLocStock(StockR  :  MStkLocType) :  Double;

Function AllocMLocStock(StockR  :  MStkLocType) :  Double;

{.$IFNDEF JC}

  { Duplicated in ExBtTh1U, TdexPost}
  Function LocOverride(lc    :  Str10;
                       Mode  :  Byte)  :  Boolean;

  Function LocOPrice(lc  :  Str10)  :  Boolean;

  Function LocONom(lc  :  Str10)  :  Boolean;

  Function LocOCCDep(lc  :  Str10)  :  Boolean;

  Function LocOSupp(lc  :  Str10)  :  Boolean;

  Procedure SetROUpdate(StockR   :  StockRec;
                    Var TStkLoc  :  MStkLocType);

  Procedure SetTakeUpdate(StockR   :  StockRec;
                      Var TStkLoc  :  MStkLocType);

  Procedure SetROConsts(StockR   :  StockRec;
                    Var TStkLoc  :  MStkLocType;
                        TLocLoc  :  MLocLocType);

  Function LinkMLoc_Stock(lc  :  Str10;
                         sc  :  Str20;
                     Var TSL :  MStkLocType)  :  Boolean;

  Function LinkMLoc_Loc(lc  :  Str10;
                    Var TSL :  MLocLocType)  :  Boolean;

  Procedure Stock_MLocDeduct(IdR     :  IDetail;
                             StockPos:  StockPosType;
                             DCnst   :  Integer;
                             GetSRec :  Boolean;
                             Mode    :  Byte);

  Procedure Stock_LocSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);

  Procedure Stock_LocROSubst(Var StockR  :  StockRec;
                                 Lc      :  Str10);

  Procedure Stock_LocROCPSubst(Var StockR  :  StockRec;
                                   Lc      :  Str10);

  Procedure Stock_LocTKSubst(Var StockR  :  StockRec;
                                 Lc      :  Str10);

  Procedure Stock_LocPSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);

  Procedure Stock_LocCSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);

  Procedure Stock_LocNSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);

  Procedure Stock_LocBinSubst(Var StockR  :  StockRec;
                                  Lc      :  Str10);

  Procedure Stock_LocLinkSubst(Var StockR  :  StockRec;
                                   Lc      :  Str10);

  Procedure Stock_LocRep1Subst(Var StockR  :  StockRec;
                                   Lc      :  Str10);

  Procedure Update_LocROTake(StockR  :  StockRec;
                             lc      :  Str10;
                             Mode    :  Byte);

{.$ENDIF}


 { =============== Split Line x Loc Object ============ }

Type

  MLIdRecPtr    =  ^MLIdRec;

  MLIdRec       =  Record
                     idFolio,
                     idLineNo    :  LongInt;

                     idPQty,
                     idQTLoc     :  Double;

                     idLoc       :  Str10;
                     idStockCode :  Str20;
                   end;


  MLIdOPtr     =  ^MLIdObj;

  MLIdObj      =  Object(List)
                     CarryFR   :  MLIdRecPtr;

                     CurrNode  :  NodePtr;

                     Constructor  Init;

                     Destructor   Done;

                     Procedure AddMLRec(IdR  :  Idetail;
                                        PQ,TQ
                                             :  Double;
                                        Locn :  Str10);

                     Procedure EditMLRec(IdR  :  Idetail;
                                         PQ,TQ
                                              :  Double;
                                         Locn :  Str10);

                     Function FindMLRec(IdR  :  Idetail;
                                        Locn :  Str10)  :  Boolean;

                     Function Check4CF(Var Idr  :  IDetail)  :  Boolean;

                     Function FindLQty(Var  IdR  :  Idetail;
                                            Locn :  Str10)  :  Double;


                     Procedure StoreLocQty(IdR    :  Idetail;
                                           PQ,TQ  :  Double;
                                           Locn   :  Str10);


                     Procedure CalcCases(Var Q,QM:  Real;
                                             SQ  :  Double);

                     Procedure SetIdQty(Var IdR  :  Idetail);

                     Function FindDir(First   :  Boolean)  :  Boolean;

                   end; {Object..}

{Var
  AutoMLId  :  MLIdOPtr;}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   Dialogs,
   ETStrU,
   ETDateU,
   ComnUnit,
   ComnU2,
   BTKeys1U,
   BTSupU1,
   SysU2,
   SupListU,
   {$IFNDEF EDLL}
   {$IFNDEF EXDLL}
     {$IFNDEF RW}
       {$IFNDEF WCA}
       {$IFNDEF ENDV}
       {$IFNDEF XO}
       {$IFNDEF EBAD}
         ExThrd2U,
       {$ENDIF}
       {$ENDIF}
       {$ENDIF}
       {$ENDIF}
     {$ENDIF}
   {$ENDIF}
   {$ENDIF}
   FIFOL2U,
   InvListU;





  { ---------------------------------------------------------------- }

  {  MLIdObj Methods }

  { ---------------------------------------------------------------- }




  Constructor MLIdObj.Init;

  Begin
    List.Init;

    CurrNode:=GetFirst;

  end;


  Destructor MLIdObj.Done;


  Var
    N  :  NodePtr;

  Begin
    N:=GetLast;

    While (N<>Nil) do
    Begin

      CarryFR:=N^.LITem;

      If (Assigned(CarryFR)) then
        Dispose(CarryFR);

      N^.LItem:=nil;

      N:=GetPrev(N);
    end;

    List.Done;

  end;


  Procedure MLIdObj.AddMLRec(IdR  :  Idetail;
                             PQ,TQ
                                  :  Double;
                             Locn :  Str10);


  Begin

    Add(New(MLIdRecPtr));

    CurrNode:=GetLast;

    CarryFR:=CurrNode^.LITem;

    FillChar(CarryFR^,Sizeof(CarryFR^),0);

    EditMLRec(IdR,PQ,TQ,Locn);

  end; {Proc..}


  Procedure MLIdObj.EditMLRec(IdR  :  Idetail;
                              PQ,TQ
                                   :  Double;
                              Locn :  Str10);

  Begin
    With IdR,CarryFR^ do
    Begin
      IdFolio:=FolioRef;
      IdLineno:=ABSLineNo;

      IdPQty:=PQ;
      IdQTLoc:=TQ;

      IdLoc:=Locn;
      IdStockCode:=StockCode;

    end; {With..}
  end;


  Function MLIdObj.FindMLRec(IdR  :  Idetail;
                             Locn :  Str10)  :  Boolean;

  Var
    Found  :  Boolean;

  Begin

    Found:=BOff;

    CurrNode:=GetFirst;

    While (CurrNode<>NIL) and (Not Found) do
    Begin
      CarryFR:=CurrNode^.LITem;

      With CarryFR^ do
      Begin
        Found:=(IdFolio=IdR.FolioRef) and (IdR.ABSLineNo=IdLineNo) and (IdStockCode=IdR.StockCode);

        If (Locn<>'') and (Found) then
          Found:=(Locn=IdLoc);
      end;


      If (Not Found) then
        CurrNode:=GetNext(CurrNode);

    end; {With..}

    FindMLRec:=Found;

  end; {Proc..}


  Function MLIdObj.Check4CF(Var  IdR  :  Idetail)  :  Boolean;

  Var
    Found  :  Boolean;

  Begin

    Found:=FindMLRec(IdR,'');

    If (Found) then
    With IdR, CarryFR^ do
    Begin
      Qty:=IdQTLoc;
      MLocStk:=IdLoc;
    end;
    Check4CF:=Found;

  end; {Proc..}


  Function MLIdObj.FindLQty(Var  IdR  :  Idetail;
                                 Locn :  Str10)  :  Double;

  Begin

    If (FindMLRec(IdR,Locn)) then
      FindLQty:=CarryFR^.idQTLoc
    else
      FindLQty:=0;


  end;


  Procedure MLIdObj.CalcCases(Var Q,QM:  Real;
                                  SQ  :  Double);

  Var
    EQty,
    RatQty  :  Double;

  Begin

    If (Stock.SellUnit>1) then
    With Stock do
    Begin
      RatQty:=DivWChk(SQ,SellUnit);

      Q:=Trunc(RatQty);

      QM:=Round_Up((SQ-(Q*SellUnit)),0);

      If (Q=0) and (SQ-Q<>0) then
        Q:=1;

      If (QM=0) or (Q>1) then
        QM:=SellUnit;
    end {With..}
    else
    Begin
      Q:=SQ;
      QM:=1;
    end;
  end;


  Procedure MLIdObj.SetIdQty(Var IdR  :  Idetail);

  Var
    DCnst
        :  Integer;
    SQ  :  Double;


  Begin
    If (FindMLRec(IdR,NdxWeight)) then
    With CarryFR^,IdR do
    Begin
      If (IdDocHed <> WOR) then
      Begin
        If (IdDocHed In StkAdjSplit) then
          DCnst:=-1
        else
          DCnst:=1;

        SQ:=((Qty*QtyMul)-((idPQty-idQTLoc)*DCnst));

        CalcCases(Qty,QtyMul,SQ);

        
      end
      else
      Begin
        QtyPick:=QtyPick-(IdPQty-idQTLoc); {Force qty pick to be what we have for this loc, and write off value of other locations}
        QtyPWOff:=idPQty*DocNotCnst;
      end;

      IdPQty:=0; IdQTLoc:=0;
    end;
  end;




  Procedure MLIdObj.StoreLocQty(IdR    :  Idetail;
                                PQ,TQ  :  Double;
                                Locn   :  Str10);


  Begin
    If (FindMLRec(IdR,Locn)) then
      EditMLRec(IdR,PQ,TQ,Locn)
    else
      AddMLRec(IdR,PQ,TQ,Locn);
  end;


  Function MLIdObj.FindDir(First   :  Boolean)  :  Boolean;

  Var
    Found  :  Boolean;

  Begin

    Found:=BOff;

    If (First) then
      CurrNode:=GetFirst
    else
      CurrNode:=GetNext(CurrNode);


    Found:=(CurrNode<>NIL);

    If (Found) then
      CarryFR:=CurrNode^.LITem;

    FindDir:=Found;

  end; {Proc..}



  { ============ Function to Return Free Stock for location ========= }

  Function FreeMLocStock(StockR  :  MStkLocType) :  Double;


  Begin

    With StockR do
    Begin

      If (Syss.FreeExAll) then
        FreeMLocStock:=lsQtyInStock
      else
        FreeMLocStock:=(lsQtyInStock-AllocMLocStock(StockR));

    end; {With..}

  end; {Func..}

    { ========== Function to return Picked or Allocated  ========== }
  Function AllocMLocStock(StockR  :  MStkLocType) :  Double;


  Begin

    With StockR do
    Begin
      If (Syss.UsePick4All) then
        Result:=lsQtyPicked
      else
        Result:=lsQtyAlloc;

    end; {With..}

  end; {Func..}


      { ========== Function to return Picked or Allocated  ========== }
  Function WORAllocMLocStock(StockR  :  MStkLocType) :  Double;


  Begin

    With StockR do
    Begin
      {$IFDEF WOP}
        If (Syss.UseWIss4All) then
          Result:=lsQtyPickWOR
        else
      {$ENDIF}
        Result:=lsQtyAllocWOR;

    end; {With..}

  end; {Func..}



{.$IFNDEF JC}

  Function LocOverride(lc    :  Str10;
                       Mode  :  Byte)  :  Boolean;

  Const
    Fnum  =  MLocF;

  Var
    TmpLoc  :  MLocPtr;

    LOk     :  Boolean;

    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;



  Begin
    Result:=BOff;

    New(TmpLoc);

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    TmpLoc^:=MLocCtrl^;

    LOk:=GetMLoc(Application.MainForm,lc,lc,'',-1);

    With MLocCtrl^.MLocLoc do
    Case Mode of

      0  :  Result:=loUsePrice;
      1  :  Result:=loUseNom;
      2  :  Result:=loUseCCDep;
      3  :  Result:=loUseSupp;
      4  :  Result:={loUseBinLoc;}BOn;
      5  :  Result:=loUseCPrice;
      6  :  Result:=loUseRPrice;


    end; {Case..}

    Result:=(LOk and Result);

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TmpLoc^;

    Dispose(TmpLoc);
  end;


  Function LocOPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocOPrice:=LocOverride(lc,0);

  end;

  Function LocONom(lc  :  Str10)  :  Boolean;

  Begin
    LocONom:=LocOverride(lc,1);

  end;


  Function LocOCCDep(lc  :  Str10)  :  Boolean;

  Begin
    LocOCCDep:=LocOverride(lc,2);

  end;

  Function LocOSupp(lc  :  Str10)  :  Boolean;

  Begin
    LocOSupp:=LocOverride(lc,3);

  end;

  Function LocOCPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocOCPrice:=LocOverride(lc,5);

  end;


  Function LocORPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocORPrice:=LocOverride(lc,6);

  end;


    { =========== Proc to return linked stock record ======== }
 { Duplicated in ExBtTh1U, TdexPost}

  Function LinkMLoc_Stock(lc  :  Str10;
                          sc  :  Str20;
                      Var TSL :  MStkLocType)  :  Boolean;

  Const
    Fnum      =  MLocF;
    Keypath   =  MLSecK;

  Var
    KeyS,
    KeyChk     :  Str255;

    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;
    TmpMLoc    :  MLocRec;


  Begin
    TmpMLoc:=MLocCtrl^;

    Blank(TSL,Sizeof(TSL));

    Result:=BOff;

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+Full_MLocLKey(lc,sc);

    KeyS:=KeyChk;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    TmpStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
    Begin
      Result:=BOn;
      TSL:=MLocCtrl^.MStkLoc;
    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TmpMLoc;


  end;


    { =========== Proc to return linked stock record ======== }

  Function LinkMLoc_Loc(lc  :  Str10;
                    Var TSL :  MLocLocType)  :  Boolean;

  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

  Var
    KeyS,
    KeyChk     :  Str255;

    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;
    TmpMLoc    :  MLocRec;


  Begin
    TmpMLoc:=MLocCtrl^;

    Blank(TSL,Sizeof(TSL));

    Result:=BOff;

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOn])+Full_MLocKey(lc);

    KeyS:=KeyChk;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    TmpStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
    Begin
      Result:=BOn;
      TSL:=MLocCtrl^.MLocLoc;
    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TmpMLoc;


  end;


  { Note: Duplicated in SalePric.Pas for OLE Server }
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


  { Note: Duplicated in SalePric.Pas for OLE Server }
  Procedure SetTakeUpdate(StockR   :  StockRec;
                      Var TStkLoc  :  MStkLocType);

  Begin
    With StockR, TStkLoc do
    Begin
      lsQtyFreeze:=QtyFreeze;
      lsQtyTake:=QtyTake;
      lsStkFlg:=StkFlg;
    end;
  end;


  { Note: Duplicated in SalePric.Pas for OLE Server }
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

      lsWOPWIPGL:=TLocLoc.loWOPWIPGL;

      lsCCDep:=TLocLoc.loCCDep;

      lsSaleBands:=StockR.SaleBands;

      lsCode1:=Full_MLocSKey(lsLocCode,lsStkCode);
      lsCode2:=Full_MLocLKey(lsLocCode,lsStkCode);

      SetROUpDate(StockR,TStkLoc);
    end;
  end;


  { ============= Procdure to maintain location deductions ============= }

  Procedure Stock_MLocDeduct(IdR     :  IDetail;
                             StockPos:  StockPosType;
                             DCnst   :  Integer;
                             GetSRec :  Boolean;
                             Mode    :  Byte);


  Const
    Fnum      =  MLocF;
    Keypath   =  MLSecK;


  Var
    KeyChk  :  Str255;

    FoundStr:  Str10;

    StkCCurr,
    FIFOMode,
    n       :  Byte;

    LAddr   :  LongInt;
    OStat   :  Integer;

    LOk,
    FoundOk,
    NewRec,
    Locked  :  Boolean;

    StkCost,
    StkQty,
    Rnum    :  Real;


    TLocLoc :  MLocLocType;
    TStkLoc :  MStkLocType;


  Begin
    LOK := False;
    Rnum:=0.0;

    FIFOMode:=0; StkCCurr:=0; StkCost:=0.0; StkQty:=0.0;

    Locked:=BOff;

    FoundStr:='';

    OStat:=Status;

    With IdR do                                      {* JA_X Replace with dedicated job code *}
      KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+Full_MLocLKey(MLocStk,StockCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

    NewRec:=(Status=4);

    If (Not EmptyKey(IdR.MLocStk,MLocKeyLen)) and (Is_FullStkCode(IdR.StockCode)) then
    Begin
      If ((StatusOk) or (NewRec))  then
      Begin


        If (NewRec) then
        With MLocCtrl^,MStkLoc do
        Begin
          GetMLoc(Application.MainForm,Idr.MLocStk,FoundStr,'',-1);

          TLocLoc:=MLocLoc;

          LOk:=BOn;
          Locked:=BOn;

          ResetRec(Fnum);

          RecPFix:=CostCCode;

          SubType:=CSubCode[BOff];

          lsLocCode:=Idr.MLocStk;

          SetROConsts(Stock,MStkLoc,TLocLoc);

          {* EN 570.045. Add moved to here, so no window for duplicates *}
          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);


          If (StatusOk) then  {* EN 570.045. Add moved to here, so no window for duplicates *}
          Begin

            Status:=GetPos(F[Fnum],Fnum,LAddr);

            NewRec:=Not StatusOk;
          end;
        end;

        If (Not NewRec) then
          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        With IdR,MLocCtrl^,MStkLoc do
        Begin
          Case Mode of
            0,2,3,99
               :  Begin

                    {*EN420}
                    If (AfterPurge(IdR.PYr,0)) then
                      For n:=1 to 2 do
                        lsQtyInStock:=lsQtyInStock+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);

                    If (Mode<>3) then
                      lsQtyAlloc:=lsQtyAlloc+(StockPos[3]*StkAdjCnst[IdDocHed]*DCnst);

                    lsQtyOnOrder:=lsQtyOnOrder+(StockPos[4]*StkAdjCnst[IdDocHed]*DCnst);

                    lsQtyPicked:=lsQtyPicked+(StockPos[5]*StkAdjCnst[IdDocHed]*DCnst);

                    {$IFDEF WOP}
                      lsQtyAllocWOR:=lsQtyAllocWOR+(StockPos[6]*StkAdjCnst[IdDocHed]*DCnst);
                      lsQtyIssueWOR:=lsQtyIssueWOR+(StockPos[7]*StkAdjCnst[IdDocHed]*DCnst);
                      lsQtyPickWOR:=lsQtyPickWOR+(StockPos[8]*StkAdjCnst[IdDocHed]*DCnst);
                    {$ENDIF}

                  end;

            1  :  Begin

                    For n:=1 to 2 do
                      lsQtyPosted:=lsQtyPosted+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);

                   end;

          end; {Case..}


          If (GetSRec) then
          Begin

            lsMinFlg:=((FreeMLocStock(MStkLoc)<lsQtyMin)) and (lsQtyMin<>0);

            {* Update last edited flag *}

            lsLastUsed:=Today;
            lsLastTime:=TimeNowStr;

            {* The original check for StkPUpSet and FIFO_Mode=1 was changed (v4.23p) because
                 it meant the location record cost only got updated by purchase transactions
                 and if last cost used which is incorrect *}

            If (DCnst=1) and (Mode=0) then
            Begin
              {$IFNDEF OC2_On}

                {$IFDEF PF_On}

                  Rnum:=0;

                  With Stock do
                    FIFOMode:=FIFO_Mode(SetStkVal(StkValType,SerNoWAvg,BOn));


                  If (AfterPurge(IdR.PYr,0)) then
                  Begin

                    If (FIFOMode=4) and (LocOCPrice(IdR.MLocStk)) then
                    Begin  {* Maintain Weighted Average Cost Price for loaction *}

                      Rnum:=(StockPos[(FIFOMode-3)]*StkAdjCnst[IdDocHed]*DCnst);

                      StkCost:=Stock.CostPrice;
                      StkCCurr:=Stock.PCurrency;
                      StkQty:=Stock.QtyInStock;

                      Stock.PCurrency:=lsPCurrency;
                      Stock.CostPrice:=lsCostPrice;
                      Stock.QtyInStock:=lsQtyInStock;

                      Case FIFOMode of

                        4  :  If (Rnum<>0) then
                                FIFO_AvgVal(Stock,IdR,Rnum);

                      end; {Case..}

                      lsCostPrice:=Stock.CostPrice;

                      Stock.CostPrice:=StkCost;
                      Stock.PCurrency:=StkCCurr;
                      Stock.QtyInStock:=StkQty;


                    end
                    else {v5.01 If item is std cost with override loc cost, or it is last cost and not a last cost item, then do not update the loc cost}
                    If ((FIFOMode<>6) or (Not LocOCPrice(IdR.MLocStk))) and ((IdR.IdDocHed In StkPUpSet) or (FIFOMode<>1)) then
                    Begin
                      lsPCurrency:=Stock.PCurrency;
                      lsCostPrice:=Stock.CostPrice;
                    end;
                  end;
                {$ENDIF}
              {$ENDIF}



              If (IdR.IdDocHed In StkPUpSet+[POR]) and (Not Syss.ManROCP) then {Auto update ro price}
              Begin
                lsROCurrency:=Stock.ROCurrency;
                lsROPrice:=Stock.ROCPrice;
              end;
            end;
          end;

          If (NewRec) then
            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
          else
          Begin
            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

            If (StatusOk) then
              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
          end;

          Report_BError(Fnum,Status);

        end;
      end;
    end;

   Status:=OStat;
 end; {Proc..}


 { ==== Procedure to Substitute Stock levels for location levels ==== }
 { Duplicated in ExBtTh1U, TdexPost, and MLocFunc (for TK)}
 
 Procedure Stock_LocFullSubst(Var StockR  :  StockRec;
                                  Lc      :  Str10;
                                  Mode    :  Byte);
 Var
   TSL     :  MStkLocType;
   n       :  Byte;
   FoundOk :  Boolean;



 Begin
   If (Syss.UseMLoc) and (Not EmptyKey(lc,MLocKeyLen)) and (Not EmptyKey(StockR.StockCode,StkKeyLen)) then
   With StockR,TSL do
   Begin

     FoundOk:=LinkMLoc_Stock(Lc,StockCode,TSL);


     Case Mode of
       0  :  Begin
               QtyInStock:=lsQtyInStock;
               QtyAllocated:=lsQtyAlloc;
               QtyOnOrder:=lsQtyOnOrder;
               QtyPosted:=lsQtyPosted;
               QtyPicked:=lsQtyPicked;
               QtyAllocWOR:=lsQtyAllocWOR;
               QtyIssueWOR:=lsQtyIssueWOR;
               QtyPickWOR:=lsQtyPickWOR;
               QtyMin:=lsQtyMin;
               QtyMax:=lsQtyMax;

             end;
       1  :  Begin
               {If (lsQtyMin<>0) then}
                 QtyMin:=lsQtyMin;

               {If (lsQtyMax<>0) then}
                 QtyMax:=lsQtyMax;

               MinFlg:=lsMinFlg;
               ROQty:=lsRoQty;
               RODate:=lsRODate;
               ROCCDep:=lsROCCDep;

               If (LocORPrice(lc)) then
               Begin
                 ROCPrice:=lsROPrice;
                 ROCurrency:=lsROCurrency;
               end;

               ROFlg:=lsROFlg;
             end;
       2  :  Begin
               QtyTake:=lsQtyTake;

               QtyFreeze:=lsQtyFreeze;
               StkFlg:=lsStkFlg;
             end;

       3  :  If (FoundOk) and (LocOPrice(lc)) then
               SaleBands:=lsSaleBands;

       4  :  If (FoundOk) and (LocONom(lc)) then
             Begin
               For n:=1 to NofSNoms do
                 NomCodes[n]:=lsDefNom[n];

               WOPWIPGL:=lsWOPWIPGL;
             end;

       5  :  If (FoundOk) and (LocOCPrice(lc)) then
             Begin
               PCurrency:=lsPCurrency;
               CostPrice:=lsCostPrice;
             end;
       6  :  If (FoundOk) and (LocOCCDep(lc)) then
               CCDep:=lsCCDep;

       7  :  If (FoundOk) then
               BinLoc:=lsBinLoc;

       8  :  If (FoundOk) and (LocORPrice(lc)) then
             Begin
               ROCurrency:=lsROCurrency;
               ROCPrice:=lsROPrice;

               If (LocOCCDep(lc)) then {This added in so that under re-order mode if overwrite cc/dep as well as overwrite ro is set}
               Begin
                 If (lsCCDep[BOff]<>'') and (Stock.ROCCDep[BOff]='') then
                   ROCCDep[BOff]:=lsCCDep[BOff];

                 If (lsCCDep[BOn]<>'') and (Stock.ROCCDep[BOn]='') then
                   ROCCDep[BOn]:=lsCCDep[BOn];

               end;
             end;

     end; {Case..}
   end;


 end;


  { ==== Procedure to Substitute Stock levels for location levels ==== }
 { Duplicated in ExBtTh1U, TdexPost, and MLocFunc (for TK)}

 Procedure Stock_LocSubst(Var StockR  :  StockRec;
                              Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,0);

 end;

  { ==== Procedure to Substitute Stock levels for location levels ==== }
 { Duplicated in ExBtTh1U, TdexPost}

 Procedure Stock_LocROSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,1);

 end;


 { ==== Procedure to Substitute Stock levels for location levels ==== }
 { Duplicated in ExBtTh1U, TdexPost}

 Procedure Stock_LocROCPSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,8);

 end;

   { ==== Procedure to Substitute Stock levels for location levels ==== }

 Procedure Stock_LocTKSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,2);

 end;

   { ==== Procedure to Substitute Stock levels for location levels ==== }

 Procedure Stock_LocPSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,3);

 end;


   { ==== Procedure to Substitute Stock levels for location levels ==== }

 Procedure Stock_LocCSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,5);

 end;

   { ==== Procedure to Substitute Stock levels for location levels ==== }

 Procedure Stock_LocNSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,4);

 end;


 { ==== Procedure to Substitute Stock levels for location levels ==== }

 Procedure Stock_LocLinkSubst(Var StockR  :  StockRec;
                                  Lc      :  Str10);

 Var
   n  :  Byte;

 Begin
   For n:=4 to 8 do {* Set Cost Price, Re-Order Price, Nominal Codes *}
     If (n In [4..6,8]) then
       Stock_LocFullSubst(StockR,Lc,n);
 end;

 { ==== Procedure to Substitute Stock levels for location levels ==== }

 Procedure Stock_LocRep1Subst(Var StockR  :  StockRec;
                                  Lc      :  Str10);

 Var
   n  :  Byte;

 Begin
   For n:=0 to 7 do {* Set Cost Price, Re-Order Price, Nominal Codes *}
     If (n In [0,1,5,7]) then
       Stock_LocFullSubst(StockR,Lc,n);
 end;


 Procedure Stock_LocBinSubst(Var StockR  :  StockRec;
                                 Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,7);

 end;



  { ============ Proc to fill in StkLoc records for each location ========= }
 { Duplicated in ExBtTh1U, TdexPost}

  Procedure Update_LocROTake(StockR  :  StockRec;
                             lc      :  Str10;
                             Mode    :  Byte);

  Const
    Fnum      =  MLocF;
    Keypath   =  MLSecK;


  Var
    KeyChk     :  Str255;

    FoundStr   :  Str10;

    LAddr      :  LongInt;
    OStat      :  Integer;

    LOk,
    Locked,
    NewRec     :  Boolean;

    TLocLoc    :  MLocLocType;

  Begin
    OStat:=Status;

    FoundStr:='';

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+Full_MLocLKey(lc,StockR.StockCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

    NewRec:=(Status=4);


    Locked:=BOff;

    If ((StatusOk) or (NewRec))  then
    Begin
      If (NewRec) then
      With MLocCtrl^,MStkLoc do
      Begin
        GetMLoc(Application.MainForm,lc,FoundStr,'',-1);

        TLocLoc:=MLocLoc;

        LOk:=BOn;
        Locked:=BOn;

        ResetRec(Fnum);

        RecPFix:=CostCCode;

        SubType:=CSubCode[BOff];

        lsLocCode:=lc;

        SetROConsts(StockR,MStkLoc,TLocLoc);

      end
      else
        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      Begin
        Case Mode of
          0  :  SetROUpdate(StockR,MLocCtrl^.MStkLoc);
          1  :  SetTakeUpdate(StockR,MLocCtrl^.MStkLoc);
        end; {Case..}

        If (NewRec) then
          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
        else
        Begin
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          If (StatusOk) then
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end;

        Report_BError(Fnum,Status);
      end; {If Locked Ok..}
    end; {If found/ new record}

    Status:=OStat;
  end;



 {.$ENDIF}


Begin

  {AutoMLId:=nil;}

end.
