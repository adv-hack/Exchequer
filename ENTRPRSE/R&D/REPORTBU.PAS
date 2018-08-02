unit ReportBU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TISVATReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private

                       Procedure CVATHed;

                       Procedure CalcIntraTotals;

                       Procedure PrintIntraTot;

                       Function DueInclude :  Boolean;

                       Procedure IntraDetail;

                       Function IntraInvInclude(InvR  :  InvRec;
                                                Sdate,
                                                Edate :  LongDate)  :  Boolean;

                       Procedure Scan_4ECSales(CCode     :  Str10;
                                               CSup      :  Char);


                       Function Scan_4Items(CMode  :  Byte;
                                            Sdate,
                                            Edate  :  LongDate;
                                            VATChk :  Char)  :  LongInt;

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  ISVATRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure RepPrint(Sender  :  TObject); Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddISVATRep2Thread(LMode    :  Byte;
                             IRepParam:  ISVATRepPtr;
                             AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  MiscU,
  {DocSupU1,}
  SalTxl1U,

  {$IFDEF VAT}
    SetVatU,
  {$ENDIF}
  RpDefine,
  IntMU,
  ExThrd2U;




{ ========== TISVATReport methods =========== }

Constructor TISVATReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);
end;


Destructor TISVATReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TISVATReport.Process;

Begin
  Inherited Process;
end;



