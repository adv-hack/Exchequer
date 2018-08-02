unit RepJCB1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TJBudgReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       ValMode         :  Byte;
                       GlobAnalCode    :  SmallInt;

                       Procedure RepSetValTabs;

                       Procedure JobBudgPage;

                       Procedure RepPrintPageHeader2;

                       Procedure Job_BudgTot(SType    :  Char;
                                             JCode    :  Str10;
                                             AFolio   :  LongInt;
                                             Rcr,RXLate,
                                             RYr,RPr,
                                             RYr2,RPr2:  Byte;
                                         Var LineTot  :  Totals);

                       Function StkInclude  :  Boolean;

                       Procedure JobBStdLine(Const LineTot   :  Totals;
                                                   LineDesc  :  Str80;
                                             Const ShowQty   :  Boolean;
                                             Const Mode      :  Byte);

                       Procedure StkLine;

                       Procedure JobBR_Detail;


                       Function GetReportInput  :  Boolean; Virtual;

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

                   
Procedure AddJBudgRep2Thread(LMode    :  Byte;
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

Constructor TJBudgReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ValMode:=0;
  GlobAnalCode:=0;
end;


Destructor TJBudgReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TJBudgReport.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ValMode of

        0,1,10
         :  Begin
              SetTab (MarginLeft, pjLeft, 50, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 25, 4, 0, 0);
             end;

    end; {Case..}
  end; {With..}
end;



Procedure TJBudgReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

       1 :  Begin
              RepSetValTabs;
            end;


    end; {Case..}
  end; {With..}
end;



Procedure TJBudgReport.JobBudgPage;


Begin

  With RepFiler1,CRepParam^,MTExLocal^ do
  Begin

    Case ValMode of

      0,1
          :  Begin
               PrintJobLine(LJobRec^.JobCode,(CurrentPage>1))
             end;


    end; {case..}
  end; {With..}
end; {Proc..}


Procedure TJBudgReport.RepPrintPageHeader2;


Begin
  RepSetValTabs;

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ValMode of

      0,1,10
          :  Begin
               JobBudgPage;

               // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
               Self.CRLF;

               SendLine(ConCat(#9,Major_Hed(GlobAnalCode),#9,'Orig Budget',#9,'Rev.Budget',#9,'Actual',#9,'Variance',#9,'%'));

               // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
               Self.CRLF;
             end;




    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}




Procedure TJBudgReport.Job_BudgTot(SType    :  Char;
                                   JCode    :  Str10;
                                   AFolio   :  LongInt;
                                   Rcr,RXLate,
                                   RYr,RPr,
                                   RYr2,RPr2:  Byte;
                               Var LineTot  :  Totals);



Var
  Purch,Sales,Cleared,
  Bud1,Bud2,
  PostBal,
  Result,
  Result2,
  Result3,
  Result4,


  Dnum,
  Dnum2    :  Double;

  NYr,
  NPr      :  Byte;

  Diff,
  N,
  TmpStatus
           :  Integer;


Begin

  Diff:=Succ(((RYr2-RYr)*Syss.PrInYr)+(RPr2-RPr));

  Blank(LineTot,Sizeof(LineTot));

  NYr:=RYr; NPr:=RPr;

  With MTExLocal^ do
  Begin

    TmpStatus:=LStatus;

    For n:=1 to Diff do
    Begin

      If (n>1) then
        AdjPr(Nyr,NPr,BOn);


      PostBal:=LTotal_Profit_To_Date(SType,FullJDHistKey(JCode,AFolio),RCr,NYr,NPr,Purch,Sales,Cleared,
                                    Bud1,Bud2,Dnum,Dnum2,BOff);

      Result:=PostBal;

      Result2:=Bud2;

      Result3:=Bud1;

      {$IFDEF MC_On}

        Result:=Currency_Txlate(Result,RCr,RXLate);

        Result2:=Currency_Txlate(Result2,RCr,RXLate);

        Result3:=Currency_Txlate(Result3,RCr,RXLate);

      {$ENDIF}



      LineTot[2]:=LineTot[2]+Result;
      LineTot[4]:=LineTot[4]+Cleared;


      If (SyssJob^.JobSetUp.PeriodBud) then {* Set Budget from History *}
      Begin
        LineTot[1]:=LineTot[1]+Result2;
        LineTot[3]:=LineTot[3]+Dnum2;
        LineTot[5]:=LineTot[5]+Result3;
        LineTot[6]:=LineTot[6]+Dnum;

      end;


    end; {Loop..}

    If (Not SyssJob^.JobSetUp.PeriodBud) then
    With LJobCtrl^.JobBudg do
    Begin
      {$IFDEF EX601}
        LineTot[1]:=JBBCurrency_Txlate(BRValue,JBudgetCurr,RCr);
        LineTot[5]:=JBBCurrency_Txlate(BOValue,JBudgetCurr,RCr);

        {$IFDEF MC_On}

          LineTot[1]:=Currency_Txlate(LineTot[1],RCr,RXLate);

          LineTot[5]:=Currency_Txlate(LineTot[5],RCr,RXLate);

        {$ENDIF}

      {$ELSE}

        LineTot[1]:=BRValue;
        LineTot[5]:=BOValue;
      {$ENDIF}


      LineTot[3]:=BRQty;
      
      LineTot[6]:=BOQty;

    end;

    LStatus:=TmpStatus;

  end; {With..}
end;






  { ======================= Due Include ======================= }


  Function TJBudgReport.StkInclude  :  Boolean;


  Var
    TmpInclude :  Boolean;


  Begin
    TmpInclude := False;

    {$B-}

    With MTExLocal^, CRepParam^, RepFiler1, LJobCtrl^.JobBudg do
    Begin

      Job_BudgTot(LJobRec^.JobType,JobCode,HistFolio,RCr,RTxCr,RYr,RPr,RYr2,RPr2,LineTot);

      Case ValMode of

          0,1
               :
                  Begin

                    TmpInclude:=((LineTot[2]<>0.0) or (ShowER));


                    {$IFDEF EX601}
                      {$IFDEF MC_On}
                        TmpInclude:=TmpInclude and ((RCr=0) or (JBudgetCurr=RCr));

                      {$ENDIF}

                    {$ENDIF}

                  end;

        end; {Case..}



      end; {With..}

      {$B+}



      StkInclude:=TmpInclude;
  end; {Func..}


  Procedure TJBudgReport.JobBStdLine(Const LineTot   :  Totals;
                                           LineDesc  :  Str80;
                                     Const ShowQty   :  Boolean;
                                     Const Mode      :  Byte);


  Var

    TBo        :  Boolean;

    BudTot,
    ActTot,
    OrgTot,
    Rnum1,
    Rnum2      :  Real;

    VarL       :  Byte;




  Begin

    With MTExLocal^, RepFiler1 do
    Begin

      Case Mode of


       0,1
          :  Begin

               If (Mode=1) then
                 VarL:=10
               else
                 VarL:=0;

               If (ShowQty) then
               Begin
                 BudTot:=LineTot[3];
                 ActTot:=LineTot[4];
                 OrgTot:=LineTot[6];
               end
               else
               Begin

                 BudTot:=LineTot[1];
                 ActTot:=LineTot[2];
                 OrgTot:=LineTot[5];

               end;

               If (BudTot<>0.0) then
               Begin
                 Rnum1:=BudTot-ActTot;
                 Rnum2:=(DivWChk(ActTot,BudTot)*100);

               end
               else
               Begin
                 Rnum1:=OrgTot-ActTot;
                 Rnum2:=(DivWChk(ActTot,OrgTot)*100);

               end;

               
               {* Note use of VarL b4/after desc for detailed version *}

               SendLine(ConCat(#9,Spc(VarL),LineDesc,
                               #9,FormatFloat(GenRealMask,OrgTot),
                               #9,FormatFloat(GenRealMask,BudTot),
                               #9,FormatFloat(GenRealMask,ActTot),
                               #9,FormatFloat(GenRealMask,Rnum1),
                               #9,FormatFloat(GenPcntMask,Rnum2)));

             end;

      end; {Case..}
    end; {With(s)..}
  end;


  { ======================= Due Line ======================= }


  Procedure TJBudgReport.StkLine;


  Var
    Rnum,
    Rnum2      :  Double;

    TBo        :  Boolean;

    TmpTot     :  Totals;

    GenStr     :  Str255;




  Begin
    Rnum:=0;

    Rnum2:=0;


    With MTExLocal^, RepFiler1, CRepParam^, LJobCtrl^.JobBudg do
    Begin


      Case ValMode of


        0
           :  Begin

                

                If (Not LRepGetJobMisc(AnalCode,2)) then
                  LResetRec(JMiscF);

                GenStr:=LJobMisc^.JobAnalRec.JAnalName;

                {$B-}

                If (StkDetl) and (LCheckExsists(PartCCKey(JBRCode,JBSubAry[2])+
                                               FullJDAnalKey(JobFilt,LJobMisc^.JobAnalRec.JAnalCode),
                                               JCtrlF,JCSecK)) then
                Begin

                {$B+}

                  SendLine(ConCat(#9,GenStr));

                  ValMode:=1;

                  StkDetl:=BOff;

                  TmpTot:=LineTot;

                  Blank(LineTot,Sizeof(LineTot));

                  JobBR_Detail;

                  LineTot:=TmpTot;

                  ValMode:=0;

                  StkDetl:=BOn;

                  GenStr:='Total : '+GenStr;

                  DefLine(-1,TabStart(2),TabEnd(06),0);

                end;


                JobBStdLine(LineTot,GenStr,BOff,ValMode);

                If (QtyMode) then
                Begin
                  JobBStdLine(LineTot,'(Qty/Hrs)',BOn,ValMode);

                end;

              end;

      1
             :  Begin


                  GenStr:='';

                  If (PayRMode) then
                    GenStr:=LGet_StdPRDesc(StockCode,JCtrlF,JCK,-1)
                  else
                  Begin
                    {$IFDEF STK}


                      If (LGetMainRecPos(StockF,StockCode)) then
                        GenStr:=LStock.Desc[1];
                    {$ENDIF}
                  end;

                  JobBStdLine(LineTot,GenStr,BOff,ValMode);

                  If (QtyMode) then
                  Begin
                    JobBStdLine(LineTot,'(Qty/Hrs)',BOn,ValMode);
                  end;


                end;

      end; {Case..}

    end; {With(s)..}
  end;



Procedure TJBudgReport.JobBR_Detail;



Const
  Fnum       =  JCtrlF;
  Keypath    =  JCSecK;


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

  NewLine:=(RepFiler1.LinesLeft<10);



  With MTExLocal^,CRepParam^ do
  Begin

    LastJobCtrl^:=LJobCtrl^;

   


    Case ValMode of

      0  :  Begin
              KeyChk:=PartCCKey(JBRCode,JBSubAry[1])+FullJBDDKey(CRepParam^.JobFilt,GlobAnalCode);
              TmpKPath:=JCK;

            end;

      1  :  Begin
              KeyChk:=PartCCKey(JBRCode,JBSubAry[2])+FullJDAnalKey(CRepParam^.JobFilt,LJobMisc^.JobAnalRec.JAnalCode);
              TmpKPath:=JCSecK;

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

    RepSetTabs;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LJobCtrl^:=LastJobCtrl^;

  end; {With..}
end; {Proc..}



Procedure TJBudgReport.RepPrintPageHeader;


Begin

end; {Proc..}





Procedure TJBudgReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

   Case ReportMode of

      1
          :  JobBudgPage;


    end; {case..}

end;






{ ======================= Customer Line ======================= }


Procedure TJBudgReport.PrintReportLine;


Begin

  With MTExLocal^, RepFiler1, CRepParam^, LJobCtrl^.JobBudg do
  Begin
    Case ReportMode of
      1  :  Begin
              ValMode:=10;

              RepPrintPageHeader2;

              ValMode:=0;

              JobBR_Detail;

              DefLine(-1,TabStart(2),TabEnd(06),0);

              JobBStdLine(StkTot,'Total : '+Major_Hed(GlobAnalCode),BOff,ValMode);

              If (QtyMode) then
              Begin

                JobBStdLine(StkTot,'Total Qty/Hrs: ',BOn,ValMode);

              end;

            end;


    end; {Case..}

  end;
end;


{ ======================= Customer End ======================= }


Procedure TJBudgReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin


  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJBudgReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;


Begin

  TmpInclude:=BOff;


  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin

    If (JobFilt<>LJobRec^.JobCode) then
    Begin
      LGetMainRecPos(JobF,JobFilt);
    end;


    Case ReportMode of

          1
             :  With LJobCtrl^.JobBudg do
                Begin
                  TmpInclude:=(AnalHed<=SysOH2);

                  If (TmpInclude) then
                  Begin

                    Job_BudgTot(LJobRec^.JobType,JobCode,HistFolio,RCr,RTxCr,RYr,RPr,RYr2,RPr2,StkTot);

                    TmpInclude:=((StkTot[2]<>0) or (ShowER));

                    GlobAnalCode:=AnalHed;

                    {$IFDEF EX601}
                      {$IFDEF MC_On}
                        TmpInclude:=TmpInclude and ((RCr=0) or (JBudgetCurr=RCr));

                      {$ENDIF}

                    {$ENDIF}

                  end;


                end;


        end; {Case..}
    end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJBudgReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    ThTitle:='Job Budget Rep';

    RepTitle:='Job Budget Analysis';

    PageTitle:=RepTitle;

    RFont.Size:=7;

    RFnum:=JCtrlF;

    RKeyPath:=JCK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;


    PageTitle:=RepTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')';


    RepKey:=PartCCKey(JBRCode,JBSubAry[5])+JobFilt;


  end; {With..}

  Result:=BOn;
end;





Procedure TJBudgReport.Process;

Begin
  With MTExLocal^, CRepParam^ do
    If (JobFilt<>LJobRec^.JobCode) then
    Begin
      LGetMainRecPos(JobF,JobFilt);
    end;


  Inherited Process;

end;


Procedure TJBudgReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJBudgRep2Thread(LMode    :  Byte;
                             IRepParam:  JobCRep1Ptr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TJBudgReport;

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