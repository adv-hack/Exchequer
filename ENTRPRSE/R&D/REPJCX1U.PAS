unit RepJCX1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU;


type



  TJCXposeReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       UseFloatFmt  :  Str255;

                       LastJobCode,
                       LastAccCode  :  Str10;

                       
                       Procedure PrintCOCBal(JCode    :  Str10;
                                             RXLate   :  Byte;
                                         Var OBal     :  Real);


                     protected

                       Procedure Get_JDPos(Var   LineTot    : Totals;
                                           Const JDetl      : JobDetlRec;
                                           Const RCr,RXlate : Byte); Virtual;

                       Procedure PrintDueTot(Gtot      :  Byte); Virtual;

                       Procedure CalcDueTotals(LTot      :  Totals);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;


                     public
                       SCrtMode   :  Byte;

                       CRepParam  :  JobCRep3Ptr;

                       ThisScrt   :  Scratch2Ptr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Build_JobDetail(Mode     :  Byte;
                                                 JobFilt,
                                                 AnalFilt :  Str10;
                                                 RYr,RPr,
                                                 RYr2,RPr2,
                                                 RCr,
                                                 AHedFilt :  Byte;
                                                 SingProd :  Boolean;
                                             Var AbortPrint
                                                          :  Boolean);

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddJCxposeRep2Thread(LMode    :  Byte;
                               IRepParam:  JobCRep3Ptr;
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
  RpDefine,
  JobSup1U,
  SalTxl1U,

  {$IFDEF EXSQL}
    SQLUtils,
    SQLFields,
  {$ENDIF}

  ExThrd2U;


{ ========== TJHistReport methods =========== }

Constructor TJCXposeReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  LastJobCode:='';
  LastAccCode:='';

  ScrtMode:=10;

end;


Destructor TJCXposeReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;







Procedure TJCXposeReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        3 :  Begin
              SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 80, 4, 0, 0);
              SetTab (NA, pjRight, 35, 4, 0, 0);
              SetTab (NA, pjRight, 35, 4, 0, 0);
            end;

        4 :  Begin
              SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjRight, 35, 4, 0, 0);
              SetTab (NA, pjRight, 35, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;





Procedure TJCXposeReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      3
          :  SendLine(ConCat(#9'Job ',' ','Code',#9,'Description',#9,#9,'Exposure'));



      4   :  SendLine(ConCat(#9,'Our',' ','Ref',#9,'Date',#9,'Per/Yr',#9,'Description',#9,#9,'Exposure'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TJCXposeReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1,CRepParam^ do
  Begin
    If (CurrentPage>1) and (ReportMode In [3,4]) then
      PrintCustLine(LastAccCode,BOn);


    Case ReportMode of
        4  :  If (CurrentPage>1) then
                PrintJobLine(LastJobCode,BOn);

    end; {Case..}
  end; {With..}
end;



{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TJCXposeReport.Build_JobDetail(Mode     :  Byte;
                                         JobFilt,
                                         AnalFilt :  Str10;
                                         RYr,RPr,
                                         RYr2,RPr2,
                                         RCr,
                                         AHedFilt :  Byte;
                                         SingProd :  Boolean;
                                     Var AbortPrint
                                                  :  Boolean);


Const
  Fnum      =  JDetlF;
  Keypath   =  JDLedgerK;



Var
  KeyS2,
  KeyChk,
  MatchStr :  Str255;

  RecAddr  :  LongInt;

  B_Func   :  Integer;

  Dnum,
  Dnum2    :  Double;

  InGroup,
  TmpInclude,
  TmpBo,
  ChrgeOn
           :  Boolean;

  {$IFDEF REPPFC}
    lSQLPrefillCacheID : LongInt;
    lSQLWhereClause : ANSIString;
    lSQLColumns : ANSIString;
    lSQLPFCRes : LongInt;

    Function ColName(Const ColumnName : ShortString; Const Variant : ShortString = 'JE') : ShortString;
    Begin // ColName
      Result := GetDBColumnName('JobDet.Dat', ColumnName, Variant)
    End; // ColName
  {$ENDIF}

Begin

  AbortPrint:=BOn;

  If (SingProd) then
    KeyChk:=PartCCKey(JBRCode,JBECode)+JobFilt+#1
  else
    KeyChk:=PartCCKey(JBRCode,JBECode);

  InGroup:=BOn;

  KeyS2:=KeyChk;

  MatchStr:='';

  RecAddr:=0;

  ChrgeOn:=BOff;

  Dnum:=0.0; Dnum2:=0.0;

  TmpInclude:=BOff;
  TmpBo:=BOff;

  B_Func:=B_GetNext;

  With MTExLocal^ do
  Begin
    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs And (Mode In [3, 4]) Then
    Begin
      lSQLWhereClause :=                         '(' + ColName('rec_pfix', '') + '=' + QuotedStr(JBRCode) + ') ' +
                                                 'And ' +
                                                 '(' + ColName('sub_type', '') + '=' + QuotedStr(JBECode) + ')';

//      If SingProd then
//      Begin
//        lSQLWhereClause + lSQLWhereClause :=     'And ' +
//                                                 '(' + ColName('var_code1', '') + '=' + QuotedStr(JBECode) + ') ';
//
//        KeyChk:=PartCCKey(JBRCode,JBECode)+JobFilt+#1
//
//      End; // If SingProd



      // and
      // Posted
      lSQLWhereClause := lSQLWhereClause +      ' And ' +
                                                 '(' + ColName('posted') + ' = 1)';
      // and
      // (
      //   (RCr=ActCurr)
      //   or
      //   (RCr=0)
      // )
      If (RCr <> 0) Then
      Begin
        lSQLWhereClause := lSQLWhereClause +    ' And ' +
                                                 '(Cast(SubString(' + ColName('var_code10', '') + ',1,1) As Integer) = ' + IntToStr(RCr) + ')';
      End; // If (RCr <> 0)                        //PR 01/09/2008 ColName call was missing 2nd param - so returning 'not found'

      If (Mode In [3, 4]) Then
      Begin
        // and
        // (
        //   (Not (JDDT In PSOPSet+QuotesSet+RecieptSet+SalesSplit+JAPSplit))
        // )
        lSQLWhereClause := lSQLWhereClause +    ' And ' +
                                                 '(' + ColName('jddt') + ' Not In (' +

                                                                                   // PSOPSet
                                                                                   IntToStr(Ord(SOR)) + ', ' +
                                                                                   IntToStr(Ord(POR)) + ', ' +
                                                                                   IntToStr(Ord(SDN)) + ', ' +
                                                                                   IntToStr(Ord(PDN)) + ', ' +
                                                                                   // QuotesSet
                                                                                   IntToStr(Ord(SQU)) + ', ' +
                                                                                   IntToStr(Ord(PQU)) + ', ' +
                                                                                   // RecieptSet
                                                                                   IntToStr(Ord(SRC)) + ', ' +
                                                                                   IntToStr(Ord(PPY)) + ', ' +
                                                                                   // SalesSplit
                                                                                   IntToStr(Ord(SIN)) + ', ' +
                                                                                   IntToStr(Ord(SRC)) + ', ' +
                                                                                   IntToStr(Ord(SCR)) + ', ' +
                                                                                   IntToStr(Ord(SJI)) + ', ' +
                                                                                   IntToStr(Ord(SJC)) + ', ' +
                                                                                   IntToStr(Ord(SRF)) + ', ' +
                                                                                   IntToStr(Ord(SRI)) + ', ' +
                                                                                   IntToStr(Ord(SBT)) + ', ' +
                                                                                   // JAPSplit
                                                                                   IntToStr(Ord(JCT)) + ', ' +
                                                                                   IntToStr(Ord(JST)) + ', ' +
                                                                                   IntToStr(Ord(JPT)) + ', ' +
                                                                                   IntToStr(Ord(JSA)) + ', ' +
                                                                                   IntToStr(Ord(JPA)) +
                                                                                 ')' +
                                                 ')';
      End; // If (Mode In [3, 4])

      // and
      // (PostedRun<>OrdPPRunNo)
      lSQLWhereClause := lSQLWhereClause +      ' And ' +
                                                 '(' + ColName('posted_run') + ' <> ' + IntToStr(Ord(OrdPPRunNo)) + ')';

      If (Mode In [3, 4]) Then
      Begin
        // and
        // (
        //   (LJobRec^.CustCode=AnalFilt)
        //   or
        //   (AnalFilt='')
        // )
        If (AnalFilt <> '') Then
        Begin
          lSQLWhereClause := lSQLWhereClause +  ' And ' +
                                                 '(' + ColName('job_code') + ' Collate SQL_Latin1_General_CP1_CI_AS In (Select Distinct ' + GetDBColumnName('JobHead.Dat', 'job_code', '') + ' ' +
                                                                                  'From [' + GetCompanyCode(SetDrive) + '].JobHead ' +
                                                                                  'Where (' + GetDBColumnName('JobHead.Dat', 'cust_code', '') + ' = ' + QuotedStr(AnalFilt) + ')' +
                                                                                 ')' +
                                                 ')';
        End; // If (AnalFilt <> '')

        // and
        // (Not Invoiced)
        lSQLWhereClause := lSQLWhereClause +    ' And ' +
                                                 '(' + ColName('invoiced') + ' = 0)';
      End; // If (Mode In [3, 4])

      lSQLColumns := GetAllJobActualFields;
      lSQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[Fnum], lSQLWhereClause, lSQLColumns, lSQLPrefillCacheID, MTExLocal^.ExClientId);
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
      lSQLPFCRes := -1;
    {$ENDIF}

    ShowStatus(2,'Calculating Totals.');

    {$IFDEF REPPFC}
    If (lSQLPFCRes = 0) Then
      UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn))  and (ChkRepAbort) do
    With LJobDetl^.JobActual do
    Begin


      Case Mode of

        1,2  :  Begin
                  If (LJobMisc^.JobAnalRec.JAnalCode<>AnalCode) then
                    LRepGetJobMisc(AnalCode,2);

                  TmpInclude:=(Posted
                              and (((Pr2Fig(ActYr,ActPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(ActYr,ActPr)<=Pr2Fig(RYr2,RPr2))))
                              and ((RCr=ActCurr) or (RCr=0))
                              and ((AnalCode=AnalFilt) or (AnalFilt=''))
                              and ((Not (JDDT In PSOPSet+QuotesSet+JAPSplit)))
                              and (PostedRun<>OrdPPRunNo)

                              and ((LJobMisc^.JobAnalRec.JAType=AHedFilt) or (AHedFilt=0)));
                end;

        3,4
             :  Begin

                  ChrgeOn:=LGet_BudgMUP(JobCode,AnalCode,StockCode,0,Dnum,Dnum2,1);

                  If (LJobRec^.JobCode<>JobCode) then
                    LGetMainRec(JobF,JobCode);


                  TmpInclude:=(Posted
                              and ((RCr=ActCurr) or (RCr=0))
                              and ((Not (JDDT In PSOPSet+QuotesSet+RecieptSet+SalesSplit+JAPSplit)))
                              and (PostedRun<>OrdPPRunNo)

                              and ((LJobRec^.CustCode=AnalFilt) or (AnalFilt=''))
                              and ((Not Invoiced) and (ChrgeOn or (Charge<>0))));


                end;

      end; {Case..}


      If (TmpInclude) then
      Begin

        If (LJobRec^.JobCode<>JobCode) then
          LGetMainRec(JobF,JobCode);

        // MH 06/08/2008: Added check for blank JobFilt to eliminate redundant calls - as far as
        // I can see JobFilt isn't on the UI for the Customer Exposure report but can be set for
        // the Job Detailed Analysis Report
        If (Not SingProd) And (JobFilt <> '') then
          InGroup:=LJob_InGroup(JobFilt,LJobRec^)
        else
          InGroup:=BOn;

        TmpInclude:=InGroup;

      end
      else
        InGroup:=BOn;



      If (TmpInclude) then
      Begin
        {$IFDEF REPPFC}
        If (lSQLPFCRes = 0) Then
          UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
        {$ENDIF}
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        Case Mode of

          1,2  :  MatchStr:=SetN(LJobMisc^.JobAnalRec.JAType)+AnalCode+LineORef;
          3,4  :  MatchStr:=FullCustCode(LJobRec^.CustCode)+JobCode;


        end; {Case..}

        ThisScrt^.Add_Scratch(Fnum,JDLedgerK,RecAddr,MatchStr,'');

        If (AbortPrint) then
          AbortPrint:=BOff;

        B_Func:=B_GetNext;

      end
      else
      Begin

        B_Func:=B_GetGEq;

        If (Not Posted) then
          KeyS2:=PartCCKey(JBRCode,JBECode)+FullJobCode(JobCode)+#1
        else
          If (Not InGroup) and (Not SingProd) then
            KeyS2:=PartCCKey(JBRCode,JBECode)+FullJobCode(JobCode)+ConstStr(NdxWeight,20)
          else
            B_Func:=B_GetNext;
      end;

      {$IFDEF REPPFC}
      If (lSQLPFCRes = 0) Then
        UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
      {$ENDIF}
      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS2);

    end; {While..}

    {$IFDEF REPPFC}
      If (lSQLPFCRes = 0) Then
        DropCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end;

end; {Proc..}




{ ======================= Get Opening & Closing Balances & Print them =================== }


Procedure TJCXposeReport.PrintCOCBal(JCode    :  Str10;
                                     RXLate   :  Byte;
                                 Var OBal     :  Real);



Var
  Purch,Sales,Cleared,
  Bud1,Bud2,
  PostBal,
  Commit,
  Result,



  Dnum,
  Dnum2    :  Double;

  TmpStatus
           :  Integer;


Begin


  With MTExLocal^, RepFiler1, LCust do
  Begin
    TmpStatus:=LStatus;

    PostBal:=LProfit_to_Date(CustHistCde,JCode,0,GetLocalPr(0).Cyr,GetLocalPr(0).CPr,Sales,Purch,Commit,BOn);

    Result:=PostBal+Commit;

    {$IFDEF MC_On}

      Result:=Currency_Txlate(Result,0,RXLate);

    {$ENDIF}

    DefFont(1,[fsBold]);

    SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,CustCode,CustF,CustCodeK,0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft(ConCat(dbFormatName(CustCode,Company)),MarginLeft+2);



    Case ReportMode of
      3  :  Begin

              SendLine(ConCat(ConstStr(#9,4),FormatFloat(GenRealMask,Result)));

              DefLine(-1,TabStart(1),TabEnd(04),-0.5);
            end;

      4  :  Begin
              SendLine(ConCat(ConstStr(#9,6),FormatFloat(GenRealMask,Result)));
              DefLine(-1,TabStart(1),TabEnd(06),-0.5);
            end;


    end; {Case..}

    DefFont(0,[]);

    LStatus:=TmpStatus;

    OBal:=Result;

  end; {With..}
end;



Procedure TJCXposeReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      3  :  SendRepDrillDown(1,TotTabs,1,FullJobCode(LJobRec^.JobCode),JobF,JobCodeK,0);

      4  :  Begin
              SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

            end;
    end; {Case..}
  end; {With..}
end;



{ ======================= Due Sub / Grand Total ================ }

Procedure TJCXposeReport.PrintDueTot(Gtot      :  Byte);

Var
  n          :  Byte;
  Rnum       :  Real;
  PostTotMsg :  Str80;

Begin

  PostTotMsg:='';

  With MTExLocal^, RepFiler1, CRepParam^ do
  Case ReportMode of

   3
       :  Begin
            If (Gtot=1) then
            Begin

              LGetMainRec(JobF,LastJob);

              SetReportDrillDown(0);

              SendText(ConCat(#9,LJobRec^.JobCode,
                       #9,LJobRec^.JobDesc));

              StkTot[3]:=StkTot[1];
              StkTot[1]:=0;

            end
            else
            Begin
              If (Gtot=2) then
              Begin
                DefLine(-1,TabStart(2),TabEnd(04),0);

              end;

              SendText(ConCat(#9,#9,'Totals',ConstStr('.',50),' :'));

              Case Gtot of

                2  :  StkTot:=JobTot;

                3  :  StkTot:=RepTotal;

              end;

              StkTot[3]:=StkTot[1]+StkTot[2];

            end;


            SendLine(ConCat(ConstStr(#9,3),FormatBFloat(GenRealMask,StKTot[1],BOn),
                            #9,FormatFloat(GenRealMask,StKTot[3])));

            Blank(STKTot,Sizeof(StkTot));

            If (Gtot=2) then
            Begin
              Blank(JobTot,Sizeof(JobTot));
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end;


          end; {Case..}

   4
       :  Begin
            If (Gtot=1) then
            Begin
              DefLine(-1,TabStart(3),TabEnd(06),0);

              StkTot[3]:=StkTot[1];
              StkTot[1]:=0;

              SendRepDrillDown(1,TotTabs,1,FullJobCode(LastJob),JobF,JobCodeK,0);
            end
            else
            Begin
              Case Gtot of

                2  :  Begin
                        StkTot:=JobTot;

                        SendRepDrillDown(1,TotTabs,1,FullCustCode(LastCust),CustF,CustCodeK,0);
                      end;

                3  :  StkTot:=RepTotal;

              end;

              StkTot[3]:=StkTot[1]+StkTot[2];

            end;


            SendLine(ConCat(ConstStr(#9,5),FormatBFloat(GenRealMask,StKTot[1],BOn),
                            #9,FormatFloat(GenRealMask,StKTot[3])));


            If (Gtot<>3) then
            Begin
              DefLine(-2,TabStart(3),TabEnd(06),0);

            end;


            Blank(STKTot,Sizeof(StkTot));


            If (Gtot=2) then
              Blank(JobTot,Sizeof(JobTot));

          end; {Case..}


  end; {Case..With..}

end;


{ ======================= Calculate Due Totals ==================== }

Procedure TJCXposeReport.CalcDueTotals(LTot      :  Totals);

Var
  NBo        :  Boolean;

Begin

  With CRepParam^ do
  Case ReportMode of
    3,4    :  Begin

                GrandTotal(StkTot,LTot);

                GrandTotal(JobTot,LTot);

                GrandTotal(RepTotal,LTot);

              end;

      end; {Case..With..}
end;





{ ======= Calculate & Return Value of Col ======== }

Procedure TJCXposeReport.Get_JDPos(Var   LineTot    : Totals;
                                   Const JDetl      : JobDetlRec;
                                   Const RCr,RXlate : Byte);


Var
  UOR   :  Byte;

  Dnum2,

  Dnum  :  Double;



Begin

  With MTExLocal^, JDetl.JobActual do
  Begin

    Dnum:=(Qty*Cost*DocCnst[JDDT]);

    If (JDDT In SalesSplit-RecieptSet) then
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

  end; {With..}

end; {Proc..}



{ ======================= Customer Line ======================= }


Procedure TJCXposeReport.PrintReportLine;

Var
  LineTot    :  Totals;

  Dnum       :  Double;
  Rnum       :  Real;

  GenStr     :  Str255;

  TBo        :  Boolean;


Begin

  Blank(LineTot,Sizeof(LineTot));

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Case ReportMode of
      3,4    :  With LJobDetl^.JobActual do
                 If (JobCode<>LastJob) or (LJobRec^.CustCode<>LastCust) then
                 Begin
                   If (LastJob<>'') then
                     PrintDueTot(1);

                   LastJob:=JobCode;

                   If (ReportMode=3) and  (LJobRec^.JobCode<>LastJob) then
                   Begin
                     LGetMainRecPos(JobF,LastJob);
                   end;

                   If (LJobRec^.CustCode<>LastCust) then
                   Begin
                     If (LastCust<>'') then
                       PrintDueTot(2);

                     LastCust:=LJobRec^.CustCode;

                     PrintCOCBal(LastCust,RTxCr,LineTot[2]);

                     LastAccCode:=LastCust;
                   end;

                   If (ReportMode=4) then
                   Begin
                     PrintJobLine(JobCode,BOff);

                     LastJobCode:=JobCode;
                   end;

                 end;


    end; {Case..}

    Get_JDPos(LineTot,LJobDetl^,RCr,RTxCr);

    Case ReportMode of

      4
          : With LJobDetl^.JobActual do
            Begin
              {* Note Use of PPr_Pr/Yr *}

              If (JDDT=TSH) then
              Begin
                GenStr:=LGet_StdPRDesc(StockCode,JCtrlF,JCK,-1);
              end
              else
              Begin
                GenStr:=LId.Desc;
              end;

              Rnum:=Cost;


              {$IFDEF MC_On}

                Rnum:=Currency_Txlate(Rnum,RCr,RTxCr);

              {$ENDIF}

              SetReportDrillDown(0);


              SendLine(ConCat(#9,LineORef,
                       #9,POutDateB(JDate),
                       #9,PPR_OutPr(LId.PPr,LId.PYr),
                       #9,GenStr,#9,
                       #9,FormatFloat(GenRealMask,LineTot[1])));

            end;

    end; {Case..}


    CalcDueTotals(LineTot);
  end; {With..}
end;


{ ======================= Customer End ======================= }


Procedure TJCXposeReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  If (ReportMode In [3,4]) then
  Begin
    For n:=1 to 3 do
    Begin
      If (RepPrintExcelTotals) or (n=1) then
      Begin
        PrintDueTot(n);

        If (n=2) then
          DefLine(-2,MarginLeft,PageWidth-MarginRight-1,0);
      end;
    end;

  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJCXposeReport.IncludeRecord  :  Boolean;


Const
  Fnum    =  IdetailF;
  KeyPath =  IdLinkK;

Var
  TmpInclude :  Boolean;

  KeyS2      :  Str255;

Begin
  TmpInclude := False;

  {$B-}

  With MTExLocal^,CRepParam^,LJobDetl^.JobActual do
  Begin

    If (ReportMode In [3,4]) then
    Begin
      If (ThisScrt<>NIL) then {* Get Id Link *}
        ThisScrt^.Get_Scratch(LRepScr^);


      LResetRec(Fnum);

      KeyS2:=FullIdKey(LineFolio,LineNo);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS2);

      If (LJobRec^.JobCode<>JobCode) then
        LGetMainRec(JobF,JobCode);

      If (LJobRec^.CustCode<>LCust.CustCode) then
        LGetMainRec(CustF,LJobRec^.CustCode);

    end;


    Case ReportMode of

      3,4
           :
              Begin

                TmpInclude:=BOn;

                LastJobCode:=JobCode;

                LastAccCode:=LJobRec^.CustCode;

                
              end;

    end; {Case..}

  end; {With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJCXposeReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    ThTitle:='Cust Expose Rep';

    RepTitle:='Job Costing. Customer Exposure Report';

    PageTitle:=RepTitle;

    RFont.Size:=8;

    RFnum:=ReportF;

    RKeyPath:=RpK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;

    ReportMode:=ReportMode-Ord(Summary);


    PageTitle:=RepTitle;


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



     If (Not SingProd) or (EmptyKey(JobFilt,JobKeyLen)) then
     Begin
       RepKey:=PartCCKey(JBRCode,JBECode);
     end
     else
     Begin

       RepKey:=PartCCKey(JBRCode,JBECode)+JobFilt+#1;

     end;

     RepLen:=Length(RepKey);

  end; {With..}

  Result:=BOn;
end;




Procedure TJCXposeReport.Process;

Var
  AbortPrint   :  Boolean;

Begin
  AbortPrint:=BOff;

{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}

  New(ThisScrt,Init(ScrtMode,MTExLocal,BOff));

  Try
    RepKey:=FullNomKey(ThisScrt^.Process);

    InitStatusMemo(4);

    ShowStatus(0,RepTitle);


    With CRepParam^ do
      Build_JobDetail(ReportMode,JobFilt,CustFilt,RYr,RPr,RYr2,RPr2,RCr,AHedFilt,SingProd,AbortPrint);


    Inherited Process;

  Finally
    Dispose(ThisScrt,Done);
    ThisScrt:=nil;
  end;

end;


Procedure TJCXposeReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJCXposeRep2Thread(LMode    :  Byte;
                               IRepParam:  JobCRep3Ptr;
                               AOwner   :  TObject);


Var
  EntTest  :  ^TJCXposeReport;

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