Procedure TISVATReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,2:
           Begin
              SetTab (MarginLeft, pjLeft, 10, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 12, 4, 0, 0);
              SetTab (NA, pjLeft, 14, 4, 0, 0);
              SetTab (NA, pjRight, 15, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 14, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;




{ ======================= Due Header ======================= }



Procedure TISVATReport.CVATHed;


Const
  IRepTit  :  Array[1..2] of Str10 = ('DISPATCHES','ARRIVALS');

  JRepTit  :  Array[1..2] of Str10 = ('116','216');


Var
  n  :  Byte;


Begin

  With CRepParam^, RepFiler1 do
  With Syss do
  Begin

    If (CurrentPage=1) then
      TotItem:=Scan_4Items(ReportMode,SDate,Edate,VATChk);


    For n:=1 to 4 do
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

    DefFont (3,[fsBold,fsUnderLine]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintCenter (Trim(PageTitle), PageWidth / 2);
    Self.CRLF;
    Self.CRLF;

    ClearTabs;

    SetTab (MarginLeft, pjLeft, 125, 4, 0, 0);
    SetTab (NA, pjLeft, 90, 4, 0, 0);

    DefFont (3,[]);

    SendLine(ConCat(#9,'Trader',' ','VAT',' ','Reg',' ','No:',' ',UserVATReg));

    For n:=1 to 2 do
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

    SendLine(ConCat(#9,UserName));

    For n:=1 to 2 do
      SendLine(ConCat(#9,DetailAddr[n]));

    SendText(ConCat(#9,DetailAddr[3]));

    DefFont(6,[]);

    SendLine(ConCat(#9,#9,IRepTit[ReportMode]));

    DefFont(3,[]);

    SendLine(ConCat(#9,DetailAddr[4]));

    SendLine(ConCat(#9,DetailAddr[5],
                    #9,'Period:',' ',SetN(VPr),'/',Form_Int(VYr,0),
                    '  ','No.',' ','of',' ','Items:',' ',Form_Int(TotItem,0)));

    SendLine(ConCat(#9,'Job',' ','No.:',' ',JRepTit[ReportMode]));

    DefFont(0,[]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    RepSetTabs;
  end;

end;



Procedure TISVATReport.RepPrintPageHeader;

Var
  GenStr  :  Str255;
  n       :  VATType;

Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintRight (Concat('Page : ',IntToStr(CurrentPage)), PageWidth - MarginRight);
    Self.CRLF;
    Self.CRLF;

    Case ReportMode of

      1  :  Begin
              SendLine(ConCat(#9,#9,'1.',' ','Commod.',#9,'2.',' ','Value',#9,'3.',' ','Deliv.',
                      #9,'4.',' ','Nature',#9,'5.',' ','Net',#9,'6.',' ','Supplem-',#9,'7.',' ','Ctry',
                      #9,'8.',' ','Mode',' ','of',#9,'9.',' ','Ctry',' ','of',#9,'10.',' ','No. of',
                      #9,'11.Traders'));

              SendLine(ConCat(#9,#9,'code',#9,'Sterling',#9,'terms',#9,'of',' ','trans.',
                              #9,'Mass(kg)',#9,'entary',' ','units',#9,'of',' ','dest.',#9,'transport',
                              #9,'origin',#9,'consignmts',#9,'reference'));
            end;


      2  :  Begin
              SendLine(ConCat(#9,#9,'1.',' ','Commod.',#9,'2.',' ','Value',#9,'3.',' ','Deliv.',
                      #9,'4.',' ','Nature',#9,'5.',' ','Net',#9,'6.',' ','Supplem-',#9,'7.',' ','Ctry',
                      #9,'8.',' ','Mode',' ','of',#9,'9.',' ','Ctry',' ','of',#9,'10.',' ','No. of',
                      #9,'11.Traders'));

              SendLine(ConCat(#9,#9,'code',#9,'Sterling',#9,'terms',#9,'of',' ','trans.',
                      #9,'Mass(kg)',#9,'entary',' ','units',#9,'of',' ','consg',#9,'transport',
                      #9,'origin',#9,'consignmts',#9,'reference'));
            end;

    end; {case..}

    DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


Procedure TISVATReport.RepPrintHeader(Sender  :  TObject);
Begin

  With RepFiler1 do
  Begin

    If (CurrentPage=1) then
    Begin
      RepSetTabs;
    end;

    CVATHed;

    RepPrintPageHeader;

  end; {With..}
end;


{ ======================= Calculate Due Totals ==================== }

Procedure TISVATReport.CalcIntraTotals;



Begin

  With CRepParam^ do
  Case ReportMode of

    1,2    :  Begin

                Inc(ItemRun);

              end;

  end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TISVATReport.PrintIntraTot;

Var
  n          :  Byte;


Begin

  With CRepParam^,RepFiler1  do
  Case ReportMode of
    1,2  :  Begin
              DefLine(-2,MarginLeft,PageWidth-MarginRight-1,0);

              ClearTabs;

              SetTab (MarginLeft, pjLeft, 125, 4, 0, 0);
              SetTab (NA, pjLeft, 90, 4, 0, 0);

              For n:=1 to 2 do
                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;

              DefFont(3,[]);

              SendLine(ConCat(#9,#9,'Place',' ','and',' ','date'));

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
              SendLine(ConCat(#9,#9,'.................................'));

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;

              SendLine(ConCat(#9,#9,'Name',' ','of',' ','Signatory',' ','(in',' ','BLOCK',' ','LETTERS)'));

              SendLine(ConCat(#9,'Your',' ','declaration',' ','must',' ','be'));

              SendLine(ConCat(#9,'received',' ','by',' ','the',' ','10th',' ','working',
                      #9,'..................................'));

              SendLine(ConCat(#9,'day',' ','after',' ','the',' ','period',' ','end.'));

              SendLine(ConCat(#9,#9,'Signature'));

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;


              SendLine(ConCat(#9,#9,'..................................'));

          end; {Case..}

  end; {Case..}

end;


Procedure TISVATReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^, CRepParam^ do
  Begin
    Case ReportMode of
      1,2  :  Begin
                SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
                SendRepDrillDown(2,2,2,LStock.StockCode,StockF,StkCodeK,0);
                SendRepDrillDown(4,4,2,LStock.StockCode,StockF,StkCodeK,0);
                SendRepDrillDown(7,7,2,LStock.StockCode,StockF,StkCodeK,0);
              end;

    end; {Case..}
  end; {With..}
end;


Procedure TISVATReport.PrintReportLine;


Var
  Rnum,
  Rnum2      :  Real;

  Lnum       :  LongInt;

  n,TmpDecs,
  TmpDecs2   :  Byte;

  RepCnst    :  Integer;

  LineTot    :  AgedTyp;

  GenStr     :  Str80;

  Cntry      :  Str10;

  TBo        :  Boolean;




Begin


  Rnum:=0;

  Rnum2:=0;

  Lnum:=0;

  Cntry:='';

  RepCnst:=1;

  TmpDecs:=0;

  TmpDecs2:=0;

  Blank(LineTot,Sizeof(LineTot));


  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin

    SetReportDrillDown(0);

    Case ReportMode of
      1,2
         :  Begin
              With LCust do
              With LInv do
              With LStock do
              With LId do
              Begin

                CalcIntraTotals;

                If (ReportMode=1) then
                  RepCnst:=-1;

                Rnum:=DetLTotal(LId,BOn,BOff,0.0)*LineCnst(Payment);  {* -ves not allowed, must use +ve only! *}
                                                          {* v2.30 Inv.OrigRates used so it is expressed in orig Co Rate *}
                LineTot[1]:=Round_Up(Conv_VATCurr(Rnum,VATCRate[UseCoDayRate],
                                     XRate(LInv.OrigRates,BOff,Currency),Currency,UseORate),2);

                Case ReportMode of
                  1  :  Begin

                          {LineTot[2]:=Round_Up(Qty*Stock.SWeight,0);}

                          LineTot[2]:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*LWeight,0);

                        end;

                  2  :  Begin
                          {LineTot[2]:=Round_Up(Qty*Stock.PWeight,0);}

                          {* Use weight at the time of the transaction *}

                          LineTot[2]:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*LWeight,0);

                        end;

                end; {Case..}

                If (UnitSupp<>'') then
                  LineTot[3]:=DivWChk((Qty*QtyMul),LStock.SuppSUnit)
                else
                  LineTot[3]:=0;

                Lnum:=1;

                Cntry:=Copy(VATRegNo,1,2);

                GenStr:=LInv.OurRef;



              end;

              With LStock do
              With LInv do
              Begin


                SendLine(ConCat(#9,Form_Int(ItemRun,0),
                        // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                        #9,Copy(CommodCode, 1, 8),
                        #9,FormatFloat(GenRNDMask,LineTot[1]),
                        #9,DelTerms,
                        #9,Form_Int(TransNat,0),
                        #9,FormatFloat(GenRNDMask,LineTot[2]),
                        #9,FormatBFloat(GenRNDMask,LineTot[3],BOn),' ',
                           UnitSupp,
                        #9,Cntry,
                        #9,Form_Int(TransMode,0),
                        #9,
                        #9,Form_Int(Lnum,0),
                        #9,GenStr));



              end; {With..}

          end;


    end; {Case..}

  end; {With(s)..}
end;



{ ======================= VAT End ======================= }


Procedure TISVATReport.PrintEndPage;

Var
  TmpRepMode  :  Integer;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    PrintIntraTot;
  end; {With..}
end;



{ ======================= LineDue Include ======================= }


Function TISVATReport.DueInclude :  Boolean;

Const
  Fnum    =  InvF;
  KeyPath =  InvFolioK;

Var
  TmpInclude :  Boolean;
  DayRepInc  :  Boolean;

  ChkRecon   :  Byte;


Begin
  TmpInclude := False;
  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin

    LGetMainRec(StockF,LId.StockCode);


    Case ReportMode of

        1,2
             :  With LId  do
                Begin

                  TmpInclude:=((LineNo>0) and (VATCode=VATChk));


                end;

      end; {Case..}

    end; {With..}

    {$B+}

    DueInclude:=TmpInclude;
end; {Func..}




Procedure TISVATReport.IntraDetail;

Const
  Fnum     =  IdetailF;
  Keypath  =  IdFolioK;

Var
  KeyChk,
  KeyCS    :   Str255;


Begin


  With MTExLocal^,CRepParam^,RepFiler1 do
  Begin

    KeyChk:=FullNomKey(LInv.FolioNum);
    KeyCS:=KeyChk;

    ShowStatus(2,'Processing Transaction '+LInv.OurRef);

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (ChkRepAbort) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) do
    Begin

      If (LinesLeft<5) then
        ThrowNewPage(-1);

      If (DueInclude) then
        PrintReportLine;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);


      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}

  end; {With..}


end;


{ ============== Function to Check Inclusion =========== }

Function TISVATReport.IntraInvInclude(InvR  :  InvRec;
                                      Sdate,
                                      Edate :  LongDate)  :  Boolean;



Begin

  {* ************ If this is altered, must alter version in ReportAU, and EDI section *}
  With InvR do
  Begin
    Result:=((TransDate>=SDate) and (TransDate<=EDate))
      and ((RunNo>=0) or (RunNo=BatchRunNo)) {Debug mode only}
      and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet));

    {Result:= (((TransDate>=SDate) and (TransDate<=EDate))
          or ((PostDate>=SDate) and (PostDate<=EDate) and (TransDate<SDate)))
              and (RunNo>0) and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet));}

  end; {With..}
end; {Func..}




{ ==== Function to Scan a given customer and check the Sales value between any given dates ==== }


Procedure TISVATReport.Scan_4ECSales(CCode     :  Str10;
                                     CSup      :  Char);



Const
  Fnum       =  InvF;
  Keypath    =  InvCustK;


Var
  KeyCS,
  KeyChk     :  Str255;


  Rnum       :  Real;


Begin

  Rnum:=0;


  With MTExLocal^ do
  Begin

    KeyChk:=FullCustType(CCode,CSup);

    KeyCS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LInv do
    With CRepParam^ do
    Begin

      If (IntraInvInclude(LInv,SDate,Edate)) then
        IntraDetail;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

  end; {With..}
end; {Proc..}





{ ======================= VAT Include ======================= }


Function TISVATReport.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;


Begin
  TmpInclude := False;
  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      1,2
           :  With LCust do
              Begin

                TmpInclude:=(EECMember) and (CustSupp=TradeCode[(ReportMode=1)]);

                If (TmpInclude) then
                  Scan_4ECSales(CustCode,CustSupp);


              end;

    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}




Procedure TISVATReport.RepPrint(Sender  :  TObject);

Var

  m            :  Byte;


Begin


  With MTExLocal^,CRepParam^,RepFiler1 do
  Begin

    RepLen:=Length(RepKey);

    KeyS:=RepKey;

    ShowStatus(2,'Processing Report.');


    LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyS);

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (ChkRepAbort) and (CheckKey(RepKey,KeyS,RepLen,BOn)) do
    Begin

      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);


      If (IncludeRecord) then
      Begin
        Inc(ICount);

      end;

      LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyS);


      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;

    end; {While..}

    If (LinesLeft<11) then
      ThrowNewPage(11);

    PrintEndPage;

  end; {With..}


end;


{ ==== Function to Scan all given customer/suppliers and check the No. of Items between any given dates ==== }


Function TISVATReport.Scan_4Items(CMode  :  Byte;
                                  Sdate,
                                  Edate  :  LongDate;
                                  VATChk :  Char)  :  LongInt;

Const
  Fnum        =  CustF;
  Keypath     =  CustCntyK;

  Fnum1       =  InvF;
  Keypath1    =  InvCustK;

  Fnum2       =  IdetailF;
  Keypath2    =  IdFolioK;

Var
  KeyCS,
  KeyChk,
  KeyS2,
  KeyChk2,
  KeyCF       :  Str255;


  Lnum        :  LongInt;


  TmpInclude  :  Boolean;



Begin

  Lnum:=0;


  With MTExLocal^ do
  Begin

    KeyCF:=TradeCode[(Cmode=1)];

    TmpInclude:=BOff;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCF);

    ShowStatus(2,'Collecting Totals...');

    While (LStatusOk) and (ChkRepAbort) and (LCust.CustSupp=TradeCode[(CMode=1)]) do
    With LCust do
    Begin

      TmpInclude:=(EECMember);

      If (TmpInclude) then
      Begin
        KeyChk:=FullCustType(CustCode,CustSupp);

        KeyCS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum1,KeyPath1,KeyCS);

        While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
        With LInv do
        Begin

          If (IntraInvInclude(LInv,SDate,Edate)) then
          Begin

            KeyChk2:=FullNomKey(FolioNum);

            KeyS2:=FullIdKey(FolioNum,1);

            LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);


            While (LStatusOk) and (Checkkey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (ChkRepAbort) do
            With LId do
            Begin


              Lnum:=Lnum+Ord((VATCode=VATChk) and (LineNo>0));



              LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyS2);


            end; {Loop..}

          end;{If In Range }


          LStatus:=LFind_Rec(B_GetNext,Fnum1,KeyPath1,KeyCS);

        end; {Inv Loop..}

      end; {Cust Check Loop..}

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCF);

    end; {Cust Loop..}
  end; {With..}

  If (ChkRepAbort) then
    RepAbort:=(Lnum=0);


  Scan_4Items:=LNum;

end; {Proc..}




Function TISVATReport.GetReportInput  :  Boolean;

Var
  NYear,
  VSYr,VSPr  :  Integer;


Begin
  With CRepParam^ do
  Begin


    ThTitle:='Intra SSD';

    RepTitle:='Intra EC Trade Statistics';

    {If (Debug) then
    Begin
      VPr:=07; NYear:=1996;

      VYr:=NYear;
    end;}

    {RepCtrl^.AbortPrint:=Inp_ECSalesReport(VATStartD,VATEndD,HedTit);}

    PageTitle:=Reptitle+' - Supplementary Declaration';

    NYear:=ConvTxYrVal(VYr,BOff);

    Sdate:=StrDate(NYear,VPr,01);

    Edate:=StrDate(NYear,VPr,MonthDays[VPr]);

    Case ReportMode of
      1  :  VATChk:=VATECDCode;
      2  :  VATChk:=VATEECCode;
    end;

    RFnum:=CustF;

    RFont.Size:=7;

    RKeyPath:=CustCntyK;

    RepKey:=Tradecode[(ReportMode=1)];

  end; {With..}

  Result:=BOn;
end;





Procedure TISVATReport.Finish;


Begin

  Inherited Finish;

end;


{ ======== }




Procedure AddISVATRep2Thread(LMode    :  Byte;
                             IRepParam:  ISVATRepPtr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TISVATReport;

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