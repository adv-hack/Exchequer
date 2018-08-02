Unit InvFSu2U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/96                      }
{                                                              }
{                   Inv List Support II Unit                   }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar, VarConst, BodgeFlags;


Procedure Set_UpId(IdR    :  IDetail;
               Var TmpId  :  IDetail);

  Procedure Store_StkId(      Fnum,
                              KeyPAth  :  Integer;
                        Var   LInv     :  InvRec;
                              LMode    :  Byte;
                              SetABSLNo:  Boolean;
                        // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
						Const InsertMode : Boolean;
                        Const SkipMoveEmUp : Boolean = False);

{$IFDEF STK}


  Procedure SetLink_Stock(Var  IdR     :  IDetail;
                          Var  LInv    :  InvRec;
                               LCust   :  CustRec;
                               L       :  LongInt;
                               KitFolio:  LongInt;
                               KitQty  :  Real;
                               LMode   :  Byte);

  Procedure Link_StockCtrl(Var IdR     :  IDetail;
                           Var LInv    :  InvRec;
                               LCust   :  CustRec;
                               L       :  LongInt;
                               KitFolio,
                               Level   :  LongInt;
                               KitQty  :  Real;
                               LMode   :  Byte;
                               InsMode :  Boolean;
                               LDPtr   :  Pointer);


  Procedure Re_CalcKitQty(OldQty,
                          NewQty   :  Real;
                          KitFolio :  LongInt;
                      Var LInv     :  InvRec;
                          IdR      :  Idetail);

  Procedure Calc_StockDeduct(InvFolio       :  LongInt;
                             CheckSOP       :  Boolean;
                             Mode           :  Byte;
                             LInv           :  InvRec;
                             ShowHLines     :  Boolean;
                             Const BodgeFlag : LongInt = StkDedNoBodge);


  Procedure Re_CalcKitOrd(OldQty,
                          NewQty,
                          OrdQty   :  Real;
                          DelDate  :  LongDate;
                          KitFolio :  LongInt;
                          IdR      :  IDetail);

  {$IFDEF SOP}
    Procedure Update_SOPFLink(Idr     :  IDetail;  {* Indirect unit call *}
                              Deduct,
                              UpHed,
                              Warn    :  Boolean;
                              Fnum,
                              Keypath,
                              KeyResP :  Integer);

  
  Procedure UpDate_OrdDel(InvR     :  InvRec;
                          UpDate,
                          UpPick   :  Boolean;
                          Sender   :  TObject);

  {$ENDIF}


  Function CanAutoPickBin(IdR     :  IDetail;
                          StockR  :  StockRec;
                          Mode    :  Byte)  :  Boolean;


