unit OLEBtrO;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Controls, Forms, Messages, SysUtils, Windows, GlobVar,
     VarConst, ExBtTh1U;

Type
  TdOLEExLocalPtr = ^TdOLEExLocal;
  TdOLEExLocal = Object(TdPostExLocal)
  Private
    { ? }
  Public
    Function LGetJobMisc(ACode  :  Str10;
                         GMode  :  Byte)  :  Boolean;

    { HM 17/06/99: Copied from JobPostU }
    Procedure LUpdate_JobAct(Idr    :  IDetail;
                             InvR   :  InvRec);


    { HM 07/08/03: Copied from JobPostU }
    Procedure LSet_JMajorHed(JobR     :  JobRecType;
                             n        :  LongInt;
                             Fnum     :  Integer);

    { HM 07/08/03: Copied from JobPostU }
    Procedure LCheck_JMajorHed(JobR : JobRecType);

  End; { TdOLEExLocal }


implementation


Uses ETDateU,
     ETMiscU,
     ETStrU,
     BtrvU2,
     BtSupU1,
     BtKeys1U,
     //EntServF,
     CurrncyU,
     //OLEProgr,
     SalePric,
     SysU1,
     SysU2,
     JobSup1U,
     VarJCstU,
     Comnunit,
     Comnu2;


{ HM 17/06/99: Copied from JobPostU }
{ == Similar routine available for reports in Report1U; LRepGetJobMisc == }
Function TdOLEExLocal.LGetJobMisc(ACode  :  Str10;
                                  GMode  :  Byte)  :  Boolean;
Const
  Fnum     = JMiscF;
  Keypath  = JMK;
Var
  KeyChk  :  Str255;
Begin
  KeyChk:=FullJAKey(JARCode,JASubAry[GMode],ACode);

  //With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

    Result:=LStatusOk;
  end;

end;


