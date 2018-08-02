Unit InvLst2U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 23/08/95                      }
{                                                              }
{                   General List Controller II                 }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses

  GlobVar,
  VarConst,
  BtrvU2;


Procedure Warn_AnalOverB(JC,JA :  Str10);



  Function Job_WIPNom(Const NCode  :  LongInt;
                      Const JCode,
                            ACode  :  Str10;
                      Const SCode  :  Str20;
                      Const LCode,
                            CCode  :  Str10)  :  LongInt;



Procedure Update_JobAct(Idr    :  IDetail;
                        InvR   :  InvRec);



Function Anal_FiltMode(DT  :  DocTypes)  :  Byte;



Function Get_BudgMUp(JCode,
                     ACode    :  Str10;
                     SCode    :  Str20;
                     Curr     :  Byte;
                 Var Charge,
                     CostUp   :  Double;
                     Mode     :  Byte)  :  Boolean;



Procedure Delete_JobAct(Idr    :  IDetail);

    Function Make_JAPDetl(InvR  :  InvRec;
                          IdR   :  IDetail;
                          mjMode:  Byte)  :  IDetail;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   VarJCstU,

   Forms,
   Dialogs,
   ETMiscU,
   ETStrU,
   ETDateU,
   ComnUnit,
   ComnU2,

   CurrncyU,
   {SupListU,}

   InvListU

     {$IFDEF STK}

       ,DiscU3U,

     {$ELSE}

      ,

     {$ENDIF}

     SysU2,

   {$IFDEF SOP}
     InvLst3U,
   {$ENDIF}

   {$IFDEF CU}
     Event1U,
   {$ENDIF}

   JobSup2U,

     SysU1,
   BtKeys1U,
   BTSupU1;






 { =================== Message to Warn Reciept Part to be entered manually ============== }

Procedure Warn_AnalOverB(JC,JA :  Str10);


Var
  mbRet  :  Word;


