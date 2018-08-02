unit RepJCH1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TJHistReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       UseFloatFmt :  Str255;


                       Procedure PrintSOCBal(SType  :  Char;
                                             JCode  :  Str10;
                                             Rcr,RXlate,
                                             NYr,NPr:  Byte;
                                             CloseBal,
                                             ShowQty :  Boolean);


                       Procedure Get_JDPos(Var   LineTot    : Totals;
                                           Const JDetl      : JobDetlRec;
                                           Const RCr,RXlate : Byte;
                                           Const QMode      : Boolean);

                       Procedure PrintDueTot(Gtot      :  Boolean);

                       Procedure CalcDueTotals(LTot      :  Totals);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown2(DDMode  :  Byte;
                                                     ACCode  :  Str10);

                     public

                       CRepParam  :  JobCRep2Ptr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddJHistRep2Thread(LMode    :  Byte;
                             IRepParam:  JobCRep2Ptr;
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
  Saltxl1U,
  SysU1,
  SysU2,
  BTSupU1,
  InvListU,
  RpDefine,
  JobSup1U,

  {$IFDEF REPPFC}
    SQLUtils,
    SQLFields,
  {$ENDIF}

  ExThrd2U;


{ ========== TJHistReport methods =========== }

Constructor TJHistReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

end;


Destructor TJHistReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;







Procedure TJHistReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        2 :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 37, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
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





Procedure TJHistReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  SendLine(ConCat(#9'Job ',' ','Code',#9,'Description',#9,
                    'Revenue',#9,'O/Heads',#9,'Materials',#9,'Labour',#9,'Deductions'));



      2   :  SendLine(ConCat(#9,'Our',' ','Ref',#9,'Date',#9,'Per/Yr',
                             #9,'A/C',' ','No.',#9,'Details',#9,'Revenue',#9,'O/Heads',#9,'Materials',#9,'Labour',#9,'Deductions',#9,'Uplift'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TJHistReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1,CRepParam^ do
  Case ReportMode of
      2  :  If (CurrentPage>1) then
              PrintJobLine(LJobDetl^.JobActual.JobCode,BOn);

  end; {Case..}

end;




{ ======================= Get Opening & Closing Balances & Print them =================== }

Procedure TJHistReport.PrintSOCBal(SType  :  Char;
                                   JCode  :  Str10;
                                   Rcr,RXlate,
                                   NYr,NPr:  Byte;
                                   CloseBal,
                                   ShowQty :  Boolean);


Const
  OBalStr  :  Array[BOff..BOn] of Str50 = ('Opening','Closing');

  Fnum     =  JCtrlF;
  Keypath  =  JCK;


Var
  n        :  Byte;

  Purch,Sales,Cleared,
  Bud1,Bud2,
  PostBal,
  Result,

  Dnum,
  Dnum2    :  Double;

  TmpStatus
           :  Integer;

  LineTot  :  Totals;


  KeyS2,
  KeyChk   :  Str255;


Begin
  With MTExLocal^, RepFiler1 do
  Begin
    Blank(LineTot,Sizeof(LineTot));

    If (Not CloseBal) then
      AdjPr(Nyr,NPr,CloseBal);


    TmpStatus:=LStatus;


    KeyChk:=PartCCKey(JBRCode,JBSubAry[1])+JCode;

    KeyS2:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS2);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LJobCtrl^.JobBudg do
    Begin

      PostBal:=LTotal_Profit_To_Date(SType,FullJDHistKey(JCode,HistFolio),RCr,NYr,NPr,Purch,Sales,Cleared,
                                    Bud1,Bud2,Dnum,Dnum2,BOn);

      If (Not ShowQty) then
      Begin
        Result:=PostBal;

        {$IFDEF MC_On}

          Result:=Currency_Txlate(Result,RCr,RXLate);

        {$ENDIF}
      end
      else
        Result:=Cleared;


      If (BType>0) and (Not (AnalHed In [SysAnlsRcpt,SysAnlsPRet,SysAnlsSRet,SysDeductSales,SysDeductPurch])) then
      Begin

        LineTot[BType]:=LineTot[BType]+Result;

      end
      else
        If (BType>0) and ((AnalHed In [SysDeductSales,SysDeductPurch])) then
          LineTot[5]:=LineTot[5]+Result;


      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS2);

    end; {While..}



    SendText(ConCat(#9,OBalStr[CloseBal],#9,'Balance'));

    For n:=1 to 5 do
      SendText(ConCat(ConstStr(#9,5+n),FormatFloat(UseFloatFmt,LineTot[n])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    If (CloseBal) then
    Begin
      DefLine(-1,TabStart(1),TabEnd(10),0);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;


    LStatus:=TmpStatus;

  end; {With..}
end;


{ ======================= Due Sub / Grand Total ================ }

Procedure TJHistReport.PrintDueTot(Gtot      :  Boolean);

Var
  n          :  Byte;
  Rnum       :  Real;
  PostTotMsg :  Str80;

Begin

  PostTotMsg:='';

  With MTExLocal^, RepFiler1, CRepParam^ do
  Case ReportMode of

   1
       :  Begin
            If (Not Gtot) then
            Begin

              LGetMainRec(JobF,LastJob);

              SetReportDrillDown2(0,'');

              SendText(ConCat(#9,LJobRec^.JobCode,
                       #9,LJobRec^.JobDesc));

            end
            else
            Begin

              SendText(ConCat(#9,#9,'Totals:'));

              StkTot:=RepTotal;

            end;


            SendLine(ConCat(ConstStr(#9,3),FormatFloat(UseFloatFmt,StKTot[1]),
                            #9,FormatFloat(UseFloatFmt,StKTot[2]),
                            #9,FormatFloat(UseFloatFmt,StKTot[3]),
                            #9,FormatFloat(UseFloatFmt,StKTot[4]),
                            #9,FormatFloat(UseFloatFmt,StKTot[5])));

            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}

   2
       :  Begin
            If (Not Gtot) then
            Begin
              DefLine(-1,TabStart(6),TabEnd(11),0);

              LGetMainRec(JobF,LastJob);

            end
            else
              StkTot:=RepTotal;



            SendLine(ConCat(ConstStr(#9,5),'Totals:',
                            #9,FormatFloat(UseFloatFmt,StKTot[1]),
                            #9,FormatFloat(UseFloatFmt,StKTot[2]),
                            #9,FormatFloat(UseFloatFmt,StKTot[3]),
                            #9,FormatFloat(UseFloatFmt,StKTot[4]),
                            #9,FormatFloat(UseFloatFmt,StKTot[5]),
                            #9,FormatBFloat(UseFloatFmt,StKTot[6],BOn)));


            If (Not Gtot) then
            Begin
              DefLine(-2,TabStart(6),TabEnd(11),0);

              If (ShowOCbal) then
                 With LJobRec^ do
                   PrintSOCBal(JobType,JobCode,RCr,RTxCr,RYr2,RPr2,BOn,QtyMode);


            end;


            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}


  end; {Case..With..}

end;


{ ======================= Calculate Due Totals ==================== }

Procedure TJHistReport.CalcDueTotals(LTot      :  Totals);

Var
  NBo        :  Boolean;

Begin

  With CRepParam^ do
  Case ReportMode of
    1,2    :  Begin

                GrandTotal(StkTot,LTot);

                GrandTotal(RepTotal,LTot);

              end;

      end; {Case..With..}
end;





{ ======= Calculate & Return Value of Col ======== }

Procedure TJHistReport.Get_JDPos(Var   LineTot    : Totals;
                                 Const JDetl      : JobDetlRec;
                                 Const RCr,RXlate : Byte;
                                 Const QMode      : Boolean);


Var
  Dnum,
  Dnum2 :  Double;

  AHed  :  Integer;

  UOR   :  Byte;

  LOk   :  Boolean;


Begin

  AHed:=0; UOR:=0;  Dnum:=0.0;  Dnum2:=0.0;

  With MTExLocal^, JDetl.JobActual do
  Begin

    If (AnalCode<>LJobMisc^.JobAnalRec.JAnalCode) then
      LOk:=LRepGetJobMisc(AnalCode,2)
    else
      LOk:=BOn;

    If (LOk) then
      With LJobMisc^.JobAnalRec do
      Begin
        If (JAType=1) and ((AnalHed=SysDeductSales) or (AnalHed=SysDeductPurch)) then {* Force into deductions *}
          AHed:=5
        else
          AHed:=JAType;

      end;

    If (QMode) then
    Begin
      If (Not (JDDT In NOMSplit)) then
        Dnum:=Qty
      else
        Dnum:=0.0;
    end
    else
    Begin


      Dnum:=(Qty*Cost*DocCnst[JDDT]);

      Dnum2:=Qty*UpliftTotal*DocCnst[JDDT];

      If (LJobMisc^.JobAnalRec.AnalHed=SysAnlsRev) or (JDDT In SalesCreditSet+[SJC]) then {* Only reverse revenue invoices *}
        Dnum:=Dnum*DocNotCnst;


      {$IFDEF MC_On}

        If (RCr=0) then
        Begin
          UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

          Dnum:=Round_Up(Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff),2);
          Dnum2:=Round_Up(Conv_TCurr(Dnum2,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff),2);
        end;

        Dnum:=Currency_Txlate(Dnum,RCr,RXLate);
        Dnum2:=Currency_Txlate(Dnum2,RCr,RXLate);

      {$ENDIF}

    end;

    If (AHed<>0) then
      LineTot[AHed]:=Dnum;

    LineTot[6]:=Dnum2;

  end; {With..}

end; {Proc..}





Procedure TJHistReport.SetReportDrillDown2(DDMode  :  Byte;
                                           ACCode  :  Str10);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      1  :  SendRepDrillDown(1,TotTabs,1,FullJobCode(LJobRec^.JobCode),JobF,JobCodeK,0);

      2  :  Begin
              SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

              Case DDMode of
                0  :  SendRepDrillDown(4,4,2,FullCustCode(ACCode),CustF,CustCodeK,0);
                1  :  SendRepDrillDown(4,4,2,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(ACCode),JMiscF,JMK,0);
              end;
            end;
    end; {Case..}
  end; {With..}
end;



{ ======================= Customer Line ======================= }


Procedure TJHistReport.PrintReportLine;

Var
  LineTot    :  Totals;

  GenStr2,
  GenStr     :  Str255;

  TBo        :  Boolean;


Begin

  Blank(LineTot,Sizeof(LineTot));

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Case ReportMode of
      1,2    :  With LJobDetl^.JobActual do
                 If (JobCode<>LastJob) then
                 Begin
                   If (LastJob<>'') then
                     PrintDueTot(BOff);

                   LastJob:=JobCode;

                   If (ReportMode=2) then
                   Begin
                     PrintJobLine(JobCode,BOff);

                     If (ShowOCbal) then
                       With LJobRec^ do
                         PrintSOCBal(JobType,JobCode,RCr,RTxCr,RYr,RPr,BOff,QtyMode);
                   end;

                 end;


    end; {Case..}

    Get_JDPos(LineTot,LJobDetl^,RCr,RTxCr,QtyMode);


    Case ReportMode of

      2
          : With LJobDetl^.JobActual do
            Begin
              {* Note Use of PPr_Pr/Yr *}

              If (JDDT=TSH) then
              Begin
                GenStr:=LGet_StdPRDesc(StockCode,JCtrlF,JCK,-1);
                GenStr2:=EmplCode;
              end
              else
              Begin
                If (LId.IDDocHed=ADJ) then
                Begin
                  If (LId.StockCode<>LStock.StockCode) then
                    LGetMainRecPos(StockF,LId.StockCode);

                  GenStr:=LStock.Desc[1];
                end
                else
                  GenStr:=LId.Desc;
                  
                GenStr2:=ActCCode;
              end;

              SetReportDrillDown2(0+Ord(JDDT=TSH),GenStr2);

              SendLine(ConCat(#9,LineORef,
                       #9,POutDateB(JDate),
                       #9,PPR_OutPr(LId.PPr,LId.PYr),
                       #9,GenStr2,
                       #9,GenStr,
                       #9,FormatFloat(UseFloatFmt,LineTot[1]),
                       #9,FormatFloat(UseFloatFmt,LineTot[2]),
                       #9,FormatFloat(UseFloatFmt,LineTot[3]),
                       #9,FormatFloat(UseFloatFmt,LineTot[4]),
                       #9,FormatFloat(UseFloatFmt,LineTot[5]),
                       #9,FormatBFloat(UseFloatFmt,LineTot[6],BOn)));

            end;

    end; {Case..}


    CalcDueTotals(LineTot);
  end; {With..}
end;


{ ======================= Customer End ======================= }


Procedure TJHistReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin
    PrintDueTot(BOff);

    If (RepPrintExcelTotals) then
    Begin
      DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

      PrintDueTot(BOn);
    end;

  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJHistReport.IncludeRecord  :  Boolean;


Const
  Fnum    =  IdetailF;
  KeyPath =  IdLinkK;

Var
  TmpInclude,
  InGroup,
  DayRepInc  :  Boolean;

  KeyS2      :  Str255;

Begin
  InGroup:=BOn;
  TmpInclude := False;

  {$B-}

  With MTExLocal^,CRepParam^,LJobDetl^.JobActual do
  Begin

    If (ReportMode In [1,2]) then
    Begin
      LResetRec(Fnum);

      KeyS2:=FullIdKey(LineFolio,LineNo);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS2);

      If (LJobRec^.JobCode<>JobCode) then
        LGetMainRec(JobF,JobCode);

    end;


    Case ReportMode of

      1,2
           :
              Begin

                TmpInclude:=(Posted
                             and ((((Pr2Fig(ActYr,ActPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(ActYr,ActPr)<=Pr2Fig(RYr2,RPr2))) and (Not ByDate)) or
                                  ((JDate>=SDate) and (JDate<=EDate) and (ByDate)))
                             and ((RCr=ActCurr) or (RCr=0))
                             and ((ActCCode=CustFilt) or (CustFilt=''))
                             and (((JobCode=JobFilt) or (JobFilt='')) or (Not SingProd))
                             and ((LJobRec^.JobAnal=JobTFilt) or (EmptyKey(JobTFilt,3)))
                             and ((Not (JDDT In PSOPSet+QuotesSet+RecieptSet+JAPSplit)))
                                and (PostedRun<>OrdPPRunNo)

                             and (Not (JAType In [SysAnlsPRet,SysAnlsSRet,SysAnlsWIP]))

                             and (Not Invoiced or Not UnInv));


                If (TmpInclude) then
                Begin

                  If (Not SingProd) then
                    InGroup:=LJob_InGroup(JobFilt,LJobRec^);

                  TmpInclude:=InGroup;

                end;



                If (TmpInclude) then
                With LId do
                Begin


                  {$IFDEF PF_On}

                    For DayRepInc:=BOff to BOn do
                      TmpInclude:=(TmpInclude
                                   and (CheckKey(RCCDep[DayRepInc],CCDep[DayRepInc],Length(RCCDep[DayRepInc]),BOff)));

                  {$ENDIF}

                end;

                If (Not TmpInclude) and (CheckKey(RepKey,KeyS,Length(RepKey),BOn)) then
                Begin

                  If (Not Posted) then
                  Begin {* Jump to posted section *}

                    KeyS:=PartCCKey(JBRCode,JBECode)+FullJobCode(JobCode)+#1;

                    B_Next:=B_GetGEq;

                  end
                  else
                    If (Not InGroup) and (Not SingProd) then
                    Begin {* Jump to next job *}

                      KeyS:=PartCCKey(JBRCode,JBECode)+FullJobCode(JobCode)+ConstStr(NdxWeight,20);

                      B_Next:=B_GetGEq;

                    end
                    else
                      B_Next:=B_GetNext;

                end
                else
                  B_Next:=B_GetNext;

              end;

    end; {Case..}

  end; {With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJHistReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;

  {$IFDEF REPPFC}
  StartPrYr : LongInt;
  EndPrYr : LongInt;
  sColName : ShortString;
  sCompany : ShortString;
  {$ENDIF}

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const Variant : ShortString = 'JE') : ShortString;
  Begin // ColName
    Result := GetDBColumnName('JobDet.Dat', ColumnName, Variant)
  End; // GetDBColumnName
  {$ENDIF}

Begin
  With CRepParam^ do
  Begin
    ThTitle:='Job Hist Rep';

    RepTitle:='Job History Report';

    PageTitle:=RepTitle;

    RFont.Size:=7;

    RFnum:=JDetlF;

    RKeyPath:=JDLedgerK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;

    ReportMode:=ReportMode-Ord(Summary);

    If (Not Summary) then
      ROrient:=RPDefine.PoLandscape;


    If (ByDate) then
      PageTitle:=RepTitle+' ('+POutDate(SDate)+' - '+POutDate(EDate)+')'
    else
      PageTitle:=RepTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')';


    {$IFDEF MC_On}

      If (RTxCr<>0) and (RTxCr<>RCr) then
         PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
      else
        PageTitle:=CurrDesc(RCr)+PageTitle;

    {$ENDIF}



     If (CustFilt<>'') then
     Begin
       GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'For '+Strip('B',[#32],Cust.Company);
     end;

     If (Not EmptyKey(JobFilt,JobKeyLen)) then
     Begin
       GetJob(Application.MainForm,JobFilt,FoundCode,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Job Filter : '+dbFormatName(JobFilt,JobRec^.JobDesc);

       SingProd:=(JobRec^.JobType<>JobGrpCode);
     end;


     If (QtyMode) then
     Begin
       PageTitle:=PageTitle+'. (Qty/Hrs)';
       UseFloatFmt:=GenQtyMask;
     end
     else
       UseFloatFmt:=GenRealMask;

      // MH 20/04/2010 v6.4 ABSEXCH-2761: Hide Opening/Closing Balances if filtering by CC/Dept
     ShowOCbal:= (EmptyKey(CustFilt,CustKeyLen)) and (Not UnInv) and (Not Summary) and (Not ByDate) And
                 (Trim(RCCDep[BOff]) = '') And (Trim(RCCDep[BOn]) ='');
     //ShowOCbal:=(EmptyKey(CustFilt,CustKeyLen)) and (Not UnInv) and (Not Summary) and (Not ByDate);

     {$IFDEF PF_On}
       For BoLoop:=BOff to BOn do
         If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
         Begin
           FoundCode:=RCCDep[BoLoop];

           GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

           If (RepTitle2<>'') then
             RepTitle2:=RepTitle2+', ';

           RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

         end; {Loop..}


     {$ENDIF}

      If (Not EmptyKeyS(JobTFilt,CCKeyLen,BOff)) then
      Begin
        If (RepTitle2<>'') then
          RepTitle2:=RepTitle2+', ';

        GetJobMisc(Application.MainForm,JobTFilt,FoundCode,1,-1);


        RepTitle2:=RepTitle2+'Job Type Filter : '+JobMisc^.JobTypeRec.JTypeName;
      end;

      If (UnInv) then
      Begin
        If (RepTitle2<>'') then
          RepTitle2:=RepTitle2+', ';

        RepTitle2:=RepTitle2+'(Uninvoiced items)';
      end;

     If (Not SingProd) or (EmptyKey(JobFilt,JobKeyLen)) then
     Begin
       RepKey:=PartCCKey(JBRCode,JBECode);
     end
     else
     Begin

       RepKey:=PartCCKey(JBRCode,JBECode)+JobFilt+#1;

     end;

     RepLen:=Length(RepKey);

     {$IFDEF REPPFC}
       If (ReportMode = 2) Then
       Begin
         UseSQLPrefillCache := UsingSQLAlternateFuncs;
         If UseSQLPrefillCache Then
         Begin
           SQLWhereClause := '(' + ColName('rec_pfix', '') + ' = ' + QuotedStr(JBRCode) + ') And (' + ColName('sub_type', '') + ' = ' + QuotedStr(JBECode) + ')';

           // Only want Posted lines
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('posted') + ' = 1)';

           // Filter by Document Type
           sColName := ColName('jddt');
           SQLWhereClause := SQLWhereClause + ' And (' +
                                                     // PSOPSet
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(SOR)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(POR)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(SDN)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(PDN)) + ') And ' +
                                                     // QuotesSet
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(SQU)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(PQU)) + ') And ' +
                                                     // RecieptSet
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(SRC)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(PPY)) + ') And ' +
                                                     // JAPSplit
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(JCT)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(JST)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(JPT)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(JSA)) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(Ord(JPA)) + ')' +
                                                   ')';

           // Don't want Posted Purchase Orders
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('posted_run') + ' <> ' + IntToStr(OrdPPRunNo) + ')';

           // Filter by the JAType - Analysis Line Type
           sColName := ColName('ja_type');
           SQLWhereClause := SQLWhereClause + ' And (' +
                                                     '(' + sColName + ' <> ' + IntToStr(SysAnlsPRet) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(SysAnlsSRet) + ') And ' +
                                                     '(' + sColName + ' <> ' + IntToStr(SysAnlsWIP) + ')' +
                                                   ')';

           If (Not ByDate) Then
           Begin
             // Filter by Period Range - Checking it this way will minimise the SubString/Cast operations in the query
             StartPrYr := Rpr + (RYr * 256);
             EndPrYr := Rpr2 + (RYr2 * 256);
             sColName := ColName('var_code10', '');
             SQLWhereClause := SQLWhereClause + ' And ' +
                                                 '(' + IntToStr(StartPrYr) + ' <= CAST(SUBSTRING(' + sColName + ', 2, 2) AS Integer)) ' +
                                                 'And ' +
                                                 '(CAST(SUBSTRING(' + sColName + ', 2, 2) AS Integer) <= ' + IntToStr(EndPrYr) + ')';
           End // If (Not ByDate)
           Else
           Begin
             // Filter by Date Range
             sColName := ColName('j_date');
             SQLWhereClause := SQLWhereClause + ' And ' +
                                                 '(' + SDate + ' <= ' + sColName + ') ' +
                                                 'And ' +
                                                 '(' + sColName + ' <= ' + EDate + ')';
           End; // Else

           If (RCr <> 0) Then
           Begin
             // Filter by Currency
             SQLWhereClause := SQLWhereClause + ' And (CAST(SUBSTRING(' + ColName('var_code10', '') + ', 1, 1) AS Integer) = ' + IntToStr(RCr) + ')';
           End; // If (RCr <> 0)

           If (Trim(CustFilt) <> '') Then
           Begin
             // Filter by Account Code
             SQLWhereClause := SQLWhereClause + ' And (' + ColName('act_c_code') + ' = ' + QuotedStr(CustFilt) + ')';
           End; // If (Trim(CustFilt) <> '')

           If (Trim(JobFilt) <> '') And SingProd Then
           Begin
             // Filter by Job Code
             SQLWhereClause := SQLWhereClause + ' And (' + ColName('job_code') + ' = ' + QuotedStr(JobFilt) + ')';
           End; // If (Trim(JobFilt) <> '') And SingProd

           If (Trim(JobTFilt) <> '') Then
           Begin
             // Filter by Job Type
             sColName := GetDBColumnName('JobHead.Dat', 'job_code', '');
             sCompany := GetCompanyCode(SetDrive);
             SQLWhereClause := SQLWhereClause + ' And (' + ColName('job_code') + ' IN (' +
                                  'SELECT DISTINCT ' + sColName + ' Collate Latin1_General_CI_AS ' +
                                  'From [' + sCompany + '].JobHead ' +
                                  'Where [' + sCompany + '].JobHead.JobAnal = ' + QuotedStr(JobTFilt) + '))';

           End; // If (Trim(JobTFilt) <> '')

           If UnInv Then
           Begin
             // Show Uninvoiced Items only
             SQLWhereClause := SQLWhereClause + ' And (' + ColName('invoiced') + ' = 0)';
           End; // If UnInv

           SQLColumns := GetAllJobActualFields;
         End; // If UseSQLPrefillCache
       End; // If (ReportMode = 2)
     {$ENDIF}
  end; {With..}

  Result:=BOn;
end;




Procedure TJHistReport.Process;

Begin
  Inherited Process;

end;


Procedure TJHistReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJHistRep2Thread(LMode    :  Byte;
                             IRepParam:  JobCRep2Ptr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TJHistReport;

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