{$ENDIF}

  Procedure Delete_Kit(KitFolio :  LongInt;
                       DispMode :  Byte;
                   Var LInv     :  InvRec);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   BtrvU2,
   ETMiscU,
   ETStrU,
   ETDateU,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   InvListU,
   MiscU,

   {$IFDEF STK}

     InvCT2SU,
     InvCTSUU,

     DiscU3U,

     {$IFDEF PF_On}

       InvLst2U,

       CuStkA3U,

       {$IFDEF SOP}
         InvLst3U,
         BomCmpU,

         AltCLs2U,

         Saltxl2U,
         SysU3,
         AdjCtrlU,
       {$ENDIF}

       StkBinU,

     {$ENDIF}

     SalTxl1U,

   {$ENDIF}


   SysU1,
   SysU2,

   BTSupU1,
   InvFSu3U,
   PassWR2U,
   CurrncyU,

   // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
   VarRec2U,
   JobUtils,

   SavePos;




  { ======== Set Up Default Stock ========= }

  Procedure Set_UpId(IdR    :  IDetail;
                 Var TmpId  :  IDetail);


  Begin

    Blank(TmpId,Sizeof(TmpId));

    With TmpId do
    Begin

      FolioRef:=IdR.FolioRef;

      DocPRef:=IdR.DocPRef;

      IDDocHed:=IdR.IDDocHed;

      LineNo:=Succ(IdR.LineNo);

      Currency:=IdR.Currency;

      CXRate:=IdR.CXRate;

      CurrTriR:=IdR.CurrTriR;

      {$IFDEF STK}
        LineType:=StkLineType[IdDocHed];
      {$ENDIF}

      ABSLineNo:=0;

      PYr:=IdR.PYr;
      PPr:=IdR.PPr;

      Payment:=IdR.Payment;

      Reconcile:=IdR.Reconcile;

      CustCode:=IdR.CustCode;

      PDate:=IdR.PDate;

      DocLTLink:=IdR.DocLTLink;

      MLocStk:=IdR.MLocStk;
    end; {With..}

  end; {Proc..}


  { ======= Procedure to Store artificial lines ======= }

  Procedure Store_StkId(      Fnum,
                              KeyPAth  :  Integer;
                        Var   LInv     :  InvRec;
                              LMode    :  Byte;
                              SetABSLNo:  Boolean;
                        // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
						Const InsertMode : Boolean;
                        Const SkipMoveEmUp : Boolean = False);

  Var
    TmpId  :  IDetail;

    TmpINo :  LongInt;

    // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
    MoveEmUpMode : enumMoveEmUpMode;

  Begin                                {* Before you start looking, there is no quicker way
                                          to speed this up. An atempt was made to avoid using
                                          moveEmUp on an add by recalling the lines in order,
                                          this is contained within move2.prg, but at the time
                                          prooved too complicated since all the other routines
                                          were geared around bringing the lines in in reverse
                                          order. Tests showed this renumbering does add
                                          time onto recalling the lines, only using it on an
                                          insert would improove things, but not dramaticaly*}

    // MH 21/01/2010: Added SkipMoveEmUp parameter to support new TL BoM helper which adds the
    // lines in the correct order so MoveEmUp is not required as standard
    If (Not SkipMoveEmUp) Then
    Begin
      TmpId:=Id;

      TmpIno:=Id.LineNo;

      If (TmpIno>1) then
        TmpIno:=Pred(Id.LineNo);


      // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
      If InsertMode Then
        MoveEmUpMode := mumInsert
      Else
        MoveEmUpMode := mumDefault;

      {*EN431MB2B*}
      If (LMode<>97) then
      Begin
        MoveEmUp(FullNomKey(Id.FolioRef),
                 FullIdKey(Id.FolioRef,LastAddrD),
                 FullIdKey(Id.FolioRef,TmpIno),
                 2,                         {* Increase x 2 so an insert works *}
                 Fnum,KeyPath,
                 // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                 MoveEmUpMode);

      end
      {*EN431MB2B*}
      else
      Begin
          MoveEmUp(FullNomKey(Id.FolioRef),
          FullIdKey(Id.FolioRef,-1000000),
          FullIdKey(Id.FolioRef,TmpIno),
                 2,                         {* Increase x 2 so an insert works *}
          Fnum,KeyPath,
          // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
          MoveEmUpMode);
      end;

      Id:=TmpId;
    End; // If (Not SkipMoveEmUp)


    LInv.ILineCount:=LInv.ILineCount+2; {* Normally 1 *}

    {If (Id.IdDocHed In OrderSet) then} {Disabled pre v5 I think}

    {v5.50.b63. Introduced this check here so additional description lines do not have an ABS line no set.
                An additional check on stockcode/ Kitlink may be necessary in case there are situations
                where this is valid and SetABSLNo is false}

    If (SetABSLNo) then {v5.50.065. }
      Id.ABSLineNo:=LInv.ILineCount;


    {$IFDEF STK}

      If (Not EmptyKey(Id.StockCode,StkKeyLen)) {*EN431MB2B*} and (LMode<>97) then
        Stock_Deduct(Id,LInv,BOn,BOn,0);

    {$ENDIF}

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);


    Report_BError(Fnum,Status);

    {*EN431MB2B*}
    If (LMode<>97) then
    Begin
      UpdateRecBal(Id,LInv,BOff,BOff,1);
        {$IFDEF STK}

          {$IFDEF PF_On}
            {$IFDEF JC}
              If (JbCostOn) and ((DetLTotal(Id,BOn,BOff,0.0)<>0) ) and (Id.LineNo>0)
                 and ((Id.LineNo<>RecieptCode) or (Not (Id.IdDocHed In PurchSet))) then
                Update_JobAct(Id,LInv);
             {$ENDIF}
           {$ENDIF}
        {$ENDIF}


      
    end;

  end; {Proc..}




{$IFDEF STK}

