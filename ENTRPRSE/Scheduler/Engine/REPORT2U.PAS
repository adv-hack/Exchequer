unit Report2U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU;


type

  PrTotalPtr    =  ^PrTotalRec;

  PrTotalRec    =  Record
                     PrPr,
                     PrYr      :  Byte;
                     CrDr      :  DrCrDType;
                   end;


  PeriodTotalPtr=  ^PeriodTotal;

  PeriodTotal   =  Object(List)
                     PrTotals  :  PrTotalPtr;
                     CurrNode  :  NodePtr;

                     Constructor  Init;

                     Destructor   Done;

                     Procedure AddItem(Pr,
                                       Yr    :  Byte);

                     Procedure Calc4Period(Pr,
                                           Yr    :  Byte;
                                           PrCrDr  :  DrCrDType);

                   end; {Object..}



  TPostReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure Print_PSummary;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       PrTotal   :  PeriodTotalPtr;
                       ThisScrt  :  Scratch2Ptr;

                       {$IFDEF SOP}
                         Procedure Build_SalesAccrual(Mode     :  Byte;
                                                  Var FoundOk  :  Boolean);
                       {$ENDIF}

                       Function GetReportInput  :  Boolean; Virtual;

                       Function GetLineNomCode  :  LongInt;

                     public
                       PRun       :  LongInt;
                       PMode      :  Byte;

                       CRepParam  :  PostRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintDueTot(GMode     :  Byte);

                       Procedure CalcDueTotals(CrDr      :  DrCrDType);

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure Print_PostSummary;

                       Procedure PrintEndPage; Virtual;

                       procedure SetPrinter;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddPostRep2Thread(LMode    :  Byte;
                            IRun     :  LongInt;
                            IMode    :  Byte;
                            IRepParam:  PostRepPtr;
                            Ask4P    :  Boolean;
                            AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  RPDefine,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  {$IFDEF SOP}
    MiscU,
  {$ENDIF}
    
  SysU1,
  SysU2,
  BTSupU1,
  {DocSupU1,}
  SalTxl1U,
  ExThrd2U,


  RpMemo,

  ReportHU,
  PrintFrm,
  Enterprise04_TLB,
  CTKUtil04,
  ActiveX;




  { ---------------------------------------------------------------- }

  {  PeriodTotal Methods }

  { ---------------------------------------------------------------- }




  Constructor PeriodTotal.Init;

  Begin
    List.Init;

    CurrNode:=GetFirst;

  end;


  Destructor PeriodTotal.Done;


  Var
    N  :  NodePtr;

  Begin
    {N:=GetLast; * Not needed, as List.Done seems to get rid of them? 

    While (N<>Nil) do
    Begin

      Dispose(N^.LItem);

      N:=GetPrev(N);
    end;}

    List.Done;

  end;


  Procedure PeriodTotal.AddItem(Pr,Yr  :  Byte);

  Begin
    Add(New(PrTotalPtr));

    CurrNode:=GetLast;

    PrTotals:=CurrNode^.LItem;

    FillChar(PrTotals^,Sizeof(PrTotals^),0);

    With PrTotals^ do
    Begin
      PrPr:=Pr;
      PrYr:=Yr;
    end;
  end;


  Procedure PeriodTotal.Calc4Period(Pr,Yr   :  Byte;
                                    PrCrDr  :  DrCrDType);

  Var
    Match  :  Boolean;

  Begin
    CurrNode:=GetLast;

    Match:=BOff;

    While (CurrNode<>Nil) and (Not Match) do
    Begin
      PrTotals:=CurrNode^.LItem;

      With PRTotals^ do
        Match:=((PrYr=Yr) and (PrPr=Pr));

      If (Not Match) then
        CurrNode:=CurrNode^.LPrev;
    end; {While..}

    If (Not Match) then
      AddItem(Pr,Yr);

    With PrTotals^ do
      For Match:=BOff to BOn do
        CrDr[Match]:=Round_Up(CrDr[Match],2)+Round_Up(PrCrDr[Match],2);

  end; {Proc..}




{ ========== TPostReport methods =========== }

Constructor TPostReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ThisScrt:=nil;

  New(PrTotal,Init);
end;


Destructor TPostReport.Destroy;

Begin
  Dispose(PrTotal,Done);

  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);

  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TPostReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    Case ReportMode of

        2:  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 45, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjLeft,9, 4, 0, 0);
              SetTab (NA, pjLeft,9, 4, 0, 0);
              SetTab (NA, pjLeft,20, 4, 0, 0);
              SetTab (NA, pjLeft,20, 4, 0, 0);

            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;