{ HM 17/06/99: Copied from JobPostU }
{ EL 08/11/05: Added in additional check for apps
{ ====== Proc to Generate Job Actual Record ======== }
Procedure TdOLEExLocal.LUpdate_JobAct(Idr    :  IDetail;
                                  InvR   :  InvRec);

Const
  Fnum      =  JDetlF;
  Keypath   =  JDLookK;


Var
  KeyChk  :  Str255;

  FoundOk,
  NewRec,
  LOk,
  Locked  :  Boolean;

  CostUp,

  TmpQ,
  TmpQM,
  UpLift  :  Double;

  QPrice,
  QDisc   :  Real;

  CHDisc  :  Char;

  ConvChargeCurr
            :  Byte;

  StkKeyF,
  TmpKey  :  Str20;

  OldCust :  CustRec;

  OStat   :  Integer;

  {$IFDEF Rp}
    {$IFDEF STK}
      ShareRep    :  ^TStkReport;
    {$ENDIF}
  {$ENDIF}


Begin

{$DEFINE WIBBLE}

{$IFDEF WIBBLE}

  //With MTExLocal^ do
  Begin

    Locked:=BOff;

    OldCust:=LCust;

    QPrice:=0;
    QDisc:=0;
    CHDisc:=#0;

    CostUp:=0.0; ConvChargeCurr:=0;

    OStat:=LStatus;
    LOk:=BOff;

    TmpKey:='';

    With IdR do                                      {* JA_X Replace with dedicated job code *}
      KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);

    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

    NewRec:=(LStatus=4);

    If (Not EmptyKey(IdR.JobCode,JobKeyLen)) and (InvR.NomAuto) then
    {Apps & Vals v5.60.004, check for status of apps in process, ignore JPT & JST}
        and ((IdR.LineNo>=0) or (Not (InvR.InvDocHed In JAPSplit)))  and (InvR.InvDocHed<>JPT)
          and ((InvR.InvDocHed<>JST) or (EmptyKey(InvR.DeliverRef,DocKeyLen)))
     and ((Not (InvR.InvDocHed In JAPJAPSplit)) or (IdR.LineNo=0))
     {$IFDEF EN570} and (Not (InvR.InvDocHed In StkRetSplit))  {$ENDIF}

     then

    Begin

      If ((LStatusOk) or (NewRec))  then
      Begin


        If (NewRec) then
        With LJobDetl^,JobActual do
        Begin

          LOk:=BOn;
          Locked:=BOn;

          LResetRec(Fnum);

          RecPFix:=JBRCode;

          SubType:=JBECode;

        end
        else
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked);
          LGetRecAddr(Fnum);
        end;

        If (LOk) and (Locked) then
        With LJobDetl^,JobActual do
        Begin


          JobCode:=IdR.JobCode;  {* JA_X Replace with proper job code *}

          ActCurr:=IdR.Currency;
          ActYr:=IdR.PYr;
          ActPr:=IdR.PPr;
          LineFolio:=IdR.FolioRef;
          LineNo:=IdR.ABSLineNo;
          LineORef:=InvR.OurRef;
          StockCode:=IdR.StockCode;
          JDate:=InvR.TransDate;
          OrigNCode:=IdR.NomCode;
          JUseORate:=IdR.UseORate;
          JPriceMulX:=IdR.PriceMulX;


          If (IdR.IdDocHed=TSH) then
          Begin

            {Qty:=Idr.Qty;

            Cost:=IdR.NetValue; v5.00.001. EL: Rounded up here first.}

            Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);

            Cost:=Round_up(IdR.NetValue,Syss.NoCosDec);



          end
          else
          Begin

            {$IFDEF SOP}

              {Qty:=Qty_OS(IdR); v5.00.001. EL: Rounded up here first.}

              Qty:=Round_Up(Qty_OS(IdR),Syss.NoQtyDec);

            {$ELSE}

              {Qty:=IdR.Qty; v5.00.001. EL: Rounded up here first.}

              Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);

            {$ENDIF}


            If (IdR.IdDocHed In StkADJSplit) then {* Reverse affect on Job *}
              Qty:=Qty*DocNotCnst;


            With IdR do
            Begin

              TmpQ:=Qty;
              TmpQM:=QtyMul;

              Qty:=1; QtyMul:=1;

              If (IdDocHed<>ADJ) then
                // HM 04/08/03: Updated for unreplicated changes made in InvLst2U
                //Cost:=DetLTotalND(Idr,BOn,BOff,BOff,0.0)*LineCnst(Payment)
                Cost:=DetLTotalND(Idr,BOn,BOff,BOn,InvR.DiscSetl)*LineCnst(Payment)
              else
                Cost:=CostPrice;

              Qty:=TmpQ;
              QtyMul:=TmpQM;


            end;

          end;


          JDDT:=InvR.InvDocHed;



          ActCCode:=IdR.CustCode;

          UpLift:=0;

          If (JDDT=TSH) then
            EmplCode:=InvR.BatchLink;

                                        {*Refresh Job Misc if uplift already there as we will need the record loaded*}
          // HM 04/08/03: Updated for unreplicated changes made in InvLst2U
          //If (AnalCode<>IdR.AnalCode) then {* JA_X Replace with dedicated Analcode *}
          If (AnalCode<>IdR.AnalCode) or (UpliftTotal<>0.0) then {* JA_X Replace with dedicated Analcode *}
          Begin

            AnalCode:=IdR.AnalCode;  {* JA_X Replace with dedicated Analcode *}

            If (LJobMisc^.JobAnalRec.JAnalCode<>IdR.AnalCode) then
              LOk:=LGetJobMisc(AnalCode,2)
            else
              LOk:=BOn;

            If (LOk) then
              JAType:=LJobMisc^.JobAnalRec.AnalHed;
          end;




          {$B-}

          If (Not (JDDT In SalesSplit+QuotesSet+PSOPSet)) and
               (LGet_BudgMUp(JobCode,AnalCode,StockCode,ActCurr,UpLift,CostUp,1)) then {* Recharge set *}
          Begin


          {$B+}

            ConvChargeCurr:=ActCurr;
            
            If (LJobRec^.JobCode<>JobCode) then
              // HM 13/03/02: Modified call as not thread-safe - using global files which aren't open
              LGetMainRec{Pos}(JobF,JobCode);

            Case LJobRec^.ChargeType of

              CPChargeType  :  Charge:=Round_Up(Round_Up(Cost+(Cost*Pcnt(UpLift)),2)*Qty,2);

              TMChargeType  :  Begin
                                 If (JDDT=TSH) then
                                 Begin
                                   // HM 16/07/03: Added 'Charge:=' as it was missing - presumably from Feb03 mod
                                   Charge:=Round_up(Round_Up(IdR.CostPrice,Syss.NoNetDec)*Round_Up(Qty,Syss.NoQtyDec),2);


                                   ConvChargeCurr:=IdR.Reconcile;
                                 end


                                 {.$IFNDEF JC}

                                   else
                                   Begin

                                     {$IFDEF STK}

                                       {$IFDEF PF_On}

                                         If (Is_FullStkCode(StockCode)) then
                                         Begin

                                           If (StockCode<>LStock.StockCode) then
                                             // HM 13/03/02: Modified call as not thread-safe - using global files which aren't open
                                             LGetMainRec{Pos}(StockF,StockCode);

                                           If (LJobRec^.CustCode<>LCust.CustCode) then
                                             // HM 13/03/02: Modified call as not thread-safe - using global files which aren't open
                                             LGetMainRec{Pos}(CustF,LJobRec^.CustCode);

                                           FoundOk:=BOn;

                                           {$IFDEF Rp}

