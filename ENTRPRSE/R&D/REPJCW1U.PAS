unit RepJCW1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TJWIPReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private



                       Procedure Get_JDPos(Var   LineTot    : Totals;
                                           Const JDetl      : JobDetlRec;
                                           Const RCr,RXlate : Byte);

                       Procedure PrintDueTot(Gtot      :  Boolean);

                       Procedure CalcDueTotals(LTot      :  Totals);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown2(DDMode  :  Byte;
                                                     ACCode  :  Str10);

                     public

                       CRepParam  :  JobCRep3Ptr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddJWIPRep2Thread(LMode    :  Byte;
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

  {$IFDEF REPPFC}
    SQLUtils,
    SQLFields,
    SavePos,
  {$ENDIF}

  ExThrd2U;


{ ========== TJWIPReport methods =========== }

Constructor TJWIPReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

end;


Destructor TJWIPReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;







Procedure TJWIPReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        2 :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 57, 4, 0, 0);
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





Procedure TJWIPReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  SendLine(ConCat(#9'Job Code',#9,'Job Name',#9,
                    'Invoiced',#9,'O/Heads',#9,'Materials',#9,'Labour',#9,'Uplift',#9,'W.I.P.'));



      2   :  SendLine(ConCat(#9,'Our',' ','Ref',#9,'A/C Code',#9,'Details',#9,
                             'Invoiced',#9,'O/Heads',#9,'Materials',#9,'Labour',#9,'Uplift',#9,'W.I.P.'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TJWIPReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1,CRepParam^ do
  Case ReportMode of
      2  :  If (CurrentPage>1) then
              PrintJobLine(LJobDetl^.JobActual.JobCode,BOn);

  end; {Case..}

end;



{ ======================= Due Sub / Grand Total ================ }

Procedure TJWIPReport.PrintDueTot(Gtot      :  Boolean);

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


            SendLine(ConCat(ConstStr(#9,3),FormatFloat(GenRealMask,StKTot[1]),
                            #9,FormatFloat(GenRealMask,StKTot[2]),
                            #9,FormatFloat(GenRealMask,StKTot[3]),
                            #9,FormatFloat(GenRealMask,StKTot[4]),
                            #9,FormatFloat(GenRealMask,StKTot[6]),
                            #9,FormatFloat(GenRealMask,StKTot[5])));

            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}

   2
       :  Begin
            If (Not Gtot) then
            Begin
              DefLine(-1,TabStart(4),TabEnd(09),0);

              LGetMainRec(JobF,LastJob);

              SendRepDrillDown(1,TotTabs,1,FullJobCode(LastJob),JobF,JobCodeK,0);
            end
            else
              StkTot:=RepTotal;



            SendLine(ConCat(ConstStr(#9,3),'Totals:',
                            #9,FormatFloat(GenRealMask,StKTot[1]),
                            #9,FormatFloat(GenRealMask,StKTot[2]),
                            #9,FormatFloat(GenRealMask,StKTot[3]),
                            #9,FormatFloat(GenRealMask,StKTot[4]),
                            #9,FormatFloat(GenRealMask,StKTot[6]),
                            #9,FormatFloat(GenRealMask,StKTot[5])));


            If (Not Gtot) then
            Begin
              DefLine(-2,TabStart(4),TabEnd(09),0);

            end;


            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}


  end; {Case..With..}

end;


{ ======================= Calculate Due Totals ==================== }

Procedure TJWIPReport.CalcDueTotals(LTot      :  Totals);

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

Procedure TJWIPReport.Get_JDPos(Var   LineTot    : Totals;
                                 Const JDetl      : JobDetlRec;
                                 Const RCr,RXlate : Byte);


Var
  UOR   :  Byte;

  Dnum2,
  Dnum  :  Double;

  AHed  :  Integer;

  LOk   :  Boolean;


Begin

  AHed:=0; UOR:=0;  Dnum2:=0.0;

  With MTExLocal^, JDetl.JobActual do
  Begin

    If (AnalCode<>LJobMisc^.JobAnalRec.JAnalCode) then
      LOk:=LRepGetJobMisc(AnalCode,2)
    else
      LOk:=BOn;

    If (LOk) then
      With LJobMisc^.JobAnalRec do
        AHed:=JAType;


    Dnum:=(Qty*Cost*DocCnst[JDDT]);

    Dnum2:=Qty*UpliftTotal*DocCnst[JDDT];

    If (LJobMisc^.JobAnalRec.AnalHed=SysAnlsRev) then {* Only reverse revenue invoices *}
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

  If (AHed In [3,4]) then {* Bring across to WIP *}
    LineTot[5]:=Dnum;

  LineTot[6]:=Dnum2;

end; {Proc..}





Procedure TJWIPReport.SetReportDrillDown2(DDMode  :  Byte;
                                          ACCode  :  Str10);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      1  :  SendRepDrillDown(1,TotTabs,1,FullJobCode(LJobRec^.JobCode),JobF,JobCodeK,0);

      2  :  Begin
              SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

              Case DDMode of
                0  :  SendRepDrillDown(2,2,2,FullCustCode(ACCode),CustF,CustCodeK,0);
                1  :  SendRepDrillDown(2,2,2,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(ACCode),JMiscF,JMK,0);
              end;
            end;
    end; {Case..}
  end; {With..}
end;





{ ======================= Customer Line ======================= }


Procedure TJWIPReport.PrintReportLine;

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
                   end;

                 end;


    end; {Case..}

    Get_JDPos(LineTot,LJobDetl^,RCr,RTxCr);

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
                       #9,GenStr2,
                       #9,GenStr,
                       #9,FormatFloat(GenRealMask,LineTot[1]),
                       #9,FormatFloat(GenRealMask,LineTot[2]),
                       #9,FormatFloat(GenRealMask,LineTot[3]),
                       #9,FormatFloat(GenRealMask,LineTot[4]),
                       #9,FormatFloat(GenRealMask,LineTot[6]),
                       #9,FormatFloat(GenRealMask,LineTot[5])));

            end;

    end; {Case..}


    CalcDueTotals(LineTot);
  end; {With..}
end;


{ ======================= Customer End ======================= }


Procedure TJWIPReport.PrintEndPage;
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


Function TJWIPReport.IncludeRecord  :  Boolean;


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

      If (LJobMisc^.JobAnalRec.JAnalCode<>AnalCode) then
          LRepGetJobMisc(AnalCode,2);


    end;


    Case ReportMode of

      1,2
           :
              Begin

                TmpInclude:=(Posted
                               and ((RCr=ActCurr) or (RCr=0))
                               and (((JobCode=JobFilt) or (JobFilt='')) or (Not SingProd))
                               and ((Not (JDDT In PSOPSet+QuotesSet+RecieptSet+JAPSplit)))
                                and (PostedRun<>OrdPPRunNo)

                               and (LJobRec^.JobStat<JobCompl)
                               and (((Reverse) and (Not Reversed)) or (Not (LJobMisc^.JobAnalRec.JAType In [2..4]))))
                               and (Not (LJobMisc^.JobAnalRec.AnalHed In [9,10,SysDeductSales,SysDeductPurch]));


                If (TmpInclude) then
                Begin

                  If (Not SingProd) then
                    InGroup:=LJob_InGroup(JobFilt,LJobRec^);

                  TmpInclude:=InGroup;

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






Function TJWIPReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;

  {$IFDEF REPPFC}
  sColName : ShortString;
  sCompany : ShortString;
  {$ENDIF}

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'JobDet.Dat'; Const Variant : ShortString = 'JE') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, Variant)
  End; // GetDBColumnName

  Function JobGroupFilter(ParentGroup, ColumnName : ShortString; Const Init : Boolean = True) : ANSIString;
  Var
    iStatus  : SmallInt;
    KeyS : Str255;
    sTemp : ANSIString;
  Begin // JobGroupFilter
    Result := '';

    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (JobF, GetPosKey);
        SaveDataBlock (@JobRec, SizeOf(JobRec));

        // Check Parent exists
        KeyS := FullJobCode(ParentGroup);
        iStatus := Find_Rec(B_GetGEq, F[JobF], JobF, RecPtr[JobF]^, JobCatK, KeyS);
        While (iStatus = 0) And (JobRec.JobCat = ParentGroup) Do
        Begin
          If (JobRec.JobType = JobGrpCode) Then
            // For Groups run through their children
            sTemp := JobGroupFilter(JobRec.JobCode, ColumnName, False)
          Else
            // Otherwise add job into Query
            sTemp := '(' + ColumnName + ' = ' + QuotedStr(Trim(JobRec.JobCode)) + ')';

          If (Trim(sTemp) <> '') Then
          Begin
            If (Trim(Result) <> '') Then
              Result := Result + ' Or ';
            Result := Result + sTemp;
          End; // If (Trim(sTemp) <> '')

          iStatus := Find_Rec(B_GetNext, F[JobF], JobF, RecPtr[JobF]^, JobCatK, KeyS);
        End; // While (iStatus = 0) And (JobRec.JobCat = ParentGroup)

        // Restore position in file
        RestoreDataBlock (@JobRec);
        RestoreSavedPosition;
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create

    If Init And (Result <> '') Then
      Result := ' And (' + Result + ')';
  End; // JobGroupFilter
  {$ENDIF}

Begin
  With CRepParam^ do
  Begin
    ThTitle:='Job WIP Rep';

    RepTitle:='Work in Progress Report';

    PageTitle:=RepTitle;

    RFont.Size:=8;

    RFnum:=JDetlF;

    RKeyPath:=JDLedgerK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;

    ReportMode:=ReportMode-Ord(Summary);

    {If (Not Summary) then
      RFont.Size:=7;}


    ROrient:=RPDefine.PoLandscape;


    {$IFDEF MC_On}

      If (RTxCr<>0) and (RTxCr<>RCr) then
         PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
      else
        PageTitle:=CurrDesc(RCr)+PageTitle;

    {$ENDIF}


     If (Not EmptyKey(JobFilt,JobKeyLen)) then
     Begin
       GetJob(Application.MainForm,JobFilt,FoundCode,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Job Filter : '+dbFormatName(JobFilt,JobRec^.JobDesc);
     end;

    SingProd:=((Not EmptyKey(JobFilt,JobKeyLen)) and (JobRec^.JobType<>JobGrpCode));


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
       If (ReportMode = 1) Or (ReportMode = 2) Then
       Begin
         UseSQLPrefillCache := UsingSQLAlternateFuncs;
         If UseSQLPrefillCache Then
         Begin
           sCompany := GetCompanyCode(SetDrive);

           SQLWhereClause := '(' + ColName('rec_pfix', 'JobDet.Dat', '') + ' = ' + QuotedStr(JBRCode) + ') And (' + ColName('sub_type', 'JobDet.Dat', '') + ' = ' + QuotedStr(JBECode) + ')';

           // Only want Posted lines
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('posted') + ' = 1)';

           // Only want oustanding jobs - filter out completed jobs
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('job_code') + ' In (Select Distinct ' + ColName('job_code', 'JobHead.Dat', '') + ' Collate Latin1_General_CI_AS ' +
                                                                                    'From ' + sCompany + '.JobHead ' +
                                                                                    'Where (' + ColName('job_stat', 'JobHead.Dat', '') + ' < ' + IntToStr(JobCompl) + ')))';

           If (Trim(JobFilt) <> '') Then
           Begin
             sColName := ColName('job_code');
             If SingProd Then
               // Filter by Job Code
               SQLWhereClause := SQLWhereClause + ' And (' + sColName + ' = ' + QuotedStr(JobFilt) + ')'
             Else
               // Get list of codes within the Job group
               SQLWhereClause := SQLWhereClause + JobGroupFilter(JobFilt, sColName);
           End; // If (Trim(JobFilt) <> '')

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

           // Don't want ?
           sColName := ColName('ja_type', 'JobMisc.Dat', 'JA');
           SQLWhereClause := SQLWhereClause + ' And (' +
                                                     '((' + ColName('reverse') + ' = 1) And (' + ColName('reversed') + ' <> 1)) ' +
                                                     'Or ' +
                                                     '(' + ColName('var_code5', 'JobDet.Dat', '') + ' In (Select Cast(SubString(' + ColName('var_code1', 'JobMisc.Dat', '') + ',2,10) As VarChar) ' +
                                                                                                         'From ' + sCompany + '.JobMisc ' +
                                                                                                         'Where ((' + ColName('rec_pfix', 'JobMisc.Dat', '') + ' = ' + QuotedStr('J') + ')' +
                                                                                                            'And (' + ColName('sub_type', 'JobMisc.Dat', '') + ' = ' + QuotedStr('A') + ')' +
                                                                                                            'And (Not (' + sColName + ' In (2, 3, 4)))' +
                                                                                                               ')' +
                                                                                                        ')' +
                                                     ')' +
                                                   ')';

           // Don't want certain types of Analysis Code
           SQLWhereClause := SQLWhereClause + ' And (' +
                                                      ColName('var_code5', 'JobDet.Dat', '') + ' In (Select Cast(SubString(' + ColName('var_code1', 'JobMisc.Dat', '') + ',2,10) As VarChar) ' +
                                                                                                    'From ' + sCompany + '.JobMisc ' +
                                                                                                    'Where (' + ColName('rec_pfix', 'JobMisc.Dat', '') + ' = ' + QuotedStr('J') + ')' +
                                                                                                      'And (' + ColName('sub_type', 'JobMisc.Dat', '') + ' = ' + QuotedStr('A') + ')' +
                                                                                                      'And (Not (' + ColName('anal_hed', 'JobMisc.Dat', 'JA') + ' In (9, 10, ' + IntToStr(SysDeductSales) + ', ' + IntToStr(SysDeductPurch) + ')))' +
                                                                                                   ')' +
                                                   ')';

           If (RCr <> 0) Then
           Begin
             // Filter by Currency
             SQLWhereClause := SQLWhereClause + ' And (CAST(SUBSTRING(' + ColName('var_code10', 'JobDet.Dat', '') + ', 1, 1) AS Integer) = ' + IntToStr(RCr) + ')';
           End; // If (RCr <> 0)

           SQLColumns := GetAllJobActualFields;
         End; // If UseSQLPrefillCache
       End; // If (ReportMode = 1) Or (ReportMode = 2) 
     {$ENDIF}
  end; {With..}

  Result:=BOn;
end;




Procedure TJWIPReport.Process;

Begin
  Inherited Process;

end;


Procedure TJWIPReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJWIPRep2Thread(LMode    :  Byte;
                            IRepParam:  JobCRep3Ptr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TJWIPReport;

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