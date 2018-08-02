unit RepJCB2U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TJBillReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       ValMode         :  Byte;

                       Procedure RepSetValTabs;

                       Procedure JobBillPage;

                       Procedure RepPrintPageHeader2;

                       Procedure VCalcStkTotals(LTot      :  Totals);

                       Procedure PrintDueTot(Gtot      :  Boolean);

                       Procedure StkEnd;

                       Function StkInclude  :  Boolean;

                       Procedure Get_JDPos(Var   LineTot    : Totals;
                                           Const JDetl      : JobDetlRec;
                                           Const RCr,RXlate : Byte);


                       Procedure StkLine;

                       Procedure JobBR_Detail;


                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                     public

                       CRepParam  :  JobCRep1Ptr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddJBillRep2Thread(LMode    :  Byte;
                             IRepParam:  JobCRep1Ptr;
                             AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  VarJCstU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  InvListU,
  RevalU2U,
  SalTxl1U,
  ExtGetU,
  JobSup1U,
  RpDefine,
  ExThrd2U;


{ ========== TSListReport methods =========== }

Constructor TJBillReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ValMode:=0;
end;


Destructor TJBillReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TJBillReport.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ValMode of

        0,1,10
         :  Begin
              SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 50, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
             end;

    end; {Case..}
  end; {With..}

end;



Procedure TJBillReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

       1 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TJBillReport.JobBillPage;


Begin

  With RepFiler1,CRepParam^,MTExLocal^ do
  Begin
    RepSetValTabs;

    Case ValMode of

      0,1
          :  Begin
               PrintJobLine(LJobRec^.JobCode,(CurrentPage>1))
             end;


    end; {case..}
  end; {With..}
end; {Proc..}


Procedure TJBillReport.RepPrintPageHeader2;


Begin
  RepSetValTabs;

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ValMode of

      0,1,10
          :  Begin
               // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
               Self.CRLF;

               SendLine(ConCat(#9,'Analysis',#9,'Description',#9,'Cost',#9,'M/Up%',#9,'Charge'));

               DefLine(-1,TabStart(1),TabEnd(5),0);
             end;




    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}




Procedure TJBillReport.VCalcStkTotals(LTot      :  Totals);

  Var
    nBo        :  Boolean;
    Rnum       :  Real;

  Begin

    Rnum:=0;

    With CRepParam^ do
    Case ValMode of

      0,1   :  Begin
                 GrandTotal(StkTot,LTot);

                 GrandTotal(RepTotal,LTot);
               end;

    end; {Case..With..}
  end;





  { ======================= Due Sub / Grand Total ================ }

Procedure TJBillReport.PrintDueTot(Gtot      :  Boolean);

Var
  n          :  Byte;
  Rnum       :  Real;
  PostTotMsg :  Str80;
  FoundOk    :  Boolean;

Begin

  PostTotMsg:='';

  With MTExLocal^, RepFiler1, CRepParam^ do
  Case ReportMode of

   1
       :  Begin
            If (Not Gtot) then
            Begin

              FoundOk:=LRepGetJobMisc(LastJob,2);

              With LJobMisc^.JobAnalRec do
                SendText(ConCat(#9,JAnalCode,#9,JAnalName));

              SendLine(ConCat(ConstStr(#9,3),FormatFloat(GenRealMask,StKTot[1]),
                            #9,FormatFloat(GenPcntMask,StKTot[3]),
                            #9,FormatFloat(GenRealMask,StKTot[2])));

            end
            else
            Begin

              StkTot:=RepTotal;

              SendLine(ConCat(ConstStr(#9,2),'Totals:',#9,FormatFloat(GenRealMask,StKTot[1]),
                            #9,#9,FormatFloat(GenRealMask,StKTot[2])));
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end;



            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}


  end; {Case..With..}

end;



  { ======================= Due End ======================= }


  Procedure TJBillReport.StkEnd;

  Var
    KitEnd     :  Str255;

    n,m        :  Byte;

  Begin

    With RepFiler1, CRepParam^ do
    Begin

      Case ValMode of

        0,1    :  Begin
                    RepSetValTabs;

                    PrintDueTot(BOff);

                    DefLine(-2,TabStart(2),TabEnd(5),0);

                    PrintDueTot(BOn);

                    RepSetTabs;

                  end;
      end; {Case..}
    end; {With..}
  end;





  { ======================= Due Include ======================= }


  Function TJBillReport.StkInclude  :  Boolean;


  Var
    ChrgeOn,
    TmpInclude :  Boolean;

    Dnum,
    Dnum2      :  Double;


  Begin
    Dnum:=0.0;  Dnum2:=0.0;
    TmpInclude := False;
    {$B-}

    With MTExLocal^, CRepParam^, RepFiler1, LJobDetl^.JobActual do
    Begin

      ChrgeOn:=LGet_BudgMUP(JobCode,AnalCode,StockCode,0,Dnum,Dnum2,1);


      Case ValMode of

        0,1
             :  Begin

                  TmpInclude:=(Posted
                               and ((RCr=ActCurr) or (RCr=0))
                               and ((Not (JDDT In PSOPSet+QuotesSet)))
                               and (PostedRun<>OrdPPRunNo)

                               and ((Not Invoiced) and (ChrgeOn or (Charge<>0))));

                  StkTot[3]:=Dnum;
                end;


      end; {Case..}


    end; {With..}

    {$B+}

   StkInclude:=TmpInclude;

  end; {Func..}


{ ======= Calculate & Return Value of Col ======== }

Procedure TJBillReport.Get_JDPos(Var   LineTot    : Totals;
                                 Const JDetl      : JobDetlRec;
                                 Const RCr,RXlate : Byte);


Var
  UOR   :  Byte;
  Dnum2,
  Dnum  :  Double;

  LOk   :  Boolean;


Begin
  UOR:=0;

  With MTExLocal^, JDetl.JobActual do
  Begin
    Dnum:=(Qty*Cost*DocCnst[JDDT]);

    If (JDDT In SalesSplit) then
      Dnum:=Dnum*DocNotCnst;

    Dnum2:=Charge;

    {$IFDEF MC_On}

      If (RCr=0) then
      Begin
        UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

        Dnum:=Round_Up(Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff),2);
      end;

      Dnum:=Currency_Txlate(Dnum,RCr,RXLate);

      Dnum2:=Round_Up(Currency_ConvFT(Dnum2,CurrCharge,RCr,UseCoDayRate),2);

      Dnum2:=Currency_Txlate(Dnum2,RCr,RXLate);

    {$ENDIF}

    LineTot[1]:=Dnum;
    LineTot[2]:=Dnum2;


  end;


end; {Proc..}




{ ======================= Analysis  Line ======================= }


Procedure TJBillReport.StkLine;

Var
  {LineTot    :  Totals;}

  GenStr2,
  GenStr     :  Str255;

  TBo        :  Boolean;


Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Blank(LineTot,Sizeof(LineTot));

    Case ValMode of
      0,1    :  With LJobDetl^.JobActual do
                 If (AnalCode<>LastJob) then
                 Begin
                   If (LastJob<>'') then
                     PrintDueTot(BOff);

                   LastJob:=AnalCode;

                 end;


    end; {Case..}

    Get_JDPos(LineTot,LJobDetl^,RCr,RTxCr);



    VCalcStkTotals(LineTot);
  end; {With..}
end;



Procedure TJBillReport.JobBR_Detail;



Const
  Fnum       =  JDetlF;
  Keypath    =  JDAnalK;


Var
  KeyCS,
  KeyChk     :  Str255;

  NewLine    :  Boolean;

  Rnum       :  Real;

  TmpKPath,
  TmpKPath2,
  TmpStat    :  Integer;

  TmpRecAddr,
  TmpRecAddr2
             :  LongInt;






Begin

  Rnum:=0;

  NewLine:=BOn;



  With MTExLocal^,CRepParam^ do
  Begin

    LastJobDetl^:=LJobDetl^;

    Blank(StkTot,Sizeof(StkTot));
    Blank(LineTot,Sizeof(LineTot));
    Blank(RepTotal,Sizeof(RepTotal));
    LastJob:='';


    Case ValMode of

      0,1
         :  Begin
              KeyChk:=PartCCKey(JBRCode,JBECode)+FullJobCode(LJobRec^.JobCode);
            end;
   end; {Case..}


   TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

   TmpKPath2:=Keypath;

    KeyCS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With CRepParam^ do
    Begin
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);


      If (StkInclude) then
      Begin
        If (NewLine) then
          RepPrintPageHeader2;

        NewLine:=BOff;

        StkLine;
      end;

      With RepFiler1 do
        If (LinesLeft<10) then
          ThrowNewPage(10);

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}


    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LJobDetl^:=LastJobDetl^;

    If (Not NewLine) then
      StkEnd;

    RepSetTabs;

  end; {With..}
end; {Proc..}



Procedure TJBillReport.RepPrintPageHeader;


Begin
  With RepFiler1,CRepParam^ do
  Begin

    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

        1
            :  SendLine(ConCat(#9,'Job Code',#9,'Job Name',#9,'Charge Type',#9,'Cash Recd',
                        #9,'S/L Retention',#9,'P/L Retention',#9,'Fixed Price',#9,'Invoiced'));

      end; {case..}

      DefFont(0,[]);
  end;
end; {Proc..}





Procedure TJBillReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

   Case ReportMode of

      1
          :  JobBillPage;


    end; {case..}

end;





Procedure TJBillReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case DDMode of
      0  : Begin
             SendRepDrillDown(1,TotTabs,1,FullJobCode(LJobRec^.JobCode),JobF,JobCodeK,0);

           end;

    end; {Case..}
  end; {With..}
end;


{ ======================= Customer Line ======================= }


Procedure TJBillReport.PrintReportLine;

Const
  GetBillBal  :  Array[1..4] of LongInt = (SysAnlsRcpt,SysAnlsSRet,SysAnlsPRet,SysAnlsRev);

Var

  Purch,Sales,Cleared,
  Bud1,Bud2,PostBal,

  Dnum,
  Dnum2      :  Double;

  GenStr     :  Str255;

  n          :  Byte;




Begin

  With MTExLocal^, RepFiler1, CRepParam^, LJobRec^ do
  Begin
    RepSetTabs;


    Case ReportMode of
      1  :  Begin
              For n:=1 to 4 do
              Begin

                LineTot[n]:=LTotal_Profit_To_Date(JobType,FullJDHistKey(JobCode,HFolio_TxLate(GetBillBal[n])),
                                  RCr,GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,
                                  Bud1,Bud2,Dnum,Dnum2,BOn);
              end;



              {$IFDEF MC_On}

                PostBal:=Round_Up(Currency_ConvFT(QuotePrice,CurrPrice,RCr,UseCoDayRate),2);

                PostBal:=Currency_Txlate(PostBal,RCr,RTxCr);

              {$ELSE}
                PostBal:=QuotePrice;


              {$ENDIF}

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;

              GenStr:=JobCHTDescL^[ChargeType];

              SetReportDrillDown(0);

              SendLine(ConCat(#9,JobCode,
                      #9,JobDesc,
                      #9,GenStr,
                      #9,FormatFloat(GenRealMask,LineTot[1]),
                      #9,FormatFloat(GenRealMask,LineTot[2]),
                      #9,FormatFloat(GenRealMask,LineTot[3]),
                      #9,FormatFloat(GenRealMask,PostBal),
                      #9,FormatFloat(GenRealMask,LineTot[4])));

              If (ChargeType In [CPChargeType,TMChargeType]) then
                JobBR_Detail;


            end;


    end; {Case..}

  end;
end;


{ ======================= Customer End ======================= }


Procedure TJBillReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin


  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJBillReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;


Begin

  TmpInclude:=BOff;


  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin


    Case ReportMode of

          1
             :  With LJobRec^ do
                Begin
                  TmpInclude:=((JobStat<JobCompl) and (JobType<>JobGrpCode));

                  If (TmpInclude) then
                  Begin

                    If (Not StkDetl) then
                      TmpInclude:=LJob_InGroup(JobFilt,LJobRec^);

                  end;
                end;


        end; {Case..}
    end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJBillReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    ThTitle:='Job Billing Rep';

    RepTitle:='Job Billing Report';

    PageTitle:=RepTitle;

    RFont.Size:=8;

    ROrient:=RPDefine.PoLandscape;

    RFnum:=JobF;

    RKeyPath:=JobCodeK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;


    If (StkDetl) or (EmptyKey(JobFilt,JobKeyLen)) then
      RepKey:=JobFilt;


  end; {With..}

  Result:=BOn;
end;





Procedure TJBillReport.Process;

Begin
  With CRepParam^ do
  If (Not StkDetl) then
    MTExLocal^.LGetMainRecPos(JobF,JobFilt);


  Inherited Process;

end;


Procedure TJBillReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJBillRep2Thread(LMode    :  Byte;
                             IRepParam:  JobCRep1Ptr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TJBillReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
          CRepParam^:=IRepParam^;


        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;





Initialization



Finalization

end.