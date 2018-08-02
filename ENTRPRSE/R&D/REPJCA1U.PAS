unit RepJCA1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU,
  RepJCX1U;


type



  TJCActualReport  =  Object(TJCXposeReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       LastAnalCode  :  Str10;

                       Procedure PrintAnlLine(Const JCode  :  Str10;
                                              Const Cont   :  Boolean);

                       Procedure Get_JDPos(Var   LineTot    : Totals;
                                           Const JDetl      : JobDetlRec;
                                           Const RCr,RXlate : Byte); Virtual;

                       Procedure PrintDueTot(Gtot      :  Byte); Virtual;

                       Procedure CalcDueTotals(LTot      :  Totals); Virtual;

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown2(DDMode  :  Byte;
                                                     ACCode  :  Str10);

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;


                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddJCAnalRep2Thread(LMode    :  Byte;
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
  ExThrd2U;


{ ========== TJHistReport methods =========== }

Constructor TJCActualReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);


  LastAnalCode:='';

  SCrtMode:=9;
end;


Destructor TJCActualReport.Destroy;

Begin

  Inherited Destroy;
end;







Procedure TJCActualReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 55, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        2 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 25, 4, 0, 0);
              SetTab (NA, pjRight, 25, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}
  SetTabCount;

end;