//                                             New(ShareRep,Create(Self.fMyOwner));
//
//                                             try
//                                               ShareRep^.MTExLocal:=Self.MTExLocal;
//
//                                               ShareRep^.Calc_StockPrice(LStock,LCust,ActCurr,Calc_IdQty(Qty,Idr.QtyMul,Not LStock.DPackQty),QPrice,QDisc,CHDisc,IdR.MLocStk,FoundOk);
//                                             finally
//
//                                               Dispose(ShareRep,Destroy);
//
//                                             end; {try..}
                                           {$ENDIF}

                                           // HM 04/08/03: Added this section as above section wasn't compiled in
                                           Calc_StockPrice(@Self,LStock,LCust,ActCurr,Calc_IdQty(Qty,Idr.QtyMul,Not LStock.DPackQty),QPrice,QDisc,CHDisc,IdR.MLocStk,FoundOk);


                                           Charge:=Round_Up(Round_Up(QPrice-Calc_PAmount(QPrice,QDisc,CHDisc),Syss.NoNetDec)*Round_Up(Calc_IdQty(Qty,Idr.QtyMul,Not LStock.DPackQty),Syss.NoQtyDec),2);

                                         end;

                                       {$ENDIF}
                                     {$ENDIF}

                                   end;

                                 {.$ELSE}

                                  ;

                                 {.$ENDIF}
                               end;

            end; {Case.}


            If (JDDT=TSH) then
              CurrCharge:=IdR.Reconcile
            else
              CurrCharge:=LJobRec^.CurrPrice;

            // HM 04/08/03: Updated for unreplicated changes made in InvLst2U
            {* Calculate charge in charge currency v4.32.002 *}
            {* v5.52. Do not use Actcurr if coming directly from a cost plus timesheet as this would already be in charge currency *}
            Charge:=Currency_ConvFT(Charge,ConvChargeCurr,CurrCharge,UseCoDayRate);

          end;


          If (CostUp=0.0) then {* If budget uplift not set, use analysis records *}
          Begin
            If (LJobMisc^.JobAnalRec.JAnalCode<>IdR.AnalCode) then
                LOk:=LGetJobMisc(AnalCode,2)
              else
                LOk:=BOn;

              If (LOk) then
                CostUp:=LJobMisc^.JobAnalRec.UpliftP;
          end;

          If (CostUp<>0.0) and (Cost<>0.0) then {* Inflate Cost by uplift amount *}
          Begin
            UpliftTotal:=Round_Up(Cost*CostUp,Syss.NoCosDec);

            Cost:=Round_Up(Cost+UpliftTotal,Syss.NoCosDec);

            UpliftGL:=LJobMisc^.JobAnalRec.UpliftGL;
          end;



          LedgerCode:=FullJDLedgerKey(JobCode,Posted,Invoiced,ActCurr,JDate);

          {* Only show these once posted, otherwise drill down shows them all *}

          RunKey:=FullJDRunKey(JobCode,PostedRun,JDate);

          LookKey:=FullJDLookKey(LineFolio,LineNo);

          If (JDDT=TSH) then
            EmplKey:=FullJDEmplKey(JobCode,EmplCode,ReconTS);

          // HM 13/03/02: Modified for compatibility with TPostJob.LUpdate_JobAct
          If ((Qty=0) and (IdR.IdDocHed In PSOPSet+QuotesSet)) or
             ((Qty=0) and (Cost=0)) or ((IdR.LineNo=RecieptCode) and (IdR.IdDocHed In PurchSet)) then {* Remove actual record *}
               //(Qty*Cost=0) or ((IdR.LineNo=RecieptCode) and (IdR.IdDocHed In PurchSet)) then {* Remove actual record *}
          Begin

            If (Not NewRec) then
              LStatus:=LDelete_Rec(Fnum,Keypath)
            else
              LStatus:=0;

          end
          else
          Begin
            If (NewRec) then
              LStatus:=LAdd_Rec(Fnum,KeyPath)
            else
            Begin
              LStatus:=LPut_Rec(Fnum,KeyPath);

              LStatus:=LUnLockMLock(Fnum);
            end;

          end;

          LReport_BError(Fnum,LStatus);


        end; {If Found and Locked}

      end {If Ok, or new}
      else
        LReport_BError(Fnum,LStatus);
    end
    else
      If (Not NewRec) then {* It used to have a job code, now been deleted *}
      Begin

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
          LStatus:=LDelete_Rec(Fnum,Keypath)

      end;


    LStatus:=OStat;

    LCust:=OldCust;
  end; {with..}