{LMode 98 =  Needs to recalculate VAT
       97 =  Multiple back to back, same as 98 except storing is handled differently
      254 =  For use in JC needed to reset the G/L code used}

  Procedure SetLink_Stock(Var  IdR     :  IDetail;
                          Var  LInv    :  InvRec;
                               LCust   :  CustRec;
                               L       :  LongInt;
                               KitFolio:  LongInt;
                               KitQty  :  Real;
                               LMode   :  Byte);


  Var
   Flg       :  Boolean;
   Rnum      :  Real;

   {$IFDEF SOP}

     TmpStk  :  ^StockRec;
     RODate  :  LongDate;
   {$ENDIF}

    // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
    JobCCDept: CCDepType;
  Begin
    {$IFDEF SOP}
      New(TmpStk);

      If (IdR.StockCode<>Stock.StockCode) then
        Global_GetMainRec(StockF,IdR.StockCode);

      TmpStk^:=Stock;
      Stock_LocLinkSubst(Stock,IdR.MLocStk);

      Stock_sdbSubst(Stock,IdR.sdbFolio);

    {$ENDIF}


    With Stock,IdR do
    Begin

      If (LInv.InvDocHed In PurchSplit) and (Syss.AutoValStk) and (StockType=StkBillCode) then
        NomCode:=NomCodeS[5]  {*When buying a BOM, force the GL to be WIP*}
      else
        NomCode:=NomCodeS[1+Ord((LInv.InvDocHed In PurchSplit))
                            +(2*Ord((LInv.InvDocHed In PurchSplit) and (Syss.AutoValStk)))];

      With LCust do {* For sales invoices, override account nominal code *}
      {v4.31 set for supplier as well, 431.004 or if supplier on blank lines only}
        If ((LInv.InvDocHed In SalesSplit) or (Not Is_FullStkCode(StockCode)))  and (DefNomCode<>0) then
          NomCode:=DefNomCode;

      {$IFDEF SOP}
        Set_StkCommod(IdR,Stock);

        If (LInv.InvDocHed = POR) and (LeadTime>0) then {Set Delivery date based on lead time}
        Begin
          RoDate:=CalcDueDatexDays(LInv.TransDate,LeadTime);
          PDate:=RODate;
        end;

      {$ENDIF}

      If (LMode<>254) then
      Begin

        DocLTLink:=StkLinkLT;

        With Stock do
          LWeight:=SWeight;


        If (LInv.InvDocHed In SalesSplit+ StkRetSalesSplit ) then
        Begin
          If (KitLink=0)  then
          Begin
            If (Not DPackQty) then
              QtyMul:=SellUnit;

            QtyPack:=SellUnit;;
          end;


          {$IFNDEF Pf_On}

            NetValue:=Get_StkPrice(SaleBands,Discount,DiscountChr,LInv.Currency,SellUnit,QtyMul,UsePack);

          {$ELSE}

            Flg:=BOn;

            Calc_StockPrice(Stock,LCust,LInv.Currency,Calc_IdQty(Qty,QtyMul,UsePack),LInv.TransDate,NetValue,
                            Discount,DiscountChr,MLocStk,Flg,0);

          {$ENDIF}


          {* To be replaced by FIFO *}


          Rnum:=0;

          If (Not Stock.ShowasKit) {or (KitLink<>0))} then {* Do not set cost price if Parent of Kit,
                                                             as cost set in lines which are recalled }
            Rnum:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,UsePack),Stock.PCurrency,
                                  Idr.Currency,UseCoDayRate);


          IdR.CostPrice:=Round_Up(Calc_IdQty(Rnum,QtyMul,Not UsePack),Syss.NoCosDec);

          NetValue:=Round_Up(NetValue,Syss.NoNetDec);


        end
        else
        Begin

          {$IFNDEF Pf_On}

            NetValue:=Currency_ConvFT(Stock.ROCPrice,Stock.ROCurrency,LInv.Currency,UseCoDayRate);

          {$ELSE}

            Flg:=BOn;

            Calc_StockPrice(Stock,LCust,LInv.Currency,Calc_IdQty(Qty,QtyMul,UsePack),LInv.TransDate, NetValue,
                            Discount,DiscountChr,IdR.MLocStk,Flg,0);

          {$ENDIF}


          If (KitLink=0)  then
          Begin
            If (Not DPackQty) then
              QtyMul:=BuyUnit;
            QtyPack:=BuyUnit;
          end;


          NetValue:=Round_Up(NetValue,Syss.NoCosDec);

          LWeight:=Stock.PWeight;

          If (LMode In [97,98]) then
            CalcVat(IdR,LInv.DiscSetl);

          {$IFDEF PF_On}

            With Stock do
              If (JBCostOn) and ((Not EmptyKey(JAnalCode,AnalKeyLen))) then
                AnalCode:=JAnalCode
              else
                If (LMode In [97,98]) then {Only force a blank if back to back mode}
                  Blank(AnalCode,Sizeof(AnalCode));


            If (JBCostOn) and ((EmptyKey(JAnalCode,AnalKeyLen)) and (LMode In[97,98])) then
              Blank(JobCode,Sizeof(JobCode));


            {* Override with WIP Nominal code *}

            NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

          {$ENDIF}

        end;

        {$IFDEF PF_On}
          {If (Not (LMode In [97,98])) then v4.32 method
            CCDep:=Stock.CCDep
          else
          Begin
            If (EmptyKey(CCDep[BOn],CCKeyLen)) then
              CCDep[BOn]:=Stock.CCDep[BOn];

            If (EmptyKey(CCDep[BOff],CCKeyLen)) then
              CCDep[BOff]:=Stock.CCDep[BOff];
          end;

          If (EmptyKey(CCDep[BOn],CCKeyLen)) then
            CCDep[BOn]:=LCust.CustCC;

          If (EmptyKey(CCDep[BOff],CCKeyLen)) then
            CCDep[BOff]:=LCust.CustDep;}

          // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
          JobUtils.GetJobCCDept(JobCode, JobCCDept);
          With LCust do
            CCDep := GetProfileCCDepEx(CustCC, CustDep, Stock.CCDep, CCDep, JobCCDept, Ord(LMode In [97,98]));

        {$ENDIF}
      end; {If Special LMode 254}
    end; {With..}

    {$IFDEF SOP}
      Stock:=TmpStk^;
      Dispose(TmpStk);
    {$ENDIF}
  end; {Proc..}



  { ======== Procedure to Link in a Stock Record ======== }

  Procedure Link_Stock(Var  IdR     :  IDetail;
                       Var  LInv    :  InvRec;
                            LCust   :  CustRec;
                            L       :  LongInt;
                            KitFolio:  LongInt;
                            KitQty  :  Real;
                            LMode   :  Byte;
                            LDescPtr:  Pointer;
                       // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
					   Const InsertMode : Boolean);


  Var
    n,DL      :  LongInt;

    TmpId     :  ^IDetail;
    TmpInv    :  ^InvRec;

    Rnum      :  Real;

    FoundOk,
    Flg       :  Boolean;

    LDesc     :  TLineDesc;

  Begin

    New(TmpId);

    New(TmpInv);

    TmpInv^:=Inv;

    LDesc:=nil;

    If (LDescPtr<>nil) then
    Begin
      LDesc:=LDescPtr;
      LDesc.ResetAllText;
    end;

    Rnum:=0;

    Flg:=BOff;

    With Stock do
    Begin

      FoundOk:=BOff;

      Begin

        n:=MaxStkDescs;

        Repeat

          FoundOk:=(Not EmptyKey(Desc[n],StkDesKLen));

          If (Not FoundOk) then
            Dec(n);

        Until (FoundOk) or (n=1);

        If (FoundOk) then
        With IdR do
        Begin

          If (LDescPtr<>nil) then
            For DL:=2 to n do
              LDesc.AddVisiRec('',0,0);

          Repeat


            TmpId^:=Id;


            Set_UpId(IdR,Id);

            Id.Desc:=Stock.Desc[n];


            If (KitFolio=0) then
              Id.KitLink:=StockFolio
            else
              Id.KitLink:=KitFolio;

            Id.UsePack:=CalcPack;
            Id.PrxPack:=PricePack;
            Id.ShowCase:=DPackQty;

			// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
            Store_StkId(IdetailF,IdFolioK,LInv,LMode,BOn,InsertMode);

            If (LDescPtr<>nil) then
            With LDesc,IdRec(n-2)^ do
            Begin
              fLine:=Id.Desc;
              fLineNo:=Id.LineNo;

              fNewAdd:=BOn; {* Flag to indicate it has been added from new, so we need to renumber everything *}
              HasDesc:=BOn;
            end;

            Dec(n);

            Id:=TmpId^;

          Until (n=1);

          If (LDescPtr<>nil) then
           LDesc.SetDescFields;

        end; {With & FoundOk..}

      end; {If Enough Lines..}

      Begin

        DL:=L;

        If (KitFolio<>0) then {* Other lines to follow *}
        Begin

        end;

        With IdR do
        Begin

          Desc:=Stock.Desc[1];


          Discount:=LCust.Discount;

          If (LCust.CDiscCh In StkBandSet) or (Discount<>0) then
            DiscountChr:=LCust.CDiscCh;

          VATCode:=Correct_PVAT(Stock.VATCode,LCust.VATCode);

          If (VATCode=VATICode) then
            VATIncFlg:=Stock.SVATIncFlg;

          QtyMul:=1;

          QtyPack:=QtyMul;

          KitLink:=KitFolio;


          UsePack:=CalcPack;
          PrxPack:=PricePack;
          ShowCase:=DPackQty;

          Qty:=KitQty;



          If (KitLink<>0) then
          Begin

            StockCode:=Stock.StockCode;

            LineNo:=Succ(IdR.LineNo);
          end;

          SetLink_Stock(IdR,LInv,LCust,L,KitFolio,KitQty,LMode);

        end;

        {* Set Inv here so an add has correct details *}

        Inv:=LInv;

        CalcVat(IdR,LInv.DiscSetl);

      end; {If Enough Lines ..}

    end; {With Stock..}

    Inv:=TmpInv^;

    Dispose(TmpId);
    Dispose(TmpInv);

  end; {Proc..}




  { ==== Procedure to Recall multiple kit links BOn to an invoice ==== }


  Procedure Link_StockCtrl(Var IdR     :  IDetail;
                           Var LInv    :  InvRec;
                               LCust   :  CustRec;
                               L       :  LongInt;
                               KitFolio,
                               Level   :  LongInt;
                               KitQty  :  Real;
                               LMode   :  Byte;
                               InsMode :  Boolean;
                               LDPtr   :  Pointer);



  Const

    Fnum     =  PWrdF;

    Keypath  =  PwK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;



  Var

    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    RecAddr  :  LongInt;

    TmpStock :  ^StockRec;

    TmpId,
    StkId    :  ^IDetail;

    IsAKit   :  Boolean;

    LevelPtr :  Pointer;


  Begin

    KeyS:='';

    If (Level=0) then
      LevelPtr:=LDPtr
    else
      LevelPtr:=nil;
    KeyChk:='';

    KeyStk:='';

    RecAddr:=0;

    New(TmpStock);

    New(TmpId);

    New(StkId);

    TmpStock^:=Stock;

    TmpID^:=IdR;

    StkId^:=IdR;

    IsAKit:=BOff;


    If (Stock.StockType=StkBillCode) and (((Stock.ShowasKit) and (LInv.InvDocHed In SalesSplit)) or
    ((Stock.KitOnPurch) and (LInv.InvDocHed In PurchSplit))) then
    With TmpStock^ do
    Begin

      If (Level=0) then
        KitFolio:=StockFolio;

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

      KeyS:=KeyChk+NdxWeight;

      Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With Password.BillMatRec do
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        KeySTk:=BillLink;

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

        If (StatusOk) then
        Begin
          IsAKit:=BOn;

          TmpId^:=StkId^;

          If (Stock.StockType=StkBillCode) and (Stock.ShowasKit or Stock.KitOnPurch) then
          Begin

            Link_StockCtrl(TmpId^,LInv,LCust,L,KitFolio,Succ(Level),(QtyUsed*KitQty),LMode,InsMode,nil);

            SetDataRecOfs(Fnum,RecAddr);

            Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          end
          else
            // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
			Link_Stock(TmpId^,LInv,LCust,L,KitFolio,(QtyUsed*KitQty),LMode,nil,InsMode);


          Id:=TmpId^;

          If (TmpStock^.KitPrice) and (LInv.InvDocHed In SalesSplit) then {* Ignore component price *}
          With Id do
          Begin
            NetValue:=0.0;
            Discount:=0.0;
            VAT:=0.0;

            // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
            Discount2:=0.0;
            Discount3:=0.0;
          end;

		  // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
          Store_StkId(IdetailF,IdFolioK,LInv,LMode,BOn,InsMode);

          {$IFDEF PF_On}
            If (Not (LMode In [97,98])) then
              Stock_AddCustAnal(Id,BOn,0);
          {$ENDIF}


        end;

        Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      Stock:=TmpStock^;

      TmpId^:=StkId^;

      If (Level=0) then
        KitFolio:=0;

    end; {If Kit..}

                           {* v5.00. As on b2b kit header is not generated, ignore any follow on desc only lines *}
    If (Not (LMode In [97,98])) or (Level<>0) or ((IsaKit) and (LMode<>97)) then
      // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
	  Link_Stock(TmpId^,LInv,LCust,L,KitFolio,KitQty,LMode,LevelPtr,InsMode)
    else
      SetLink_Stock(TmpId^,LInv,LCust,L,KitFolio,KitQty,LMode);


    IdR:=TmpId^;

    Dispose(TmpStock);
    Dispose(TmpId);
    Dispose(StkId);


  end; {Proc..}



  { ========= Procedure to Re_calc Kitting Qty ========= }

  Procedure Re_CalcKitQty(OldQty,
                          NewQty   :  Real;
                          KitFolio :  LongInt;
                      Var LInv     :  InvRec;
                          IdR      :  Idetail);




  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;

    UnitQty   :  Real;

    Loop,
    KitMatch,
    Locked    :  Boolean;

    ExStatus  :  Integer;

    LAddr     :  LongInt;

    TmpId,
    CopyId    :  ^IDetail;



  Begin


    New(TmpId);

    New(CopyId);

    TmpId^:=Id;

    KitMatch:=BOn;

    UnitQty:=0;

    Locked:=BOff;  Loop:=BOff;

    With IdR do
    Begin
      KeyChk:=FullNomKey(FolioRef);

      KeyS:=FullIdKey(FolioRef,Succ(LineNo));
    end;


    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (KitMatch) do
    With Id do
    Begin

      KitMatch:=(KitLink=KitFolio);

      If (KitMatch) then
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          UpdateRecBal(Id,LInv,BOn,BOff,1);

          CopyId^:=Id;

          Stock_Deduct(Id,LInv,BOff,BOn,0);


          UnitQty:=DivWChk(Qty,OldQty);

          Qty:=Round_Up((UnitQty*NewQty),Syss.NoQtyDec);

          {$IFDEF SOP}
            If (Syss.UseMLoc) then
              MlocStk:=IdR.MLocStk; {* Reset Location *}
          {$ENDIF}


          Stock_Deduct(Id,LInv,BOn,BOn,0);


          CalcVat(Id,LInv.DiscSetl);

          If (Syss.UseCCDep) then {*v5.00: If cc/ deps blank, take from parent line}
          Begin
            For Loop:=BOff to BOn do
              If (Id.CCDep[Loop]='') then
                Id.CCDep[Loop]:=IdR.CCDep[Loop];

          end;


          UpdateRecBal(Id,LInv,BOff,BOff,1);

          ExStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Report_Berror(Fnum,ExStatus);

          

          ExStatus:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          {$IFDEF SOP}
            If (CopyId^.Qty<>Id.Qty) then  {* Check SOP Link *}
            Begin
              Update_SOPFLink(CopyId^,BOn,BOff,BOff,IDetailF,IdLinkK,KeyPath);

              Update_SOPFLink(Id,BOff,BOff,BOn,IDetailF,IdLinkK,KeyPath);
            end;
          {$ENDIF}
        end; {If Ok..}

      end; {If Match..}

      If (KitMatch) then
        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    Id:=IdR;

    Dispose(CopyId);

    Dispose(TmpId);

  end; {Proc..}


  {$IFDEF SOP}

    { ======== Procedure to Update the SOP Link ======= }

    Procedure Update_SOPLink(Idr     :  IDetail;
                             Deduct,
                             UpHed,
                             Warn    :  Boolean;
                             Fnum,
                             Keypath,
                             KeyResP :  Integer);



    Var
      LAddr,
      RecAddr  :  LongInt;

      TmpId    :  ^IDetail;

      KeyS,
      KeyChk   :  Str255;

      Locked,
      FoundOk  :  Boolean;

      DedCnst  :  Integer;

      AdjVal,
      NewVal   :  Real;

      // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
      UseSerial: Boolean;
      UseBins: Boolean;
      StockKey: Str255;
    Begin

      FoundOk:=BOff;
      Locked:=BOff;

      AdjVal:=0;
      NewVal:=0;

      RecAddr:=0;

      If (Deduct) then
        DedCnst:=-1
      else
        DedCnst:=1;

      If (IdR.SOPLink<>0) then
      Begin

        New(TmpId);

        TmpId^:=Id;

        Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

        KeyChk:=FullIdKey(IdR.SOPLink,IdR.SOPLineNo);

        KeyS:=KeyChk;


        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
        Begin

          FoundOk:=(Id.LineNo>0);

          If (Not FoundOk) then
            Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

        If (FoundOk) then
        Begin

          If (UpHed) then
          Begin

            If (Qty_OS(Id)<>0) then
              Check_SOPLink(InvF,InvFolioK,Id.FolioRef,Id.PDate);


          end
          else
          Begin

            Locked:=BOff;

            Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If (Ok) and (Locked) then
            With Id do
            Begin

              AdjVal:=InvLOOS(Id,BOn,0);

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
              UseSerial := False;
              UseBins   := False;

              QtyDel:=QtyDel+Round_Up((IdR.Qty*DedCnst),Syss.NoQtyDec);

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock

              // Save the current Stock record, and locate the Stock record for
              // this line. Check whether it uses Serial Numbers or Multi-bins.
              With TBtrieveSavePosition.Create Do
              Begin
                Try
                  // Save the current position in the file for the current key
                  SaveFilePosition (StockF, GetPosKey);
                  SaveDataBlock (@Stock, SizeOf(Stock));

                  // Locate the Stock record
                  if FullStockCode(Stock.StockCode) <> FullStockCode(IdR.StockCode) then
                  begin
                    StockKey := FullStockCode(IdR.StockCode);
                    Status := Find_Rec(B_GetEq, F[StockF], StockF, Stock, StkCodeK, StockKey);
                    if not StatusOk then
                    begin
                      Report_BError(StockF, Status);
                    end;
                  end;

                  // Does this Stock item use Serial/Batch?
                  UseSerial := Stock.StkValType = 'R';
                  // Does this Stock item use Multi-bins?
                  UseBins := Stock.MultiBinMode;

                  // Restore position in file
                  RestoreSavedPosition;
                  RestoreDataBlock (@Stock);
                Finally
                  Free;
                End; // Try..Finally
              End; // With TBtrieveSavePosition.Create

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
              // Only adjust the Serial Quantity if the Stock record actually
              // uses Serial Numbers
              if UseSerial then
                SerialQty:=SerialQty+Round_Up(((IdR.Qty*IdR.QtyMul) * DedCnst),Syss.NoQtyDec);

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
              // Only adjust the Bin Quantity if the Stock record actually
              // uses Multi-bins
              if UseBins then
                BinQty:=BinQty+Round_Up(((IdR.Qty*IdR.QtyMul)*DedCnst),Syss.NoQtyDec);

              QtyWOff:=QtyWOff+Round_Up((IdR.QtyPWOff*DedCnst),Syss.NoQtyDec);

              If (Qty_OS(Id)=0) then
                LineType:=StkLineType[DocTypes(Ord(IdDocHed)+3)]
              else
                LineType:=StkLinetype[IdDocHed];

              Stock_Deduct(Id,Inv,Not Deduct,BOn,0);

              
              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              Report_BError(Fnum,Status);

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

              If (StatusOk) then {* Update match info *}
              Begin
                Change_Match(IdR,InvF,InvFolioK,Deduct);

                NewVal:=AdjVal-InvLOOS(Id,BOn,0);

                {* Update O/S information *}

                Update_SOPOS(InvF,InvFolioK,Id.FolioRef,Id,NewVal,(Not (TmpId^.IdDocHed In PSOPSet)));

              end;



              If (Warn) then
                Warn:=Warn_OverDelv(Id,IdR.SOPLink,BOff,BOn);

            end; {If Locked..}

          end; {If Not update header}

        end; {If Line Matched}

        SetDataRecOfs(Fnum,RecAddr);

        If (RecAddr<>0) then
          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0);

        Id:=TmpId^;

        Dispose(TmpId);

      end; {If Linked Line}

    end; {Proc..}



      { ========= Procedure to Re_calc Kitting Qty ========= }

  Procedure UpDate_OrdDel(InvR     :  InvRec;
                          UpDate,
                          UpPick   :  Boolean;
                          Sender   :  TObject);


  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;

    GetSNo,
    LOk,
    Locked    :  Boolean;

    LAddr     :  LongInt;

    ExStatus  :  SmallInt;

    OldId     :  IDetail;

  Begin


    Locked:=BOff;  GetSNo:=BOn;

    With InvR do
    Begin
      KeyChk:=FullNomKey(FolioNum);

      KeyS:=FullIdKey(FolioNum,1);
    end;


    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    LAddr:=0;

    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Id do
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      Begin
        If (UpDate) then
          PDate:=InvR.DueDate;

        If (UpPick) and (QtyPick<>0.0) then
        Begin
          OldId:=Id;

          QtyPick:=0.0;

          {$IFDEF STK}

            {$IFDEF SOP}
             If (Is_FullStkCode(StockCode))  then {* Re-Synch Stock record *}
             Begin
               If (Stock.StockCode<>StockCode) then
                 (Global_GetMainRec(StockF,StockCode)); {* Do not grab bin nos manually, as these will be reversed out automatically *}

               GetSNo:=(Not Stock.MultiBinMode) or (Not CanAutoPickBin(Id,Stock,0));
             end;

              ResetRec(StockF);

              If (GetSNo) then
                Control_SNos(Id,InvR,Stock,1,Sender);

            {$ENDIF}

             Deduct_AdjStk(OldId,InvR,BOff);

             If (CanAutoPickBin(Id,Stock,0)) then
               Auto_PickBin(OldId,InvR,OldId.QtyPick,Id.BinQty,1);

             Deduct_AdjStk(Id,InvR,BOn);

             If (CanAutoPickBin(Id,Stock,0)) then
               Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,0);

          {$ENDIF}

        end;


        ExStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_Berror(Fnum,ExStatus);

        ExStatus:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      end; {If Ok..}

      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
  end; {Proc..}



  {$ENDIF}






  Procedure Update_SOPFLink(Idr     :  IDetail;  {* Indirect unit call *}
                            Deduct,
                            UpHed,
                            Warn    :  Boolean;
                            Fnum,
                            Keypath,
                            KeyResP :  Integer);



  Begin

    {$IFDEF SOP}
      Update_SOPLink(IdR,Deduct,UpHed,Warn,Fnum,Keypath,KeyResP);
    {$ENDIF}
  end;








  { ======== Procedure to Control Stock Deduct Lines ====== }



  {* Scan IDetail Line Present and re_Calc stock deduct from them *}

  Procedure Calc_StockDeduct(InvFolio       :  LongInt;
                             CheckSOP       :  Boolean;
                             Mode           :  Byte;
                             LInv           :  InvRec;
                             ShowHLines     :  Boolean;
                             Const BodgeFlag : LongInt = StkDedNoBodge);


  Const
    Fnum      =  IDetailF;
    Keypath   =  IDFolioK;


  Var
    KeyS,
    KeyChk    :  Str255;

    StkFolio,
    RecAddr   :  LongInt;

    dNum      : Double;

  Begin
    StkFolio:=0;

    dNum := 0.0;

    KeyS:=FullIdkey(InvFolio,StkLineNo);  {* Remove any existing lines *}

    {$IFDEF SOP}
      If (ShowHLines) then
        Set_HiddenSer(LInv,17);
    {$ENDIF}

    Delete_StockLinks(KeyS,IdetailF,Length(KeyS),IdFolioK,BOn,LInv,0);

    KeyChk:=FullNomKey(InvFolio);

    KeyS:=FullIdkey(InvFolio,0);

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin

      If (Not EmptyKey(StockCode,StkKeyLen)) then   {* Deduct Lower Levels *}
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        {$IFDEF SOP}
          If (Stock.StockCode<>StockCode) then
            Global_GetMainRec(StockF,StockCode);

          StkFolio:=Stock.StockFolio;

        {$ENDIF}

        Gen_StockDeduct(Id,LInv,0,Mode,dNum,StkFolio,Id.ABSLineNo,BodgeFlag);

        SetDataRecOfs(Fnum,RecAddr);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

      end;


      {$IFDEF SOP}
        If (CheckSOP) then
          Update_SOPLink(Id,BOff,BOn,BOff,Fnum,IdLinkK,Keypath);
      {$ENDIF}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}


    {$IFDEF SOP}
      If (ShowHLines) then
      Begin
        Set_HiddenSer(LInv,18);

        {If (Not (LInv.InvDocHed In OrderSet)) then v4.32, extended to cope with SOR's}
          RetroSNBOM(LInv,Fnum,Keypath,InvF,InvFolioK,18);
      end;
    {$ENDIF}
  end; {Proc..}




  { ========= Procedure to Re_calc Kitting Qty ========= }

  Procedure Re_CalcKitOrd(OldQty,
                          NewQty,
                          OrdQty   :  Real;
                          DelDate  :  LongDate;
                          KitFolio :  LongInt;
                          IdR      :  IDetail);



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;

    UnitQty   :  Real;

    KitMatch,
    Locked    :  Boolean;

    ExStatus  :  Integer;

    TmpId     :  ^IDetail;

    LAddr,
    RecAddr   :  LongInt;



  Begin


    New(TmpId);

    TmpId^:=IdR;

    KitMatch:=BOn;

    UnitQty:=0;

    Locked:=BOff;

    RecAddr:=0;

    With IdR do
    Begin
      KeyChk:=FullNomKey(FolioRef);

      KeyS:=FullIdKey(FolioRef,Succ(LineNo));
    end;


    ExStatus:=GetPos(F[Fnum],Fnum,RecAddr);


    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (KitMatch) do
    With Id do
    Begin
      KitMatch:=((KitLink=KitFolio) or (KitLink<>0)) and (Not Is_FullStkCode(StockCode));

      If (KitMatch) then
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          If (IdDocHed In OrderSet) then
          Begin
            UnitQty:=DivWChk(Qty,OrdQty);

            If (Not Is_FullStkCode(StockCode)) then  {* Mod for description only lines to force inclusion *}
            Begin
              If (NewQty<>0) then
                UnitQty:=1
              else
                UnitQty:=0;

              QtyPick:=Round_Up((UnitQty*NewQty),Syss.NoQtyDec);  

            end;

            {QtyPick:=Round_Up((UnitQty*NewQty),Syss.NoQtyDec); Moved v4.23, as picked needs to be individual to avoid negative stock,
                                                                             and sno issues, also no stock deduct takes place here? *}

            PDate:=DelDate;

          end;

          {DocLTLink:=IdR.DocLTLink;}

          ExStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          Report_Berror(Fnum,ExStatus);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end; {If Ok..}

      end; {If Match..}

      If (KitMatch) then
        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    If (RecAddr<>0) then {* Preserve Posn *}
    Begin
      SetDataRecOfs(Fnum,RecAddr);

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
    end;


    Id:=TmpId^;

    Dispose(TmpId);
  end; {Proc..}


  { == Func to determine if auto pick allowed == }

  Function CanAutoPickBin(IdR     :  IDetail;
                          StockR  :  StockRec;
                          Mode    :  Byte)  :  Boolean;
  Begin
    Result:=BOff;

    If (StockR.StockCode=IdR.StockCode) then
    With StockR do
    Begin
      Result:=((Not (IdR.IdDocHed In PurchSplit-PurchCreditSet)) and ((Not (Idr.IdDocHed In WOPSplit)) or (Idr.LineNo>1))) or (Not MultiBinMode);

    end;
  end;



{$ENDIF}


  { ========= Procedure to delete kitting lines ========= }

  Procedure Delete_Kit(KitFolio :  LongInt;
                       DispMode :  Byte;
                   Var LInv     :  InvRec);



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;

    ExStatus  :  Integer;

    KitMatch,
    Locked    :  Boolean;

    LAddr,
    RecAddr   :  LongInt;

    TmpId     :  ^IDetail;



  Begin
    RecAddr:=0;

    New(TmpId);

    TmpId^:=Id;

    ExStatus:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve so we can lockit again *}

    {Report_BError(Fnum,ExStatus);  If we start with a blank tx we will ger an error 8 at this point}

    KitMatch:=BOn;

    Locked:=BOff;

    With Id do
    Begin
      KeyChk:=FullNomKey(FolioRef);

      KeyS:=FullIdKey(FolioRef,Succ(LineNo));
    end;


    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (KitMatch) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin

      KitMatch:=(KitLink=KitFolio);

      If (KitMatch) then
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          UpdateRecBal(Id,LInv,BOn,BOn,DispMode);

          {$IFDEF STK}
            If (Not EmptyKey(Id.StockCode,StkKeyLen)) then
            Begin
              Stock_Deduct(Id,LInv,BOff,BOn,0);

              {$IFDEF SOP}
                Update_SOPLink(Id,BOn,BOn,BOff,IDetailF,IdLinkK,KeyPath);
              {$ENDIF}

            end;
          {$ENDIF}

          ExStatus:=Delete_Rec(F[Fnum],Fnum,Keypath);

          Report_Berror(Fnum,ExStatus);

        end; {If Ok..}

      end; {If Match..}

      If (KitMatch) then
        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}


    If (RecAddr<>0) then
    Begin
      SetDataRecOfs(Fnum,RecAddr);

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0); {* Re-Establish Position *}
    end;

    Id:=TmpId^;

    Dispose(TmpId);

  end; {Proc..}





end.