Begin
  mbRet:=MessageDlg(' - WARNING! - '+#13+
                      'Analysis Code : '+Strip('B',[#32],JA)+' for Job : '+Strip('B',[#32],JC)+','+#13+
                      'has gone over budget.'
                      ,mtWarning,[mbOk],0);

end;


  { * Calculate Anal Filter based on Doc Type *}

  Function Anal_FiltMode(DT  :  DocTypes)  :  Byte;



  Begin

    Result:=0;


    If (DT In SalesSplit) then
    Begin
      If (DT In RecieptSet) then
        Result:=7
      else
        Result:=1;
    end
    else
      If (DT In PurchSplit) then
        Result:=3
      else
        If (DT In StkAdjSplit) then
          Result:=2
        else
          If (DT In TSTSplit) then
            Result:=4;

    Anal_FiltMode:=Result;

  end;





    {* This routine replicated inside JobPostU! *}


    Function Job_WIPNom(Const NCode  :  LongInt;
                        Const JCode,
                              ACode  :  Str10;
                        Const SCode  :  Str20;
                        Const LCode,
                              CCode  :  Str10)  :  LongInt;


    Var
      KeyS    : Str255;

      StkKeyF : Str20;

      
      UseWIP,
      LOk     : Boolean;

      IsSubCon
            : Boolean;
      TmpJMisc
            : JobMiscRec;

    Begin
      UseWIP:=BOff;

      KeyS:='';

      IsSubCon:=BOff;

      Blank(TmpJMisc,Sizeof(TmpJMisc));

      Result:=NCode;

      If (Not EmptyKey(ACode,AnalKeyLen)) and (Not EmptyKey(JCode,JobKeyLen)) and (JBCostOn) then
      Begin

        If (JobRec^.JobCode<>JCode) then
          LOk:=Global_GetMainRec(JobF,JCode)
        else
          LOk:=BOn;


        If (LOk) then
        Begin

          {$IFDEF STKXX}{This has been taken out in v4.30c so that the alanyisys WIP is always used }

            If (Not EmptyKey(SCode,StkKeyLen)) and (Not (JobRec^.JobStat In [JobClosed,JobCompl])) then
            Begin

              If (SCode<>Stock.StockCode) then
                LOk:=Global_GetMainRec(StockF,SCode)
              else
                LOk:=BOn;

              If (LOk) then
              Begin
                {$IFDEF SOP}
                  Stock_LocNSubst(Stock,LCode);
                {$ENDIF}

                Result:=Stock.NomCodes[5];
              end;

            end
            else
            If (EmptyKey(SCode,StkKeyLen)) then {* Use anal code *}
          {$ENDIF}

            With JobMisc^.JobAnalRec do
            Begin

              If (JAnalCode<>ACode) then
                LOk:=GetJobMisc(Application.MainForm,ACode,StkKeyF,2,-1)
              else
                LOk:=BOn;

              If (LOk) then {* Set nom code dependant on Closed status *}
              Begin
                UseWIP:=(JobRec^.JobStat In [JobClosed,JobCompl]);

                If (JobMisc^.JobAnalRec.JAType=JobXLab) then {* We need to check for sub contract status *}
                Begin

                  TmpJMisc:=JobMisc^;
                  {$B-}
                  {v5.6. Only take G/L code from SS Sub contract if entering timesheets}

                  IsSubCon:=CheckRecExsists(PartCCKey(JARCode,JAECode)+CCode,JMiscF,JMTrdK) and (Not JobMisc^.EmplRec.LabPLOnly);
                  {$B+}

                  JobMisc^:=TmpJMisc;

                  If (IsSubCon) then
                  Begin  {* If also setup as an emloyee then always post direct to sub-contract control *}
                    Result:=SyssJob^.JobSetup.EmployeeNom[3,BOff];
                  end
                  else
                    Result:=WIPNom[UseWIP];

                end
                else
                  Result:=WIPNom[UseWIP];


              end;
            end;

        end; {If Job found ok..}

      end;

      Job_WIPNom:=Result;

    end;









  { ====== Func to Get on cost markup information ====== }

  { == Routine replicated for thread safe operation in JobPostU == }

Function Get_BudgMUp(JCode,
                     ACode    :  Str10;
                     SCode    :  Str20;
                     Curr     :  Byte;
                 Var Charge,
                     CostUp   :  Double;
                     Mode     :  Byte)  :  Boolean;


  Const
    Fnum     =  JCtrlF;
    Keypath  =  JCK;



  Var
    KeyS,
    KeyChk   :  Str255;


    FoundOk,
    AllowChrge,
    Loop     :  Boolean;

    HistPFix :  Char;

    NomBal,
    Purch,
    Sales,
    Cleared,
    Bud1,
    Bud2,
    Rnum,

    Dnum,
    Dnum2    :  Double;


  Begin

    If (Mode=1) then
    Begin
      Charge:=0.0;

      CostUp:=0.0;

    end;

    AllowChrge:=BOn;

    Loop:=BOff;

    KeyChk:=PartCCKey(JBRCode,JBSCode)+FullJBCode(JCode,0,SCode);

    Repeat

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      FoundOk:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk)-1,BOn)));

      If (FoundOk) then
      Begin


        Case Mode of

          1  :  Begin

                  AllowChrge:=JobCtrl^.JobBudg.ReCharge;

                  With JobCtrl^.JobBudg do
                    If ((FoundOk) and (AllowChrge)) then
                      Charge:=OverCost;

                  If (FoundOk) then
                    CostUp:=JobCtrl^.JobBudg.JBUpliftP;

                end;

          2,3
             :  With JobCtrl^.JobBudg do
                Begin

                  If (Mode=3) then
                    HistPFix:=CommitHCode
                  else
                    HistPFix:=JobRec^.JobType;

                  If (SyssJob^.JobSetUp.PeriodBud) then {* Set Budget from History *}
                  Begin
                    NomBal:=Total_Profit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                           GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,
                                           Bud1,Bud2,Dnum,Dnum2,BOn);

                    If (Bud2=0.0) and (Bud1<>0.0) then
                      Bud2:=Bud1;

                    AllowChrge:=(((NomBal+Charge)<Bud2) or (Bud2=0) or (Not Syss.WarnJC));
                  end
                  else
                  Begin
                    NomBal:=Profit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                           GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,BOn);

                    If (BrValue=0.0) and (BOValue<>0.0) then
                      BrValue:=BOValue;

                    AllowChrge:=(((NomBal+Charge)<BrValue) or (BrValue=0) or (Not Syss.WarnJC));
                  end;

                end;




        end; {Case..}

      end; {If match found..}

      KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJBCode(JCode,0,ACode);

      Loop:=Not Loop;

    Until (Not Loop) or ((FoundOk) and (AllowChrge)) or ((FoundOk) and (Mode<>1));


    Get_BudgMUp:=AllowChrge;

  end; {Func..}



  { ====== Proc to Generate Job Actual Record ======== }
  { == Routine replicated for thread safe operation in JobPostU == }


  Procedure Update_JobAct(Idr    :  IDetail;
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

    ConvChargeCurr
            :  Byte;

    TmpQ,
    TmpQM,

    CostUp,

    UpLift  :  Double;

    QPrice,
    QDisc   :  Real;

    CHDisc  :  Char;

    StkKeyF,
    TmpKey  :  Str20;

    OldCust :  CustRec;

    OStat   :  Integer;

    LAddr   :  LongInt;


  Begin

    Locked:=BOff;

    OldCust:=Cust;

    QPrice:=0;
    QDisc:=0;
    CHDisc:=#0;

    OStat:=Status;
    LOk:=BOff;

    CostUp:=0.0;  ConvChargeCurr:=0;


    TmpKey:='';

    With IdR do                                      {* JA_X Replace with dedicated job code *}
      KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

    NewRec:=(Status=4);

    {* Exclude empty job and auto daybook, Returns *}

    If (Not EmptyKey(IdR.JobCode,JobKeyLen)) and (InvR.NomAuto)
    and ((IdR.LineNo>=0) or (Not (InvR.InvDocHed In JAPSplit)))  and (InvR.InvDocHed<>JPT)
          and ((InvR.InvDocHed<>JST) or (EmptyKey(InvR.DeliverRef,DocKeyLen)))
     and ((Not (InvR.InvDocHed In JAPJAPSplit)) or (IdR.LineNo=0))
     and (Not (InvR.InvDocHed In StkRetSplit))  

     then
    Begin

      If ((StatusOk) or (NewRec))  then
      Begin


        If (NewRec) then
        With JobDetl^,JobActual do
        Begin

          LOk:=BOn;
          Locked:=BOn;

          ResetRec(Fnum);

          RecPFix:=JBRCode;

          SubType:=JBECode;

        end
        else
          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        With JobDetl^,JobActual do
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
            Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);

            Cost:=Round_up(IdR.NetValue,Syss.NoCosDec);
          end
          else
          If (IdR.IdDocHed In JAPSplit) then
          Begin
            Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);

            Case IdR.IdDocHed of
              JCT,JST  :  With IdR do
                            Cost:=Round_Up(CostPrice-QtyPWOff,Syss.NoCosDec);
              JPA,JSA  :  Cost:=Round_up(IdR.NetValue,2);
            end; {Case..}
          end
          else
          Begin

            {$IFDEF SOP}

              Qty:=Round_Up(Qty_OS(IdR),Syss.NoQtyDec);

            {$ELSE}

              {$IFDEF SOPDLL}
              Qty:=Round_Up(Qty_OS(IdR),Syss.NoQtyDec);
              {$ELSE}
              Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);
              {$ENDIF}

            {$ENDIF}


            If (IdR.IdDocHed In StkADJSplit) then {* Reverse affect on Job *}
              Qty:=Qty*DocNotCnst;


            With IdR do
            Begin

              TmpQ:=Qty;
              TmpQM:=QtyMul;

              Qty:=1; QtyMul:=1;

              If (IdDocHed<>ADJ) then
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
          If (AnalCode<>IdR.AnalCode) or (UpliftTotal<>0.0)  or (Idr.IdDocHed In JAPJAPSplit) then {* JA_X Replace with dedicated Analcode *}
          Begin

            If (Idr.IdDocHed In JAPJAPSplit) then
            Begin
              If (IdR.IdDocHed=JPA) then
                JAType:=SysAppPur
              else
                JAType:=SysAppSal;
            end
            else

            Begin

              AnalCode:=IdR.AnalCode;  {* JA_X Replace with dedicated Analcode *}

              If (JobMisc^.JobAnalRec.JAnalCode<>IdR.AnalCode) then
                LOk:=GetJobMisc(Application.MainForm,AnalCode,TmpKey,2,-1)
              else
                LOk:=BOn;

              If (LOk) then
                JAType:=JobMisc^.JobAnalRec.AnalHed;
            end;
          end;




          {$B-}

          If (Not (JDDT In SalesSplit+QuotesSet+PSOPSet + JAPSPlit  )) and
              (Get_BudgMUp(JobCode,AnalCode,StockCode,ActCurr,UpLift,CostUp,1)) then {* Recharge set *}
          Begin


          {$B+}

            ConvChargeCurr:=ActCurr;

            If (JobRec^.JobCode<>JobCode) then
              Global_GetMainRec(JobF,JobCode);

            Case JobRec^.ChargeType of

              CPChargeType  :  Charge:=Round_Up(Round_Up(Cost+(Cost*Pcnt(UpLift)),2)*Qty,2);

              TMChargeType  :  Begin
                                 If (JDDT=TSH) then
                                 Begin
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

                                           If (StockCode<>Stock.StockCode) then
                                             GetStock(Application.MainForm,StockCode,StkKeyF,-1);

                                           If (JobRec^.CustCode<>Cust.CustCode) then
                                             GetCust(Application.MainForm,JobRec^.CustCode,StkKeyF,BOff,-1);

                                           FoundOk:=BOn;

                                           Calc_StockPrice(Stock,Cust,ActCurr,Calc_IdQty(Qty,Idr.QtyMul,Not Stock.DPackQty),InvR.TransDate, QPrice,QDisc,CHDisc,IdR.MLocStk,FoundOk,0);

                                           Charge:=Round_Up(Round_Up(QPrice-Calc_PAmount(QPrice,QDisc,CHDisc),Syss.NoNetDec)*Round_Up(Calc_IdQty(Qty,Idr.QtyMul,Not Stock.DPackQty),Syss.NoQtyDec),2);

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
              CurrCharge:=JobRec^.CurrPrice;

            {$IFDEF CU}
              If (EnableCustBtns(5000,60)) then {We should apply extra rules}
              With JobMisc^.JobAnalRec do
              Begin
                Case JLinkLT of
                  1  :  Begin
                          Charge:=Round_Up(Cost*Qty,2);
                        end;

                end; {Case..}
              end;

            {$ENDIF}

            {* Calculate charge in charge currency v4.32.002 *}
            {* v5.52. Do not use Actcurr if coming directly from a cost plus timesheet as this would already be in charge currency *}

            Charge:=Currency_ConvFT(Charge,ConvChargeCurr,CurrCharge,UseCoDayRate);

          end;


          If (CostUp=0.0) and (Not (IdR.IdDocHed In JAPSplit))  then {* If budget uplift not set, use analysis records *}
          Begin
            If (JobMisc^.JobAnalRec.JAnalCode<>IdR.AnalCode) then
              LOk:=GetJobMisc(Application.MainForm,AnalCode,TmpKey,2,-1)
            else
              LOk:=BOn;

            If (LOk) then
              CostUp:=JobMisc^.JobAnalRec.UpliftP;

          end;

          If (CostUp<>0.0) and (Cost<>0.0) then {* Inflate Cost by uplift amount *}
          Begin
            UpliftTotal:=Round_Up(Cost*CostUp,Syss.NoCosDec);

            Cost:=Round_Up(Cost+UpliftTotal,Syss.NoCosDec);

            UpliftGL:=JobMisc^.JobAnalRec.UpliftGL;
          end;


          LedgerCode:=FullJDLedgerKey(JobCode,Posted,Invoiced,ActCurr,JDate);

          {* Only show these once posted, otherwise drill down shows them all *}

          RunKey:=FullJDRunKey(JobCode,PostedRun,JDate);

          LookKey:=FullJDLookKey(LineFolio,LineNo);



          If (JDDT=TSH) then
            EmplKey:=FullJDEmplKey(JobCode,EmplCode,ReconTS);

          If ((Qty=0) and (IdR.IdDocHed In PSOPSet+QuotesSet)) or
               ((Cost=0) and (IdR.IdDocHed In JAPSplit)) or
             ((Qty=0) and (Cost=0)) or ((IdR.LineNo=RecieptCode) and (IdR.IdDocHed In PurchSet)) then {* Remove actual record *}
          Begin

            If (Not NewRec) then
              Status:=Delete_Rec(F[Fnum],Fnum,Keypath)
            else
              Status:=0;

          end
          else
          Begin
            If (NewRec) then
              Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
            else
            Begin
              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              If (StatusOk) then
                Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
            end;

          end;

          Report_BError(Fnum,Status);


        end; {If Found and Locked}

      end {If Ok, or new}
      else
        Report_BError(Fnum,Status);
    end
    else
      If (Not NewRec) then {* It used to have a job code, now been deleted *}
      Begin

        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
          Status:=Delete_Rec(F[Fnum],Fnum,Keypath)

      end;


    Status:=OStat;

    Cust:=OldCust;
  end;



  { ====== Proc to Generate Job Actual Record ======== }
  { == Routine replicated for thread safe operation in JobPostU == }


  Procedure Delete_JobAct(Idr    :  IDetail);

  Const
    Fnum      =  JDetlF;
    Keypath   =  JDLookK;


  Var
    KeyChk  :  Str255;

    LOk,
    Locked  :  Boolean;

    LAddr   :  LongInt;


  Begin

    LOk:=BOff;
    Locked:=BOff;

    With IdR do
      KeyChk:=PArtCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);  {* JA_X Replace with dedicated job code *}

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

    If (StatusOk) then
    Begin


      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      Begin


        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        Report_BError(Fnum,Status);


      end; {If Found and Locked}

    end; {If Ok, or new}

  end;

    {* Manufacture Dummy id line for single line representative Apps line *}

    Function Make_JAPDetl(InvR  :  InvRec;
                          IdR   :  IDetail;
                          mjMode:  Byte)  :  IDetail;

    Begin
      Blank(Result,Sizeof(Result));

      With Result, InvR do
      Begin
        FolioRef:=FolioNum;

        DocPRef:=OurRef;

        LineNo:=0;

        NomMode:=TSTNomMode; {*EN560 ?? What is this mode, for dd of g/l? *}

        ABSLineNo:=0;

        IDDocHed:=InvDocHed;

        Currency:=InvR.Currency;

        CXRate:=InvR.CXRate;

        CurrTriR:=InvR.CurrTriR;

        PYr:=InvR.ACYr;
        PPr:=InvR.AcPr;

        PDate:=InvR.TransDate;

        Qty:=1.0;  QtyMul:=1;

        VATCode:=VATSTDCode;


        If (mjMode=0) then
        Begin
          JobCode:=InvR.DJobCode;


          If (PDiscTaken) then
            NetValue:=Calc_JAPDocTotal(InvR,BOn,2)
          else
            NetValue:=Calc_JAPAppTotal(InvR,BOn,0);
        end
        else
        Begin
          JobCode:=IdR.JobCode;

          NetValue:=IdR.NetValue;

          If (IdR.Reconcile<>0) then
            NetValue:=NetValue*DocNotCnst;

          AbsLineNo:=IdR.AbsLineNo;
        end;

        Payment:=DocPayType[PIN];
      end; {With..}
    end;


end.