{$ENDIF} { WIBBLE }

end;

//-------------------------------------------------------------------------

{ Reproduced in JobSup1U for Global operation }
Procedure TdOLEExLocal.LSet_JMajorHed(JobR     :  JobRecType;
                                  n        :  LongInt;
                                  Fnum     :  Integer);
Begin
  With {MTExLocal^,}LJobCtrl^,JobBudg do
  Begin

    LResetRec(Fnum);

    RecPFix:=JBRCode;
    SubType:=JBMCode;

    JobCode:=JobR.JobCode;

    HistFolio:=HFolio_Txlate(n);

    If (n<>0) then
      AnalHed:=n
    else
      AnalHed:=SysAnlsProfit;

    BudgetCode:=FullJBCode(JobCode,CurrBudg,FullNomKey(HistFolio));

  end; {If Ok..}
end; {Proc..}

//-------------------------------------------------------------------------

{ ====== Proc to Generate a jobs major Heading Lines ======= }
{ Reproduced in JobSup1U for Global operation }
Procedure TdOLEExLocal.LCheck_JMajorHed(JobR     :  JobRecType);
Const
  Fnum      =  JCtrlF;
  Keypath   =  JCK;
Var
  KeyChk,
  KeyS      :  Str255;

  n         :  LongInt;
Begin
  //With MTExLocal^ do
  Begin
    LStatus:=0;

    For n:=0 to NofSysAnals do
    Begin

      If (LStatusOk) then
      With LJobCtrl^,JobBudg do
      Begin

        LSet_JMajorHed(JobR,n,Fnum);

        KeyChk:=PartCCKey(JBRCode,JBMCode)+BudgetCode;

        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyS);

        If (Not LStatusOk) then
        Begin
          LSet_JMajorHed(JobR,n,Fnum);

          LStatus:=LAdd_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);
        end;

      end; {If Ok..}

    end; {Loop..}
  end; {With..}
end; {Proc..}

//-------------------------------------------------------------------------

end.