Procedure TJCActualReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  SendLine(ConCat(#9'Analysis Code',#9,'Description',#9,'Cost',#9,'Uplift',#9,'Charge',#9,'Revenue'));



      2   :  SendLine(ConCat(#9,'Our Ref',#9,'Time/Stock Code',#9,'Qty',#9,'Employee Description',#9,'U/Cost',
                             #9,'Cost',#9,'Uplift',#9,'M/Up %',#9,'Charge',#9,'Revenue'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}

end; {Proc..}




  { ====================== Get Full Employee Rec & Print ====================== }

  Procedure TJCActualReport.PrintAnlLine(Const JCode  :  Str10;
                                         Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;
    LOk      :  Boolean;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      
      If (JCode<>NdxWeight) then
      Begin
        If (LJobMisc^.JobAnalRec.JAnalCode<>JCode) then
          LOk:=LRepGetJobMisc(JCode,2)
        else
          LOk:=BOn;
      end
      else
        LOk:=(JCode<>'');



      If (LOk) then
      Begin

        DefFont(0,[fsBold]);

        If (Cont) then
          ContStr:=' (continued...)'
        else
          ContStr:='';

        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        With LJobMisc^.JobAnalRec do
          Self.PrintLeft(ConCat(JAnalName+ContStr),MarginLeft);
        Self.CrLF;

        {DefLine(-1,1,100,-0.3);}

        DefFont(0,[]);
      end;
    end; {With..}
  end;


Procedure TJCActualReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1,CRepParam^ do
  Begin


    Case ReportMode of
        2  :  If (CurrentPage>1) then
                PrintAnlLine(LastAnalCode,BOn);
    end; {Case..}
  end; {With..}
end;





{ ======================= Due Sub / Grand Total ================ }

Procedure TJCActualReport.PrintDueTot(Gtot      :  Byte);

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
            If (Gtot=0) then
            Begin

              LRepGetJobMisc(LastJob,2);

              With LJobMisc^.JobAnalRec do
                SendText(ConCat(#9,JAnalCode,#9,JAnalName));

            end
            else
            Begin

              SendText(ConCat(#9,#9,'Totals',ConstStr('.',50),' :'));

              StkTot:=RepTotal;

            end;


            SendLine(ConCat(ConstStr(#9,3),FormatFloat(GenRealMask,StKTot[1]),
                            #9,FormatFloat(GenRealMask,StKTot[4]),
                            #9,FormatFloat(GenRealMask,StKTot[2]),
                            #9,FormatFloat(GenRealMask,StKTot[3])));

            Blank(STKTot,Sizeof(StkTot));


          end; {Case..}

   2
       :  Begin
            If (Gtot=0) then
            Begin
              DefLine(-1,TabStart(5),TabEnd(10),0);

              LRepGetJobMisc(LastJob,2);

            end
            else
            Begin
              StkTot:=RepTotal;

            end;


            SendLine(ConCat(ConstStr(#9,5),'Totals:',#9,FormatFloat(GenRealMask,StKTot[1]),
                            #9,FormatFloat(GenRealMask,StKTot[4]),
                            #9,#9,FormatFloat(GenRealMask,StKTot[2]),
                            #9,FormatFloat(GenRealMask,StKTot[3])));


            If (Gtot=0) then
            Begin
              DefLine(-2,TabStart(5),TabEnd(10),0);

            end;


            Blank(STKTot,Sizeof(StkTot));


          end; {Case..}


  end; {Case..With..}

end;


{ ======================= Calculate Due Totals ==================== }

Procedure TJCActualReport.CalcDueTotals(LTot      :  Totals);

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

Procedure TJCActualReport.Get_JDPos(Var   LineTot    : Totals;
                                   Const JDetl      : JobDetlRec;
                                   Const RCr,RXlate : Byte);


Var
  UOR   :  Byte;

  Dnum2,
  Dnum3,
  Dnum  :  Double;


Begin
  UOR:=0;

  With MTExLocal^, JDetl.JobActual do
  Begin

    Dnum:=(Qty*Cost*DocCnst[JDDT]);

    If (JDDT In SalesSplit-RecieptSet) then
      Dnum:=Dnum*DocNotCnst;

    Dnum2:=Charge;

    Dnum3:=Qty*UpliftTotal*DocCnst[JDDT];

    {$IFDEF MC_On}

      If (RCr=0) then
      Begin
        UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

        Dnum:=Round_Up(Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff),2);
        Dnum3:=Round_Up(Conv_TCurr(Dnum3,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff),2);
      end;

      Dnum:=Currency_Txlate(Dnum,RCr,RXLate);

      Dnum3:=Currency_Txlate(Dnum3,RCr,RXLate);

      Dnum2:=Round_Up(Currency_ConvFT(Dnum2,CurrCharge,RCr,UseCoDayRate),2);

      Dnum2:=Currency_Txlate(Dnum2,RCr,RXLate);

    {$ENDIF}

    If (JDDT In SalesSplit) then
      LineTot[3]:=Dnum
    else
    Begin
      LineTot[1]:=Dnum;
      LineTot[2]:=Dnum2;
    end;

    LineTot[4]:=Dnum3;

  end; {With..}

end; {Proc..}



Procedure TJCActualReport.SetReportDrillDown2(DDMode  :  Byte;
                                              ACCode  :  Str10);

Begin
  If (ReportMode=2) then
  With MTExLocal^ do
  Begin
    Case DDMode of
      0,1
         :  Begin
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


Procedure TJCActualReport.PrintReportLine;

Var
  UOR        :  Byte;

  LineTot    :  Totals;

  Dnum,
  Dnum2      :  Double;
  Rnum       :  Real;

  GenStr,
  GenStr2    :  Str255;

  TBo        :  Boolean;

  //PR: 15/08/2017 ABSEXCH-14461
  StockCodeToPrint : string;


Begin

  Blank(LineTot,Sizeof(LineTot));

  Dnum:=0.0; Rnum:=0.0; UOR:=0; Dnum2:=0.0;

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Case ReportMode of
      1,2    :  With LJobDetl^.JobActual do
                 If (AnalCode<>LastJob) then
                 Begin
                   If (LastJob<>'') then
                     PrintDueTot(0);

                   LastJob:=AnalCode;

                   If (ReportMode=2) then
                   Begin
                     PrintAnlLine(AnalCode,BOff);

                     LastanalCode:=AnalCode;


                   end;

                 end;


    end; {Case..}


    Get_JDPos(LineTot,LJobDetl^,RCr,RTxCr);

    Case ReportMode of

      2   : With LJobDetl^.JobActual do
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


              If (Not (JDDT In SalesSplit)) then
                Rnum:=Cost;

              {$IFDEF MC_On}

                If (RCr=0) then
                Begin
                  UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                  Rnum:=Round_Up(Conv_TCurr(Rnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff),2);
                end;

                Rnum:=Currency_Txlate(Rnum,RCr,RTxCr);

              {$ENDIF}

              TBo:=LGet_BudgMUP(JobCode,AnalCode,StockCode,0,Dnum,Dnum2,1);

              SetReportDrillDown2(0+Ord(JDDT=TSH),GenStr2);

              //PR: 15/08/2017 ABSEXCH-14461 If there is a Pay-in Ref in
              //StockCode, remove the #1 prefix before passing to print routines
              if Length(StockCode) > 0 then
              begin
                if StockCode[1] = #1 then
                  StockCodeToPrint := Copy(StockCode, 2, Length(StockCode))
                else
                  StockCodeToPrint := StockCode;
              end;

              SendLine(ConCat(#9,LineORef,
                       #9,StockCodeToPrint,
                       #9,FormatFloat(GenQtyMask,Qty),
                       #9,GenStr2,' ',GenStr,
                       #9,FormatFloat(GenUnitMask[BOff],Rnum),
                       #9,FormatFloat(GenRealMask,LineTot[1]),
                       #9,FormatFloat(GenRealMask,LineTot[4]),
                       #9,FormatFloat(GenPcntMask,Dnum),
                       #9,FormatFloat(GenRealMask,LineTot[2]),
                       #9,FormatFloat(GenRealMask,LineTot[3])));

            end;


    end; {Case..}


    CalcDueTotals(LineTot);
  end; {With..}
end;


{ ======================= Customer End ======================= }


Procedure TJCActualReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin
    For n:=0 to 1 do
    Begin

      If (RepPrintExcelTotals) or (n=0) then
      Begin
        PrintDueTot(n);

        If (n=0) then
          DefLine(-2,MarginLeft,PageWidth-MarginRight-1,0);
      end;
    end;

  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJCActualReport.IncludeRecord  :  Boolean;


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

    If (ReportMode In [1,2]) then
    Begin
      If (ThisScrt<>NIL) then {* Get Id Link *}
        ThisScrt^.Get_Scratch(LRepScr^);


      LResetRec(Fnum);

      KeyS2:=FullIdKey(LineFolio,LineNo);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS2);

    end;


    Case ReportMode of

      1,2
           :
              Begin

                TmpInclude:=BOn;

                LastAnalCode:=analCode;

              end;

    end; {Case..}

  end; {With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJCActualReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    ThTitle:='Job Analysis Report';

    RepTitle:='Job Detailed Analysis Report';

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

    If (Not Summary) then
      ROrient:=RPDefine.PoLandscape;

    PageTitle:=RepTitle;


    {$IFDEF MC_On}

      If (RTxCr<>0) and (RTxCr<>RCr) then
         PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
      else
        PageTitle:=CurrDesc(RCr)+PageTitle;

    {$ENDIF}



     If (CustFilt<>'') then
     Begin
       GetJobMisc(Application.MainForm,CustFilt,FoundCode,2,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Analysis Filter : '+Trim(JobMisc^.JobAnalRec.JAnalName);
     end;

     If (AHedFilt<>0) then
     Begin
       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Analysis Type: '+JobXDesc^[AHedFilt];
     end;

     If (Not EmptyKey(JobFilt,JobKeyLen)) then
     Begin
       GetJob(Application.MainForm,JobFilt,FoundCode,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Job Filter : '+dbFormatName(JobFilt,JobRec^.JobDesc);

       SingProd:=(JobRec^.JobType<>JobGrpCode);
     end;

  end; {With..}

  Result:=BOn;
end;




Procedure TJCActualReport.Process;


Begin

  Inherited Process;

end;


Procedure TJCActualReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJCAnalRep2Thread(LMode    :  Byte;
                              IRepParam:  JobCRep3Ptr;
                              AOwner   :  TObject);


Var
  EntTest  :  ^TJCActualReport;

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