Procedure TPostReport.RepPrintPageHeader;

Var
  CTit,DTit,JTit,ATit, BFTit,CFTit
          :  Str80;

Begin
  CTit:=''; DTit:=''; JTit:=''; ATit:='';

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of

      2  :  Begin
              {$IFDEF PF_On}

                If (Syss.UseCCDep) then
                Begin
                  CTit:='CC';
                  DTit:='Dept';
                end;

              {$ENDIF}

              If (JBCostOn) then
              Begin
                JTit:='Job Code';
                ATit:='Analysis Code';
              end;

              If (PRun<>0) and (AccrualMode=0) then
              Begin
                BFTit:='B/Fwrd';
                CFTit:='C/Fwrd';

              end
              else
              Begin
                BFTit:='';
                CFTit:='';
              end;


              SendLine(ConCat(#9,'Our Ref',#9,'Date',#9,'Acc No',#9,'Period',#9,'Description',#9,BFTit,#9,'Debit',#9,'Credit',#9,CFTit,
                              #9,CTit,#9,DTit,#9,JTit,#9,ATit));
            end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


   { ============== Print Posting Summary ============== }

   Procedure TPostReport.Print_PSummary;

   Var
     Bo      :  Boolean;
     n,m     :  Byte;
     GenStr  :  Str80;
     GenStr2 :  Str255;

   Begin
     With RepFiler1,CRepParam^ do
     Begin
       PrintHedtit;
       DefFont(3,[fsBold]);

       PrintLeft('Posting Summary - Run No. '+Form_Int(PRun,0),MarginLeft);

       DefFont (0,[]);
       PrintRight (Concat('User : ',Trim(EntryRec^.Login),'. Page : ',IntToStr(CurrentPage)), PageWidth - MarginRight);
       CRLF;

       ClearTabs;

       SetTab (MarginLeft, pjLeft, 80, 4, 0, 0);
                SetTab (NA, pjRight, 29, 4, 0, 0);
                SetTab (NA, pjRight, 29, 4, 0, 0);
                SetTab (NA, pjRight, 29, 4, 0, 0);

       GenStr:='';


       For Bo:=BOff to BOn do
       Begin
         For m:=1 to 3 do
           CRLF;

         DefFont(2,[fsBold]);

         SendLine(ConCat(#9,DocGroup[1+Ord(Bo)],#9,'B/Fwrd',#9,'Current',#9,'C/Fwrd'));

         DefFont(2,[]);

         DefLine(-1.3,1,PageWidth-MarginRight-1,-0.5);

         For n:=1 to MaxPostingAnalysisTypes do

         With PostSummary[Bo,n] do
         Begin
           GenStr:=DocNames[DocumentType];

           If (n<=5) then
             GenStr:=GenStr+'s';

           GenStr2:=ConCat(#9,GenStr);

           For m:=1 to 3 do
             GenStr2:=GenStr2+ConCat(#9,FormatBFloat(GenRealMask,Totals[m],BOn));

           SendLine(GenStr2);

         end; {Loop..}

         DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

       end; {Loop..}

       ClearTabs;
       RepSetTabs;

       ThrowNewPage(-1);
     end; {with..}
   end; {Proc..}




Procedure TPostReport.RepPrintHeader(Sender  :  TObject);


Begin
  If (NoDeviceP) and (RepFiler1.CurrentPage=1) then
    Print_PSummary
  else
  Begin

    Inherited RepPrintHeader(Sender);

    Case ReportMode of
      2  :  If (RepFiler1.CurrentPage>1+Ord(NoDeviceP)) then
                PrintNomLine(FullNomKey(MTExLocal^.LNom.NomCode),BOn);

    end; {Case..}
  end;

end;



Procedure TPostReport.PrintDueTot(GMode     :  Byte);


  Begin

    DefFont(0,[]);

    With MTExLocal^,RepFiler1 do
      With CRepParam^ do
        Case ReportMode of
          2  :  Begin
                  Case GMode of
                    0  :  DefLine(-1,109,235,0);

                    1  :  Begin
                            CustTotal:=RepTotal;
                          end;


                  end; {Case..}

                  SendLine(ConCat(ConstStr(#9,7),FormatBFloat(GenRealMask,CustTotal[BOff],BOn),
                          #9,FormatBFloat(GenRealMask,CustTotal[BOn],BOn)));


                  CustTotal[BOff]:=0.0; CustTotal[BOn]:=0.0;

                end; {Case..}

        end; {Case..}

  end;




  { ======================= Calculate Due Totals ==================== }

  Procedure TPostReport.CalcDueTotals(CrDr      :  DrCrDType);

  Var
    nBo        :  Boolean;
    Rnum       :  Double;

  Begin

    Rnum:=0;

    With MTExLocal^,CRepParam^ do
      Case ReportMode of
        2
           :  Begin
                For nBo:=BOff to BOn do
                Begin
                  CustTotal[NBo]:=Round_Up(CustTotal[NBo],2)+Round_Up(CrDr[NBo],2);
                  RepTotal[NBo]:=Round_Up(RepTotal[NBo],2)+Round_Up(CrDr[NBo],2);
                end;

                With LId do
                  PrTotal^.Calc4Period(PPr,PYr,CrDr);
              end;

      end; {Case..With..}
  end;


Function TPostReport.GetLineNomCode  :  LongInt;

Begin
  With MTExLocal^, CRepParam^ do
  Begin
    {$IFDEF SOP}
      With LId do
      If (AccrualMode=2) and (Is_FullStkCode(StockCode)) then
      Begin
        If (LStock.StockCode<>StockCode) then {* Go get Stock Record*}
          LGetMainRecPos(StockF,StockCode);

        If (LStock.StockType=StkBillCode) then {Use correct G/L code dependant on stock type}
          Result:=LStock.NomCodeS[5]
        else
          Result:=LStock.NomCodeS[4];
      end
      else
    {$ENDIF}

        Result:=LId.NomCode;
  end;
end;


Procedure TPostReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
       2  :  Begin

               SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);
               SendRepDrillDown(3,3,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);
             end;

    end; {Case..}
  end; {With..}
end;


Procedure TPostReport.PrintReportLine;



Var
  CrDr       :  DrCrDType;
  LineAged   :  AgedTyp;
  UOR        :  Byte;
  Rnum       :  Double;
  GenStr     :  Str255;
  CCStr,DepStr
             :  Str10;

Begin

  Rnum:=0; UOR:=0;

  GenStr:=''; CCStr:=Spc(3); DepStr:=Spc(3);

  With MTExLocal^,RepFiler1 do
    With CRepParam^ do
    Begin

      Case ReportMode of
        2
             :  With LId do
                Begin
                  If (FullNomKey(GetLineNomCode)<>LastCust) then
                  Begin
                    If (LastCust<>'') then
                      PrintDueTot(0);

                    LastCust:=FullNomKey(GetLineNomCode);

                    PrintNomLine(FullNomKey(GetLineNomCode),BOff);

                  end;

                end;

      end; {Case..}


      DefFont (0,[]);

      SetReportDrillDown(0);

      Case ReportMode of
        2  :
              Begin
                With LId do
                Begin
                  If (IDDocHed=RUN) then
                    Summary:=BOn
                  else
                    Summary:=Not Syss.SepDiscounts;

                    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                    {$IFDEF SOP}
                      If (AccrualMode=2) then
                        Rnum:=Round_Up(Conv_TCurr(InvLCost(LId)*DocCnst[IdDocHed],XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                      else
                    {$ENDIF}

                        Rnum:=Round_Up(Conv_TCurr(DetLTotal(LId,Summary,BOff,0.0),XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

                    ShowDrCrD(Rnum,CrDr);

                    Rnum:=Round_Up(Rnum,2)+Round_Up(PreviousBal,2);

                  end; {With..}

                  With LInv do
                  Begin
                    If (Not EmptyKey(TransDate,LDateKeyLen)) then
                      GenStr:=POutDate(TransDate);

                   // If (Not EmptyKey(LId.CCDep[BOn],CCKeyLen)) then
                      CCStr:=LId.CCDep[BOn];

                   // If (Not EmptyKey(LId.CCDep[BOff],CCKeyLen)) then
                      DepStr:=LId.CCDep[BOff];

                    SendLine(ConCat(#9,OurRef,#9,GenStr,
                          #9,CustCode,
                          #9,PPR_OutPr(LId.PPr,LId.PYr),
                          #9,LId.Desc,
                          #9,FormatBFloat(GenRealMask,LId.PreviousBal,(PRun=0) or (AccrualMode<>0)),
                          #9,FormatBFloat(GenRealMask,CrDr[BOff],BOn),
                          #9,FormatBFloat(GenRealMask,CrDr[BOn],BOn),
                          #9,FormatBFloat(GenRealMask,Rnum,(PRun=0) or (AccrualMode<>0)),
                          #9,CCStr,#9,DepStr,
                          #9,LId.JobCode,#9,LId.AnalCode));
                  end; {With..}

              end;

      end; {Case..}


      CalcDueTotals(CrDr);

    end; {With(s)..}
end;




function TPostReport.IncludeRecord  :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;


Var
  TmpInclude :  Boolean;
  Rnum       :  Double;

  KeyCS      :  Str255;

  ChkNom     :  Str10;


Begin
  Rnum:=0;

  TmpInclude:=BOff;

  KeyCS:='';

  {$B-}

  With MTExLocal^,RepFiler1 do
    With CRepParam^ do
    Begin
      Case ReportMode of
        2
             :  With LId do
                Begin
                  If (Assigned(ThisScrt)) then {* Get Id Link *}
                    ThisScrt^.Get_Scratch(LRepScr^);

                  KeyCS:=FullNomKey(FolioRef);

                  LResetRec(Fnum);

                  If (FolioRef>0) or ((AccrualMode<>0) and (FolioRef<>0)) then
                    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS);

                  If (AccrualMode<>2) then
                    ChkNom:=FullNomKey(PostedRun)
                  else
                    ChkNom:=RepKey;

                  {* Filter out any Auto Items by checking Folio Ref>=0, and some Posted lines with a 0
                     value do not get allocated a run no, so need to check lines runno = Doc Heds unless a run no. *}

                  TmpInclude:=(((CheckKey(ChkNom,RepKey,Length(ChkNom),BOn)) or (AllRuns)) and
                              ((FolioRef>=0) or (AccrualMode<>0)) and ((ChkNom=FullNomKey(LInv.RunNo)) or (IDDocHed=RUN)
                                                 or (LInv.RunNo=BatchRunNo) or (AccrualMode<>0)) and
                              (((IDDocHed=RUN) and (Currency=0)) or (IDDocHed<>RUN)) and
                              ((AccrualMode = 0) or (Pr2Fig(LInv.ACYr,LInv.ACPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr))) and
                              ((IdDocHed In DayBkFlt+[RUN]) and ((Not OnHold(LInv.HoldFlg)) or (IsReRun))));

                  If ((Not CheckKey(ChkNom,RepKey,Length(ChkNom),BOn)) and (Not AllRuns)) then
                  Begin
                    KeyS:=FullNomKey(LastAddrD);

                    B_Next:=B_GetGEq;
                  end;

                end;

      end; {Case..}
    end; {With..}

    {$B+}

    Result:=TmpInclude;
end;


Procedure TPostReport.Print_PostSummary;

Var
  APrYr  :  Word;

Begin
  With RepFiler1,PrTotal^ do
  Begin
    CurrNode:=GetFirst;

    While (CurrNode<>Nil) and (Not ThreadRec^.THAbort) do
    Begin
      PrTotals:=CurrNode^.LItem;

      If (LinesLeft<5) then
        ThrowNewPage(5);

      With PrTotals^ do
      Begin
        APrYr:=AdjYr(PrYr,BOn);


        SendLine(ConCat(ConstStr(#9,6),PPR_OutPr(PrPr,PrYr),'-',FullYear(APrYr),
                #9,FormatBFloat(GenRealMask,CrDr[BOff],BOff),
                #9,FormatBFloat(GenRealMask,CrDr[BOn],BOff)));

      end; {With..}

      CurrNode:=CurrNode^.LNext;

    end; {While..}

  end;
end;





Procedure TPostReport.PrintEndPage;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    PrintDueTot(0);

    If RepPrintExcelTotals then
    Begin
      DefLine(-1,1,PageWidth-MarginRight-1,0);

      PrintDueTot(1);

      DefLine(-1,1,PageWidth-MarginRight-1,0);

      Print_PostSummary;

      If (PRun>0) and (AccrualMode=0) then
        Print_WarnDifference(Round_Up(RepTotal[BOn]-RepTotal[BOff],2),PRun,NoDeviceP);
    end;
    
    Inherited PrintEndPage;

  end; {With..}
end;



{$IFDEF SOP}
  { =========== Proc to Scan and Build Sales Accrual Report ========= }

  Procedure TPostReport.Build_SalesAccrual(Mode     :  Byte;
                                       Var FoundOk  :  Boolean);


  Const
    Fnum     =  IdetailF;
    Keypath  =  IdRunK;



  Var
    KeyCS,
    KeyChk,
    KeyInv   :  Str255;

    RecAddr  :  LongInt;

    MatchStr :  Str255;

    TmpInclude
             :  Boolean;



  Begin

    With MTExLocal^,CRepParam^ do
    Begin

      KeyChk:=FullRunNoKey(PRun,1);
      KeyCS:=KeyChk;

      RecAddr:=0;

      FoundOk:=BOff;
      TmpInclude:=BOff;

      ShowStatus(2,'Please Wait, Building Report');

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyCS,RepLenCnst,BOn)) and (ChkRepAbort) do
      With LId do
      Begin


        TmpInclude:=((IdDocHed In DayBkFlt) and (Is_FullStkCode(StockCode)) and (Pr2Fig(LInv.ACYr,LInv.ACPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)));



        If (TmpInclude) then
        Begin
          LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

          MatchStr:=FullRunNoKey(FolioRef,AbsLineNo);

          ThisScrt^.Add_Scratch(Fnum,IdLinkK,RecAddr,FullNomKey(GetLineNomCode)+DocPRef,MatchStr);

          FoundOk:=BOn;

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

      end; {While..}


    end; {With..}
  end; {Proc..}
{$ENDIF}

Function TPostReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    ThTitle:='Posting Report';

    { - Set AllRuns if Run No = 0 - }
    { - and Set Run no to 1 to exclude 0 ones - }

    AllRuns:=(PRun=-1);


    {$IFDEF SOP}
      AccrualMode:=(1*Ord(PRun=OrdUPRunNo))+(2*Ord(PRun=OrdUSRunNo));
    {$ELSE}
      AccrualMode:=0;
    {$ENDIF}

    If (AllRuns) then
      RepTitle:=ThTitle+' - All Runs'
    else
      If (PRun=0) then
        RepTitle:=ThTitle+' - Unposted Items '
      else
        {$IFDEF SOP}
          If (AccrualMode<>0) then
          Begin
            PRun:=0;

            RepTitle:=ThTitle+' - '+DocGroup[AccrualMode]+' Accruals upto and including '+PPR_OutPr(GetLocalPr(0).CPr,GetLocalPr(0).CYr)+'.';
          end
          else
        {$ENDIF}

          RepTitle:=ThTitle+' - Run '+Form_Int(PRun,1);

    PageTitle:=RepTitle;

    {If (Not NoDeviceP) then V5 force report to be 7 point & landscape}
    Begin
      RFont.Size:=7;
      ROrient:=RPDefine.PoLandscape;
    end;

    {$IFDEF SOP}
       If (AccrualMode<>0) then
       Begin
         Case AccrualMode of
           1  :  DayBkFlt:=[PDN];
           2  :  DayBkFlt:=[SDN];
         end; {Case..}
       end
       else
    {$ENDIF}
        GetPostMode(PMode,DayBkFlt);

    RFnum:=IdetailF;

    If (AllRuns) then
    Begin

      RKeyPath:=IdNomK;

      RepLen:=256;

      RepKey:=FullNomKey(1);
    end
    else
    Begin
      RKeyPath:=IdRunK;

      RepKey:=FullRunNoKey(PRun,1);  {* Bypass Desc only lines & others *}

      RepLenCnst:=Sizeof(PRun);

      RepLen:=257;  {* Force a Replen thru *}

    end;

  end; {With..}

  Result:=BOn;
end;


Procedure TPostReport.Process;

Var
  FoundOk :  Boolean;
Begin
  FoundOk:=BOff;
  InitStatusMemo(4);
  LDataPath := ReportDataPath;
  Inherited Process;

  With CRepParam^ do
  Begin
    {$IFDEF SOP}
      If (AccrualMode=2) then {We have to go via the scratch file}
      Begin
        New(ThisScrt,Init(20,MTExLocal,BOff));

        RepKey:=FullNomKey(ThisScrt^.Process);

        RepLen:=Length(RepKey);

        RKeyPath:=RpK;
        RFnum:=ReportF;

        Build_SalesAccrual(AccrualMode,FoundOk);

        {ThreadRec^.THAbort:=Not FoundOk; Removed v5.71 as caused aborted by user message to appear at the end of the report}
      end;
    {$ENDIF}
  end;

//  Inherited Process;
end;



Procedure TPostReport.Finish;


Begin
  Inherited Finish;
end;


{ ======== }



Procedure AddPostRep2Thread(LMode    :  Byte;
                            IRun     :  LongInt;
                            IMode    :  Byte;
                            IRepParam:  PostRepPtr;
                            Ask4P    :  Boolean;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TPostReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;
        PMode:=IMode;
        PRun:=IRun;

        NoDeviceP:=Not Ask4P;

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;

          If (NoDeviceP) then
          With CRepParam^.PParam do
          Begin
            RDevRec:=PDevRec;
            RFont.Assign(UFont);
            ROrient:=Orient;
          end;

        end;

        If (Create_BackThread) and (Start) then
        Begin
          SetPrinter;
          If (NoDeviceP) then
          With CRepParam^.PParam do
          Begin
            ROrient:=Orient; {* Re-assign *}
          end;

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





procedure TPostReport.SetPrinter;
var
  oToolkit : IToolkit;
  Res : Integer;
begin
  CoInitialize(nil);
  oToolkit := CreateToolkitWithBackDoor;
  Try
    oToolkit.Configuration.DataDirectory := ReportDataPath;
    Res := oToolkit.OpenToolkit;
    if Res = 0 then
    begin
      with oToolkit.SystemSetup.ssPaperless as ISystemSetupPaperless3 do
        RDevRec.DevIdx := pfFind_DefaultPrinter(ssEmailAttachmentPrinter);
    end
    else
      RDevRec.DevIdx := 0;

    CRepParam.PParam.Orient := poLandscape;
  Finally
    oToolkit := nil;
    CoUninitialize;
  End;
end;

Initialization

GenRealMask := '###,###,##0.00 ;###,###,##0.00-';

Finalization

end.