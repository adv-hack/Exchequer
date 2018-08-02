unit Report8U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type

  TNZMiscTotals  =  record
                     NZFringeB,
                     NZImport,
                     NZZero    :  IONetTyp;
                   end;


  TVATRReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private
                       NZMiscTotals  :  TNZMiscTotals;

                       Procedure PrintVATTot(Gtot      :  Boolean);

                       Procedure IE_Summary;

                       Procedure GST_Summary;

                       Procedure NZGST_Summary(IOTot,IONet      :  IONetTyp);

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       {$IFNDEF SOPDLL}
                       // ABSEXCH-13793. Add VAT100 XML report.
                       function ProduceXMLVATReport(aXMLVat100Data : array of double) : string;
                       {$ENDIF}

                     protected
                       // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                       // Functions added for Order Payments to allow values
                       // from Order Payments Sales Receipts to be included in
                       // the Output VAT section of the VAT Summary. These do
                       // nothing in the base class (they return zero), but are
                       // overridden in the TOrderPaymentsVATReturn descendant
                       // class.
                       procedure AdditionalSummaryTotals(ForSales: Boolean; VATCode: char; var Goods, VAT: Double); virtual;

                       procedure AfterSummary; virtual;

                       // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
                       procedure PrintNoTCNote;

                     public
                       IsVR2      :  Boolean;
                       CRepParam  :  VATRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Set_VATTotals(InvR      :   InvRec;
                                               Calc4Real :   Boolean);

                       Function Out_OfPr(InvR      :   InvRec)  :  Boolean;

                       Procedure CalcVATTotals(CrDr      :  DrCrType);

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure VAT_Summary;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Function Start  :  Boolean; Virtual;

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddVATRRep2Thread(LMode    :  Byte;
                            IRepParam:  VATRepPtr;
                            AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  StrUtils,
  ETDateU,
  ETStrU,
  BTKeys1U,
  VarRec2U,
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
    SetVATU,
  {$ENDIF}

  {$IFNDEF SOPDLL}
  // ABSEXCH-13793. Include VAT100 XML output
  VATXMLConst,
  VATXMLWrite,
  // ABSEXCH-14371. Online submission of VAT 100 return
  // 18/07/2013. PKR
  VATSub,
  {$ENDIF}
  
  {$IFDEF CU}
    CustWinU,

  {$ENDIF}

  RpDefine,
  Report9U,

  RevChrgU,
  IntMU,
  ExThrd2U,
  ExWrap1U;




{ ========== TVATRReport methods =========== }

Constructor TVATRReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  IsVR2:=BOff;

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  FillChar(NZMiscTotals,Sizeof(NZMiscTotals),0);

end;


Destructor TVATRReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TVATRReport.Process;

Begin
  Inherited Process;
end;



Procedure TVATRReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    Case ReportMode of

        0..2:
           Begin
              SetTab (MarginLeft, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 12, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjRight,24, 4, 0, 0);
              SetTab (NA, pjLeft,7, 4, 0, 0);

            end;

    end; {Case..}
  end; {With..}
end;


Procedure TVATRReport.RepPrintPageHeader;

Var
  GenStr  :  Str255;
  n       :  VATType;

Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of


      0,2  :
            With SyssVat.VATRates do
            Begin

              Case ReportMode of

                0  :  GenStr:='Date';
                2  :  GenStr:='Date Paid';

              end; {Case..}

                                                                 {* vvv Note use of GenStr *}

              SendText(ConCat(#9,'Our Ref',#9,'Ac No.',#9,GenStr,#9,'Per Yr'));

              For n:=VStart to VEnd do
                SendText(ConCat(ConstStr(#9,Ord(n)+5),VAT[n].DESC));

              SendLine(ConCat(ConstStr(#9,12),'Purchases',#9,'Sales'));
            end;

      
    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


{ ======================= Due Sub / Grand Total ================ }

Procedure TVATRReport.PrintVATTot(Gtot      :  Boolean);

Var
  n          :  VATType;

  PVATTOt    :  VATAry;
  StrTot     :  Str80;

Begin

  StrTot:='';

  With CRepParam^ do
    With RepFiler1 do
    Case ReportMode of
      0,2,20,22
         :  Begin

              Case ReportMode of
                20,22
                    :  Case Gtot of
                         BOff  :  PVATTot:=SplitTotals;
                         BOn   :  PVATTot:=OPSplitTotals;
                       end; {Case..}

                else   Case Gtot of
                         BOff  :  PVATTot:=RepTotals;
                         BOn   :  PVATTot:=OPrAnal;
                       end; {Case..}

              end; {Case..}


              If (Gtot) then
              Begin
                StrTot:='*Out of period trans ..:';

              end
              else
                StrTot:='Total In-period trans .:';

              DefFont(0,[fsBold]);

              If (Not Gtot) and (ReportMode<20) then
              Begin
                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.PrintLeft('Combined Totals:-',MarginLeft);
                Self.CRLF;
              end;

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.PrintLeft(StrTot,MarginLeft);

              For n:=VStart to VEnd2 do
              Begin
                SendText(ConCat(ConstStr(#9,5+Ord(n)),FormatBFloat(GenRealMask,PVATTot[n],BOn)));

                If (Not (ReportMode In [20,22])) then
                  CashAccCS:=CashAccCS+PVATTot[n];

              end;

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;


              If (GTot) then
              Begin
                Blank(SplitTotals,Sizeof(SplitTotals));
                Blank(OPSplitTotals,Sizeof(OPSplitTotals));
              end;


              If (Gtot) and (ReportMode<20) then
              Begin



                If (ReportMode=2) then
                Begin
                  // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                  Self.PrintLeft('Cash Accounting - Check.:',MarginLeft);

                  SendLine(ConCat(ConstStr(#9,5),FormatFloat(GenRealMask,CashAccCS)));

                end;

                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;

                If (CurrentCountry<>SingCCode) then
                Begin
                  // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                  Self.PrintLeft('EC Acquisitions  - Goods.:',MarginLeft);

                  SendLine(ConCat(ConstStr(#9,5),FormatFloat(GenRealMask,EECAqui[BOff,1]),
                           ConstStr(#9,7),FormatFloat(GenRealMask,EECAqui[BOff,2]),
                           #9,FormatFloat(GenRealMask,EECAqui[BOn,2])));
                end;

              end;

              DefFont(0,[]);
            end; {Case..}

    end; {Case..With..}

end;



{ ============= Calculate Line Totals depending on VAT Scheme ============== }

Procedure TVATRReport.Set_VATTotals(InvR      :   InvRec;
                                    Calc4Real :   Boolean);

Var
  n          :  VATType;
  GoodsRate  :  CurrTypes;
  InCurrency : Double;
Begin
  With MTExLocal^,CRepParam^ do
    With InvR do

    Begin

      If (VAT_CashAcc(VATScheme)) then
      Begin

        {$IFDEF VAT}
          Calc_ThisVATSplit(InvR,GoodsTot,VATTot,IPrGoodsAnal,IPrVATAnal,LInvNetAnal);
        {$ENDIF}

      end
      else
      Begin
        GoodsRate:=OrigRates;

        If (OldORates[BOff]<>0.0) then {* We have been through a conversion, and this needs to be stated
                                         in original currency*}
          GoodsRate:=OldORates;

        For n:=VStart to VEnd do
        Begin

          {If (CurrentCountry=SingCCode) then {* For Singapore, Express Goods back to Dayrate, so
                                                it can be calculated back to the std rate %, ie
                                                the GST is 3% of the Goods

                                              02/09/95 Reverted back to  using original Co Rate as requested

            IPrGoodsAnal[n]:=Round_Up((Conv_VATCurr(InvNetAnal[n],VATCRate[On],CXRate[On],
                             Currency)*DocCnst[InvDocHed])*DocNotCnst,2)
          else}


            IPrGoodsAnal[n]:=Round_Up((Conv_VATCurr(LInvNetAnal[n],VATCRate[UseCoDayRate],XRate(GoodsRate,BOff,Currency),
                             Currency,UseORate)*DocCnst[InvDocHed])*DocNotCnst,2);

            IPrVATAnal[n]:=Round_Up(Conv_VATCurr(InvVatAnal[n],VATCRate[BOn],
                           Calc_BConvCXRate(InvR,CXRate[BOn],BOn),Currency,UseORate)*
                           DocCnst[InvDocHed]*DocNotCnst,2);

        end; {Loop..}

        VATTot:=(Conv_VATCurr(InvVat,VATCRate[BOn],Calc_BConvCXRate(InvR,CXRate[BOn],BOn),Currency,UseORate)*DocCnst[InvDocHed]*DocNotCnst);

      end; {If..}


      {$IFDEF VAT}
        {* Calculate any EEC Acquisition implications *}
        If (Calc4Real) then {* Only check on detail line pass *}
        begin
          Get_EECAquiDetails(InvR,IPrGoodsAnal,IPrVATanal,
                                  EECAqui[BOff,1],EECAqui[BOff,2],EECAqui[BOn,2],
                                  NOClaimOVAT,AquiCode,MTExLocal);
        end;

      {$ENDIF}
    end; {With..}
end; {PRoc..}



{ ============= Check for Out of Period by Scheme ============== }

Function TVATRReport.Out_OfPr(InvR      :   InvRec)  :  Boolean;

Var
  EndPr,
  StartPr    :  LongDate;

  Sdd,Smm,Syy,
  Wmm,Wyy    :  Word;

  NCO        :  Boolean;


Begin
  NCo:=BOff;

  With CRepParam^ do
    With InvR do
    Begin
      If (VAT_CashAcc(VATScheme)) then
      Begin

        Out_OfPr:=(ABS(Settled)<ABS(SettledVAT));

      end
      else
      Begin
        {* Calculate out of period relative to docs own VATPost as report may be
             for a range of periods *}

        {$IFDEF CU}
           If (LHaveHookEvent(MiscBase+1,3,NCO)) then
           Begin
             {v5.50. Have assumed that InvR = LInv}


             Result:=(LSetVATPostDate(MTExLocal^,3,'')<>VATPostDate);
           end
           else
        {$ENDIF}

          Begin
            DateStr(VATPostDate,Sdd,Smm,Syy);

            Wmm:=Smm; Wyy:=Syy;

            AdjMnth(Wmm,Wyy,-Pred(SyssVAT^.VATRates.VATInterval));

            StartPr:=StrDate(Wyy,Wmm,01);

            If (Smm=2) then {* Force check for leap year to be up to 29th *}
              sdd:=29;

            EndPr:=StrDate(Syy,Smm,sdd);

            Out_OfPr:=((TransDate<StartPr) or (TransDate>EndPr));
         end;

      end;
    end; {Withs..}

end; {Func..}



{ ======================= Calculate Due Totals ==================== }

Procedure TVATRReport.CalcVATTotals(CrDr      :  DrCrType);

Const
  ECRates    :  Array[BOff..BOn] of VATtype = (Rate3,Rate4);


Var
  VATRate    :  VATType;

  TBo        :  Boolean;

  GoodsRate  :  CurrTypes;

Begin

  With MTExLocal^,CRepParam^ do
    Case ReportMode of
      0..2
         :  With LInv do
            Begin
              TBO:=VATSalesMode(SalesorPurch(InvDocHed),ThisVRate);



              If (Not Out_OfPr(LInv)) then
              Begin

                For VATRate := VStart to VEnd do
                Begin
                  RepTotals[VATRate]:=RepTotals[VATRate]+IPrGoodsAnal[VATRate];

                  SplitTotals[VATRate]:=SplitTotals[VATRate]+IPrGoodsAnal[VATRate];

                end;

                If (TBo) then
                  VATRate := OAdj
                else
                  VATRate := IAdj;

                RepTotals[VATRate]:=RepTotals[VATRate]+Round_Up(CrDr[BOn],2);

                SplitTotals[VATRate]:=SplitTotals[VATRate]+Round_Up(CrDr[BOn],2);
              end
              else
              Begin

                For VATRate := VStart to VEnd do
                Begin
                  OPrAnal[VATRate]:=OPrAnal[VATRate]+IPrGoodsAnal[VATRate];

                  OPSplitTotals[VATRate]:=OPSplitTotals[VATRate]+IPrGoodsAnal[VATRate];
                end;


                If (TBo) then
                  VATRate := OAdj
                else
                  VATRate := IAdj;

                OPrAnal[VATRate]:=OPrAnal[VATRate]+CrDr[BOn];

                OPSplitTotals[VATRate]:=OPSplitTotals[VATRate]+Round_Up(CrDr[BOn],2);

                OPrTotals[TBo,2]:=OPrTotals[TBo,2]+Round_Up(CrDr[BOn],2);


              end;

              For VATRate := VStart to VEnd do
              Begin
                {$IFDEF EX603}
                  TBO:=VATSalesMode(SalesorPurch(InvDocHed), VATRate); {*Ex v6.03. Reapply VAT for reverse split *}
                {$ENDIF}

                Case ReportMode of
                  2  :  Begin
                          IPrTotals[TBo,1,VATRate]:=IPrTotals[TBo,1,VATRate]+IPrGoodsAnal[VATRate];
                          IPrTotals[TBo,2,VATRate]:=IPrTotals[TBo,2,VATRate]+IPrVATAnal[VATRate];
                        end;
                  else  Begin
                          If (Not Out_ofPr(LInv)) then
                          Begin
                            IPrTotals[TBo,1,VATRate]:=IPrTotals[TBo,1,VATRate]+IPrGoodsAnal[VATRate];
                            IPrTotals[TBo,2,VATRate]:=IPrTotals[TBo,2,VATRate]+IPrVATAnal[VATRate];
                          end
                          else
                            Begin
                              EPrTotals[TBo,1,VATRate]:=EPrTotals[TBo,1,VATRate]+IPrGoodsAnal[VATRate];
                              EPrTotals[TBo,2,VATRate]:=EPrTotals[TBo,2,VATRate]+IPrVATAnal[VATRate];
                            end;

                        end;
                end;

                // CJS 2015-05-28 - ABSEXCH-16260 - VAT100 report Box 8
                if (VATRate = Rate4) and TBO then
                  FreeOfChargeTotals := FreeOfChargeTotals + LFreeOfChargeAnalysis[VATRate];

              end;


              {* Split out EEC Goods Totals based on Rate 3 & 4 *}

              //EECTotals[TBo,1]:=EECTotals[TBo,1]+IPrGoodsAnal[ECRates[TBo]];
              //EECTotals[TBo,1]:=EECTotals[TBo,1]+LInvNetAnalLessServices[ECRates[TBo]];

// MH 19/10/2010 v6.5 ABSEXCH-8003: Removed VAT Codes 3 and 4 from boxes 9 and 8 on the VAT Return
// MH 10/01/2011 v6.5 ABSEXCH-8003: Re-instated code as Rate 3/4 also contain Rate A/D figures at this point
(**** *)

              GoodsRate:=OrigRates;
              If (OldORates[BOff]<>0.0) then {* We have been through a conversion, and this needs to be stated in original currency*}
                GoodsRate:=OldORates;
              EECTotals[TBo,1] := EECTotals[TBo,1] + Round_Up((Conv_VATCurr(LInvNetAnalLessServices[ECRates[TBo]],VATCRate[UseCoDayRate],XRate(GoodsRate,BOff,Currency),
                                              Currency,UseORate)*DocCnst[InvDocHed])*DocNotCnst, 2);

              EECTotals[TBo,2]:=EECTotals[TBo,2]+IPrVATAnal[ECRates[TBo]];

              // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services
              if (CurrentCountry = IECCode) then
              begin
                if (TBo) then
                begin
                  // Sales
                  RepECServiceTotals[ectSales][ecvNet] :=
                    RepECServiceTotals[ectSales][ecvNet] + InvECServiceTotals[ectSales][ecvNet];
                end
                else
                begin
                  // Purchases
                  RepECServiceTotals[ectPurchases][ecvNet] :=
                    RepECServiceTotals[ectPurchases][ecvNet] + InvECServiceTotals[ectPurchases][ecvNet];
                  // Include VAT for EC Service Purchases (only, not Sales)
                  RepECServiceTotals[ectPurchases][ecvVAT] :=
                    RepECServiceTotals[ectPurchases][ecvVAT] + InvECServiceTotals[ectPurchases][ecvVAT];
                end;
              end;
(* ****)
            end;



    end; {Case..With..}
end;



Procedure TVATRReport.PrintReportLine;

Const
  Fnum    =  InvF;
  KeyPath =  InvFolioK;

Var
  CrDr       :  DrCrType;

  Rnum       :  Real;

  n          :  VATType;

  TBo        :  Boolean;

  RevalueCh  :  Char;

  GenStr     :  Str255;


Begin

  GenStr:='';

  RevalueCh:=#32;

  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin

    If (LastDocType<>LInv.OurRef[1]) then
    Begin

      If (LastDocType<>C0) then
      Begin
        ReportMode:=ReportMode+20;

        DefLine(-1,1,PageWidth-MarginRight-1,0);

        PrintVATTot(BOff);

        PrintVATTot(BOn);

        ReportMode:=ReportMode-20;

        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        Self.CRLF;
      end;

      LastDocType:=LInv.OurRef[1];

      If (LastDocType=DocCodes[PIN][1]) then
        GenStr:='Inputs'
      else
        GenStr:='Outputs';

      DefFont(0,[fsUnderLine]);

      SendLine(Concat(#9,GenStr));

      DefFont(0,[]);

    end;

    LDef_InvCalc(MTExLocal);

    Set_VATTotals(LInv,BOn);

    Case ReportMode of
      0,2
         :  With LInv do
            Begin
              Blank(CrDr,SizeOf(CrDr));

              TBO:=VATSalesMode(SalesorPurch(InvDocHed),ThisVRate);


              CrDr[TBo]:=VATTot;

              If (ReValued(Inv)) then
                RevalueCh:=RevaluedCode;

              Case ReportMode of
                0  :  GenStr:=PoutDate(Transdate);
                2  :  GenStr:=PoutDateB(UntilDate);
              end; {Case..}

              If (Out_OfPr(LInv)) then
                GenStr:=GenStr+'*';

                {* Note Use of PPr_Pr/Yr vv *}

              SendText(ConCat(#9,OurRef,
                              #9,CustCode,
                              #9,GenStr,
                              #9,PPR_OutPr(ACPr,ACYr)));

              For n:=VStart to VEnd do
              Begin
                Rnum:=IPrGoodsAnal[n];

                SendText(ConCat(ConstStr(#9,5+Ord(n)),FormatBFloat(GenRealMask,Rnum,BOn)));
              end;

              SendLine(ConCat(ConstStr(#9,12),FormatBFloat(GenRealMask,CrDr[BOff],BOn),
                        #9,FormatBFloat(GenRealMask,CrDr[BOn],BOn),#9,RevalueCh,AquiCode));

              CrDr[BOn]:=VATTot;
            end;

    end; {Case..}

    CalcVATTotals(CrDr);

  end; {With(s)..}
end;



{ =========== Procedure to Print GST Version of VAT Return ========= }


Procedure TVATRReport.GST_Summary;


Var

  GSTBox     :  Array[1..8] of Real;
  GSTOPrBox  :  Array[1..2] of Real;

  n          :  VATType;

  m,PadSpc   :  Byte;

  GSTMsg     :  Str20;



Begin


  With CRepParam^,RepFiler1 do
  Begin


    PadSpc:=25;

    Blank(GSTBox,Sizeof(GSTBox));
    Blank(GSTOPrBox,Sizeof(GSTOPrBox));

    GSTMsg:='';

    ClearTabs;

    SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
    SetTab (NA, pjLeft, 10, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight,29, 4, 0, 0);
    SetTab (NA, pjRight,29, 4, 0, 0);



    For n:=VStart to VEnd do
    Begin
      If (n<>Zero) and (n<>Exempt) then
      Begin

        If (SyssVAT.VATRates.VAT[n].Include) then
          GSTBox[1]:=GSTBox[1]+IPrTotals[BOn,1,n];

      end;

      If (n<>Exempt) and (SyssVAT.VATRates.VAT[n].Include) then
        GSTBox[5]:=GSTBox[5]+IPrTotals[BOff,1,n];

      GSTBox[6]:=GSTBox[6]+IPrTotals[BOn,2,n];
      GSTBox[7]:=GSTBox[7]+IPrTotals[BOff,2,n];

      GSTOPrBox[1]:=GSTOPrBox[1]+EPrTotals[BOn,2,n];
      GSTOPrBox[2]:=GSTOPrBox[2]+EPrTotals[BOff,2,n];

    end;

    GSTBox[2]:=IPrTotals[BOn,1,Zero];
    GSTBox[3]:=IPrTotals[BOn,1,Exempt];

    For m:=1 to 5 do
        GSTBox[m]:=Round_Up(GSTBox[m],0);

    GSTBox[4]:=GSTBox[1]+GSTBox[2]+GSTBox[3];

    GSTBox[8]:=GSTBox[6]+GSTBox[7];


    ClearTabs;

    SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
    SetTab (NA, pjLeft, 120, 4, 0, 0);
    SetTab (NA, pjCenter, 10, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);

    SendLine(ConCat(#9,#9,'Total value of standard-rated supplies',#9,'[1]',
                    #9,FormatFloat(GenRealMask,GSTBox[1])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Total value of zero-rated supplies',#9,'[2]',
                    #9,FormatFloat(GenRealMask,GSTBox[2])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Total value of exempt supplies',#9,'[3]',
                    #9,FormatFloat(GenRealMask,GSTBox[3])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Total value of supplies  [(1)+(2)+(3)]',#9,'[4]',
                    #9,FormatFloat(GenRealMask,GSTBox[4])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Total value of taxable purchases',#9,'[5]',
                    #9,FormatFloat(GenRealMask,GSTBox[5])));

    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Output tax due',#9,'[6]',
                    #9,FormatFloat(GenRealMask,GSTBox[6])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    SendLine(ConCat(#9,#9,'Less Input tax claimed',#9,'[7]',
                    #9,FormatFloat(GenRealMask,GSTBox[7])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    DefLine(-1,TabStart(2),TabEnd(4),0);

    If (GSTBox[8]<0) then
      GSTMsg:='claimed by you '
    else
      GSTMsg:='paid by you ...';

    SendLine(ConCat(#9,#9,'Equals: Net GST to be ',GSTMsg,#9,'[8]',
                    #9,FormatFloat(GenRealMask,GSTBox[8])));


    DefLine(-1,TabStart(2),TabEnd(4),0);


    If (GSTOPrBox[1]-GSTOPrBox[2]<>0) or (Debug) then
    Begin

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

      DeFFont(0,[fsUnderLine,fsBold]);

      SendLine(ConCat(#9,#9,'DISCLOSURE OF ERRORS ON GST RETURNS. Please complete form GST F7.',
                     ' Check periods.'));

      DeFFont(2,[]);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

      SendLine(ConCat(#9,#9,'GST Payable by you',#9,
                      #9,FormatFloat(GenRealMask,GSTOPrBox[1])));

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

      SendLine(ConCat(#9,#9,'GST Payable to you',#9,
                      #9,FormatFloat(GenRealMask,GSTOPrBox[2])));

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

    end;

  end; {With..}

end; {proc..}



{ =========== Procedure to Print NZ GST Version of VAT Return ========= }


Procedure TVATRReport.NZGST_Summary(IOTot,IONet      :  IONetTyp);



Var

  GSTBox     :  Array[5..16] of Double;

  GSTOPrBox  :  Array[1..2] of Real;

  CalcBox1,
  CalcBox12,
  CalcBox8,
  CalcBox13  :  Double;

  n          :  VATType;

  m,PadSpc   :  Byte;

  GSTMsg     :  Str20;

  DivRate    :  Integer;

  StdRate    :  Double;



Begin


  With CRepParam^,RepFiler1,NZMiscTotals do
  Begin


    PadSpc:=25;

    Blank(GSTBox,Sizeof(GSTBox));

    Blank(GSTOPrBox,Sizeof(GSTOPrBox));

    GSTMsg:='';

    StdRate:=SyssVAT.VATRates.VAT[Standard].Rate;

    DivRate:=Round((100+(StdRate*100))/(StdRate*100));

    For n:=VStart to VEnd do
    Begin

      GSTOPrBox[1]:=GSTOPrBox[1]+EPrTotals[BOn,1,n];
      GSTOPrBox[2]:=GSTOPrBox[2]+EPrTotals[BOff,1,n];

    end;


    {* Remove all out of period values *}
    GSTBox[5]:=OprTotals[BOn,1]+IOTot[BOn,2]-(NZFringeB[BOn,1]+NZFringeB[BOn,2]+OprTotals[BOn,2]+GSTOPrBox[1]);

    GSTBox[6]:=NZZero[BOn,1];

    GSTBox[7]:=GSTBox[5]-GSTBox[6];

    GSTBox[8]:=IOTOT[BOn,2]-(NZFringeB[BOn,2]+OPrTotals[BOn,2]);

    CalcBox8:=Round_Up(DivWChk(GSTBox[7],DivRate),2);
    CalcBox1:=Round_Up(GSTBox[8]*DivRate,2);

    GSTBox[9]:=NZFringeB[BOn,2];

    GSTBox[10]:=OPrTotals[BOn,2];

    GSTBox[11]:=GSTBox[8]+GstBox[9]+GSTBox[10];

    GSTBox[12]:=OprTotals[BOff,1]+IOTot[BOff,2]-(NZImport[BOff,1]+NZImport[BOff,2])-(NZZero[BOff,1]+NZZero[BOff,2]+OprTotals[BOff,2]+GSTOPrBox[2]);

    GSTBox[13]:=IOTot[BOff,2]-(NZImport[BOff,2]+NZZero[BOff,2]+OPrTotals[BOff,2]);

    CalcBox13:=Round_Up(DivWChk(GSTBox[12],DivRate),2);

    CalcBox12:=Round_Up(GSTBox[13]*DivRate,2);

    GSTBox[14]:=OPrTotals[BOff,2];

    GSTBox[15]:=GSTBox[13]+GSTBox[14];

    GSTBox[16]:=GSTBox[11]+GSTBox[15];


    ClearTabs;

    SetTab (MarginLeft+30, pjLeft, 89, 4, 0, 0);
    SetTab (NA, pjLeft, 50, 4, 0, 0);
    SetTab (NA, pjLeft, 35, 4, 0, 0);

    DeFFont(3,[]);

    If (VATCode1 In VATSet) then
    Begin
      DeFFont(3,[]);


      SendText(ConCat(#9,#9,'Fringe Benefits GST Rate :'));

      DeFFont(3,[fsBold]);

      SendLine(Concat(ConstStr(#9,3),'(',VATCode1+') '+SyssVAT.VATRates.VAT[GetVATNo(VATCode1,#0)].Desc));

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;


    If (VATCode2 In VATSet) then
    Begin
      DeFFont(3,[]);

      SendText(ConCat(#9,#9,'Imported Goods GST Rate :'));

      DeFFont(3,[fsBold]);

      SendLine(Concat(ConstStr(#9,3),'(',VATCode2+') '+SyssVAT.VATRates.VAT[GetVATNo(VATCode2,#0)].Desc));

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;

    DeFFont(3,[]);

    SendText(ConCat(#9,#9,'Registration number'));

    DeFFont(3,[fsBold]);

    SendLine(Concat(ConstStr(#9,3),Syss.UserVATReg));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;
    DeFFont(3,[]);

    SendText(ConCat(#9,#9,'For the period ending : '));

    DeFFont(3,[fsBold]);

    SendLine(Concat(ConstStr(#9,3),POutDate(VATEndD)));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    ClearTabs;

    SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
    SetTab (NA, pjLeft, 120, 4, 0, 0);
    SetTab (NA, pjRight, 10, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);


    DeFFont(2,[]);

    DefLine(-1,TabStart(1),TabEnd(4),0);

    SendLine(ConCat(#9,#9,'Total sales and income for the period (including GST)',#9,'[5]',
                    #9,FormatFloat(GenRealMask,GSTBox[5])));

    DeFFont(1,[fsItalic]);

    SendLine(ConCat(#9,#9,'(Calculated Total Sales based on actual Sales GST [8]. Not used in the calculations below)',#9,
                    #9,FormatFloat(GenRealMask,CalcBox1)));

    DeFFont(2,[]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Zero-rated supplies included in Box 5',#9,'[6]',
                    #9,FormatFloat(GenRealMask,GSTBox[6])));

    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Subtract Box 6 from Box 5',#9,'[7]',
                    #9,FormatFloat(GenRealMask,GSTBox[7])));

    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Sales GST as derived from the transactions for this period',#9,'[8]',
                    #9,FormatFloat(GenRealMask,GSTBox[8])));


    DeFFont(1,[fsItalic]);

    SendLine(ConCat(#9,#9,'(Divide Box 7 by '+Form_Int(DivRate,0),'. This figure is not used in the calculations below)',#9,
                    #9,FormatFloat(GenRealMask,CalcBox8)));

    DeFFont(2,[]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    SendLine(ConCat(#9,#9,'Adjustment for fringe benefits',#9,'[9]',
                    #9,FormatFloat(GenRealMask,GSTBox[9])));


    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Adjustments from your calculation sheet. (Out of Period Sales)',#9,'[10]',
                    #9,FormatFloat(GenRealMask,GSTBox[10])));

    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Add Boxes 8,9 and 10.  This is your total GST collected'));

    SendLine(ConCat(#9,#9,'on sales and income.',#9,'[11]',
                    #9,FormatFloat(GenRealMask,GSTBox[11])));

    DefLine(-1,TabStart(1),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    SendLine(ConCat(#9,#9,'Total purchases and expenses (including GST) for which'));

    SendLine(ConCat(#9,#9,'tax invoicing requirements have been met, excluding any'));

    SendLine(ConCat(#9,#9,'imported goods'#9,'[12]',
                    #9,FormatFloat(GenRealMask,GSTBox[12])));


    DeFFont(1,[fsItalic]);

    SendLine(ConCat(#9,#9,'(Calc. Total Purchases based on actual Purch. GST [13]. Not used in the calculations below)',#9,
                    #9,FormatFloat(GenRealMask,CalcBox12)));

    DeFFont(2,[]);

    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Purchase GST as derived from the transactions for this period',#9,'[13]',
                    #9,FormatFloat(GenRealMask,GSTBox[13])));

    DeFFont(1,[fsItalic]);

    SendLine(ConCat(#9,#9,'(Divide Box 12 by '+Form_Int(DivRate,0),'. This figure is not used in the calculations below)',#9,
                    #9,FormatFloat(GenRealMask,CalcBox13)));

    DeFFont(2,[]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Credit adjustments from your calculation sheet. (Out of Period Purchases)',#9,'[14]',
                    #9,FormatFloat(GenRealMask,GSTBox[14])));


    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,#9,'Add Box 13 and Box 14.  This is your total GST credit'));

    SendLine(ConCat(#9,#9,'for purchases and expenses.'#9,'[15]',
                    #9,FormatFloat(GenRealMask,GSTBox[15])));


    DefLine(-1,TabStart(2),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    If (GSTBox[16]<0) then
      GSTMsg:='GST Refund'
    else
      GSTMsg:='GST to pay';

    SendLine(ConCat(#9,#9,'Print the difference between Box 11 and Box 15 here. ',GSTMsg,#9,'[16]',
                    #9,FormatFloat(GenRealMask,GSTBox[16])));



    DefLine(-1,TabStart(1),TabEnd(4),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    ClearTabs;

    SetTab (MarginLeft, pjLeft, 250, 4, 0, 0);

    DeFFont(1,[fsItalic]);

    SendLine(ConCat(#9,'Disclaimer: The values and text shown on this report are to assist in completing a GST return.',
                       ' It is still the users responsibility to validate these values,'));

    SendLine(ConCat(#9,'and ensure the correct information is entered onto the GST 101 return.'));

  end; {With..}

end; {proc..}



{ =========== Procedure to Print Irish Version of VAT Return ========= }


Procedure TVATRReport.IE_Summary;


Var
  GSTBox     :  Array[1..7,1..2] of Real;
  GSTOPrBox  :  Array[1..2] of Real;

  n          :  VATType;

  m,l,PadSpc :  Byte;

  GSTMsg     :  Str20;

  IRTBoxAry  :  TIRTBoxAry;




Procedure AssignCodes;

Var
  n1,l  :  Byte;
  VC    :  Char;
  S     :  Str50;


Begin
  Blank(IRTBoxAry,Sizeof(IRTBoxAry));

  With CRepParam^.IRVATInp do
  Begin
    For n1:=Low(TCodes) to High(TCodes) do
    Begin
      S:=Strip('A',[#32,',','-','.','/','\','|','+'],TCodes[N1]);

      For L:=1 to Length(S) do
      Begin
        VC:=S[L];

        If VC In VATSet-VATEqStd-VATEECSet then
          With IRTBoxAry[1+Ord(n1>1),1+Ord(n1=High(TCodes))] do
          Begin
            IncSet:=IncSet+[GetVATNo(VC,#0)];

          end;
      end;
    end;

  end;

end;


Begin


  With CRepParam^,RepFiler1 do
  Begin
    AssignCodes;

    PadSpc:=25;

    Blank(GSTBox,Sizeof(GSTBox));
    Blank(GSTOPrBox,Sizeof(GSTOPrBox));

    GSTMsg:='';

    // Populate the IRTBox array with goods totals, based on the VAT Codes
    // entered in the T1, T2, and T3 boxes on the VAT Report input dialog.
    For n:=VStart to VEnd do
    Begin

      For m:=Low(IRTBoxAry) to High(IRTBoxAry) do
        For l:=1 to 2 do
          With IRTBoxAry[m,l] do
          Begin
            If (n In IncSet) then
            Begin
              BoxTotal:=BoxTotal+IPrTotals[m=1,2,n];
              GSTOPrBox[m]:=GSTOPrBox[m]+EPrTotals[m=1,2,n];
            end;

          end;


    end;

    // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services - include Purchase
    // VAT in boxes T1 and T2 for EC Services.

    // Note that VAT on EC Services only applies to Purchases, BUT it should
    // be applied to both sides -- the company is treated as both supplier
    // and customer for EC Services VAT.

    // VAT on supplies of goods and services
    GSTBox[1,1] := IRTBoxAry[1,1].BoxTotal;

    // VAT on purchases, intra-EU acquisitions, and imports
    GSTBox[1,2] := IRTBoxAry[2,1].BoxTotal;

    // VAT on intra-EU acquisitions
    GSTBox[2,1] := IRTBoxAry[1,2].BoxTotal + EECAqui[BOn,2];// + (RepECServiceTotals[ectPurchases][ecvVAT] * DocNotCnst);

    // VAT on other deductible goods and services
    GSTBox[2,2] := IRTBoxAry[2,2].BoxTotal + EECAqui[BOff,2];// + RepECServiceTotals[ectPurchases][ecvVAT];

    // In Period Total for T1
    GSTBox[3,1] := GSTBox[1,1] + GSTBox[2,1];

    // In Period Total for T2
    GSTBox[3,2] := GSTBox[1,2] + GSTBox[2,2];

    // Out of Period Total for T1
    GSTBox[4,1] := GSTOPrBox[1];

    // Out of Period Total for T2
    GSTBox[4,2] := GSTOPrBox[2];

    // Total T1 (VAT on goods & services & intra-EQ acquisitions
    GSTBox[5,1] := GSTBox[3,1] + GSTBox[4,1];

    // Total T2 (VAT on deductible purchases, intra-EU acquisitions and imports
    GSTBox[5,2] := GSTBox[3,2] + GSTBox[4,2];

    // Net Repayable (T4) and Net Payable (T3)
    If (GSTBox[5,1] + GSTBox[5,2] > 0) then
      GSTBox[6,2] := GSTBox[5,1] + GSTBox[5,2]
    else
      GSTBox[6,1] := ABS(GSTBox[5,2] + GSTBox[5,1]);

    GSTBox[7,1] := EECTotals[BOn,1];
    GSTBox[7,2] := EECTotals[BOff,1];

    ClearTabs;

    SetTab (MarginLeft, pjLeft, 70, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjCenter, 30, 4, 0, 0);
    SetTab (NA, pjLeft, 70, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);


    DeFFont(2,[fsUnderLine,fsBold]);

    SendLine(ConCat(#9,#9,'Box T1',ConstStr(#9,3),'Box T2'));

    DeFFont(2,[]);

    SendLine(ConCat(#9,'- VAT charged by you on supplies of goods',ConstStr(#9,3),
                       '- VAT on stocks for resale, (i.e. purchases,'));

    SendLine(ConCat(#9,'and supplies of services.',#9,FormatFloat(GenRealMask,GSTBox[1,1]),#9,#9,
                       'intra-EU acquisitions and imports).',#9,FormatFloat(GenRealMask,GSTBox[1,2])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    SendLine(ConCat(ConstStr(#9,4),'- VAT on other deductible goods and services,'));
    SendLine(ConCat(ConstStr(#9,4),'(i.e. purchases, intra-EU acquisitions and'));
    SendLine(ConCat(#9,'- VAT due on any intra-EU acquisitions.',#9,FormatFloat(GenRealMask,GSTBox[2,1]),#9,#9,
                       'imports).',#9,FormatFloat(GenRealMask,GSTBox[2,2])));


    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    DeFFont(2,[fsBold]);

    SendLine(ConCat(#9,'In Period Total for T1.',#9,FormatFloat(GenRealMask,GSTBox[3,1]),#9,#9,
                       'In Period Total for T2.',#9,FormatFloat(GenRealMask,GSTBox[3,2])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,'Out of Period VAT for T1.',#9,FormatFloat(GenRealMask,GSTBox[4,1]),#9,#9,
                       'Out of Period VAT for T2.',#9,FormatFloat(GenRealMask,GSTBox[4,2])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    DefLine(-1,TabStart(1),TabEnd(5),0);


    SendLine(ConCat(#9,'VAT on Goods & Services Supplied & Intra',ConstStr(#9,3),'VAT on deductible Purchases. Intra-EU'));
    SendLine(ConCat(#9,'EU acquisitions. (Total T1).',#9,FormatFloat(GenRealMask,GSTBox[5,1]),#9,#9,
                       'Acquisitions & Imports. (Total T2)',#9,FormatFloat(GenRealMask,GSTBox[5,2])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendText(ConCat(#9,'Net Repayable T4.',#9,FormatFloat(GenRealMask,GSTBox[6,1])));

    DeFFont(2,[fsUnderLine,fsBold]);

    SendText(ConCat(ConstStr(#9,3),'OR'));

    DeFFont(2,[fsBold]);

    SendLine(ConCat(ConstStr(#9,4),'Net Payable T3.',#9,FormatFloat(GenRealMask,GSTBox[6,2])));

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;


    SendLine(ConCat(#9,'Total Goods TO other EU Countries E1',#9,FormatFloat(GenRealMask,GSTBox[7,1]),#9,#9,
                       'Total Goods FROM EU Countries E2',#9,FormatFloat(GenRealMask,GSTBox[7,2])));


    // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services - include Purchase
    // VAT in boxes T1 and T2 for EC Services.
    SendLine(ConCat(#9, 'Total Services TO other EU Countries ES1', #9,
                        FormatFloat(GenRealMask, CRepParam.RepECServiceTotals[ectSales][ecvNet]), #9, #9,
                        'Total Services FROM EU Countries ES2', #9,
                        FormatFloat(GenRealMask, CRepParam.RepECServiceTotals[ectPurchases][ecvNet])));


  end; {With..}

end; {proc..}



Procedure TVATRReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      0,2  :  Case DDMode of
                0  :  Begin
                        SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
                        SendRepDrillDown(6,6,2,LInv.CustCode,CustF,CustCodeK,0);
                      end;

              end; {Case..}

    end; {Case..}
  end; {With..}
end;


{ ======================= VAT Summary Page ==================== }


Procedure TVATRReport.VAT_Summary;
// CJS 2015-05-28 - ABSEXCH-16260 - VAT100 report Box 8
const
  VAT_INPUT = False;
  VAT_OUTPUT = True;
  GOODS_ELEMENT = 1;
  VAT_ELEMENT = 2;
Var
  VATRate : VATType;
  b,
  DDPNo,
  m,PadSpc   :  Byte;

  LYr,LPr    :  Word;

  Months, Loop :  Integer;
  VATDirection:  Boolean;
  VATBal,TmpR,
  VATDue,Rnum,
  Y1
             :  Double;

  GoodsValue : Double;
  VATValue   : Double;

  IOTot,
  IONet      :  IONetTyp;

  // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
  XMLVAT100Data  : array of double;
  outputFile     : string;

  Value: Double;

  Procedure LinkToVATGL;
  Begin
    With RepFiler1 do
    Begin
      Case DDPNo of
        0  :  Begin
                SendRepDrillDown(1,4,1,FullNomKey(Syss.NomCtrlCodes[InVAT]),NomF,NomCodeK,0);
                SendRepDrillDown(5,TotTabs,1,FullNomKey(Syss.NomCtrlCodes[OutVAT]),NomF,NomCodeK,0);
              end;

        1  :  Begin
                SendRepDrillDown(1,5,1,FullNomKey(Syss.NomCtrlCodes[InVAT]),NomF,NomCodeK,0);
                SendRepDrillDown(6,TotTabs,1,FullNomKey(Syss.NomCtrlCodes[OutVAT]),NomF,NomCodeK,0);
              end;

        else  SendRepDrillDown(1,TotTabs,1,FullNomKey(Syss.NomCtrlCodes[InVAT]),NomF,NomCodeK,0);
      end; // Case DDPNo of...
    end;
  end;

Begin

  Blank(IOTot,Sizeof(IOTot));
  Blank(IONet,Sizeof(IONet));

  VATBal:=0;  TmpR:=0;

  LPr:=0; LYr:=0; DDPNo:=0;

  PadSpc:=20;

  FillChar(NZMiscTotals,Sizeof(NZMiscTotals),0);

  With RepFiler1,CRepParam^ do
  Begin
    Y1 := YD2U(CursorYPos);

    DefFont(2, []);

    ClearTabs;

    SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
    SetTab (NA, pjLeft, 24, 4, 0, 0);
    SetTab (NA, pjLeft, 10, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight,29, 4, 0, 0);
    SetTab (NA, pjRight,29, 4, 0, 0);

    SetTabCount;

    For m := 1 to 6 do
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;

    SendLine(ConCat(ConstStr(#9,4),'<--Input',' ',CCVATName^,' ',#9,'(Purchases)-->',#9,
                                '<----Output',' ',CCVATName^,#9,'(Sales)---->'));

    SendLine(ConCat(ConstStr(#9,2),CCVATName^,' ','Rate',#9,#9,'Goods',#9,CCVATName^,#9,'Goods',#9,CCVATName^));

    For b := 2 to 7 do
      DefLine(-1, TabStart(b), TabEnd(b), 0);

    // Process all the VAT Rates, retrieving and totalling the Input and Output
    // VAT and Goods values from History for each rate, across the period/year
    // range covered by the selected VAT period
    For VATRate := VStart to VEnd do
    With SyssVAT.VATRates.VAT[VATRate] do
    Begin
      For VATDirection := VAT_INPUT to VAT_OUTPUT do
      Begin
        Case ReportMode of
          0, 1: Begin
                  VATBal := 0.0;
                  IONet[VATDirection, GOODS_ELEMENT] := 0.0;
                  IONet[VATDirection, VAT_ELEMENT]   := 0.0;

                  // Determine the number of months covered by the selected
                  // VAT Period
                  Months := MonthDiff(VATStartD, VATEndD);

                  // Get the start year and start period for the selected VAT
                  // Period
                  LYr := VISYr;
                  LPr := VISPr;

                  For Loop := 0 to Months do
                  Begin
                    // Retrieve the Input/Output Goods and VAT values for the
                    // VAT Code for the year and period
                    VATBal := MTExLocal^.LProfit_to_Date(IOVATCh[VATDirection],
                                                         FullCustCode(Code),
                                                         0, LYr, LPr, VATValue,
                                                         GoodsValue, TmpR, BOff);

                    // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                    // Allow the Goods and VAT totals to be adjusted to
                    // account for values that are not picked up by the
                    // LProfit_to_Date function.
                    AdditionalSummaryTotals(VATDirection, Code, GoodsValue, VATValue);

                    IONet[VATDirection, VAT_ELEMENT] := IONet[VATDirection, VAT_ELEMENT] + VATValue;   // Input/Output VAT
                    IONet[VATDirection, GOODS_ELEMENT] := IONet[VATDirection, GOODS_ELEMENT] + GoodsValue; // Input/Output Goods

                    // CJS 2015-06-23 - ABSEXCH-16260 - VAT100 report Box 8
                    if (VATRate = Rate4) and (VATDirection = VAT_OUTPUT) then
                      IONet[VATDirection, GOODS_ELEMENT] := IONet[VATDirection, GOODS_ELEMENT] + FreeOfChargeTotals;

                    // Advance to the next period/month
                    AdjMnth(LPr, LYr, 1);

                    // New Zealand VAT Return only
                    If (CurrentCountry = NZCCode) and (ReportMode In [0, 1]) then {Calcualate misc totals here}
                    With NZMiscTotals do
                    Begin
                      If (Code = VATCode1) and (VATCode1 in VATSet) then {Calculate element of fringe benefits}
                      Begin
                        If (Include) then
                          NZFringeB[VATDirection, GOODS_ELEMENT] := NZFringeB[VATDirection, GOODS_ELEMENT] + GoodsValue;

                        NZFringeB[VATDirection, VAT_ELEMENT] := NZFringeB[VATDirection, VAT_ELEMENT] + VATValue;
                      end;

                      If (Code=VATCode2) and (VATCode1 In VATSet) then {Calculate element of Imports}
                      Begin
                        If (Include) then
                          NZImport[VATDirection, GOODS_ELEMENT] := NZImport[VATDirection, GOODS_ELEMENT] + GoodsValue;

                        NZImport[VATDirection, VAT_ELEMENT] := NZImport[VATDirection, VAT_ELEMENT] + VATValue;
                      end;

                      If ((Code<>VATCode2) and (VATValue=0.0)) then {Calculate element of Zero Rate}
                      Begin
                        If (Include) then
                          NZZero[VATDirection, GOODS_ELEMENT] := NZZero[VATDirection, GOODS_ELEMENT] + GoodsValue;

                        NZZero[VATDirection, VAT_ELEMENT] := NZZero[VATDirection, VAT_ELEMENT] + VATValue;
                      end;
                    end; // If (CurrentCountry=NZCCode)...
                  end; // For Loop := 0 to Months do...
                end;

          2:    Begin
                  IONet[VATDirection, GOODS_ELEMENT] := IPrTotals[VATDirection, GOODS_ELEMENT, VATRate];
                  IONet[VATDirection, VAT_ELEMENT] := IPrTotals[VATDirection, VAT_ELEMENT, VATRate];
                end;

        end; // Case ReportMode of...

        // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
        if (VATDirection = VAT_INPUT) and (VATRate = Rate3) then
          IONet[VATDirection, GOODS_ELEMENT] := IONet[VATDirection, GOODS_ELEMENT] + MTExLocal.ExcludedNoTCValues[vatInput]
        else if (VATDirection = VAT_OUTPUT) and (VATRate = Rate4) then
          IONet[VATDirection, GOODS_ELEMENT] := IONet[VATDirection, GOODS_ELEMENT] - MTExLocal.ExcludedNoTCValues[vatOutput];

        // If this VAT Rate is flagged for including gross figures...
        If (Include) then
        begin
          // ...total the Goods values, as read from the Input/Output VAT
          // History via Profit-to-Date
          OprTotals[VATDirection, GOODS_ELEMENT] := OPrTotals[VATDirection, GOODS_ELEMENT] + IONet[VATDirection, GOODS_ELEMENT];
        end;

        // Accumulate the Input/Output total of Goods and VAT for this VAT Rate
        For m := GOODS_ELEMENT to VAT_ELEMENT do
        Begin
          IOTot[VATDirection, m] := IOTot[VATDirection, m] + IONet[VATDirection, m];
        end;

      end; // For VATDirection := VAT_INPUT to VAT_OUTPUT do...

      LinkToVATGL;

      SendLine(ConCat(ConstStr(#9,2),Desc,
                      #9,YNBo(Include),
                      #9,FormatBFloat(GenRealMask,IONet[VAT_INPUT,  GOODS_ELEMENT],BOn),  // Input Goods
                      #9,FormatBFloat(GenRealMask,IONet[VAT_INPUT,  VAT_ELEMENT],BOn),    // Input VAT
                      #9,FormatBFloat(GenRealMask,IONet[VAT_OUTPUT, GOODS_ELEMENT],BOn),  // Output Goods
                      #9,FormatBFloat(GenRealMask,IONet[VAT_OUTPUT, VAT_ELEMENT],BOn)));  // Output VAT

    end; // For VATRate := VStart to VEnd do...

    For b := 4 to 7 do
      DefLine(-2, TabStart(b), TabEnd(b), 0);

    LinkToVATGL;

    // Grand totals
    SendLine(ConCat(ConstStr(#9,2),'Totals',' ','...:',#9,
                    #9,FormatFloat(GenRealMask,IOTot[VAT_INPUT,  GOODS_ELEMENT]),
                    #9,FormatFloat(GenRealMask,IOTot[VAT_INPUT,  VAT_ELEMENT]),
                    #9,FormatFloat(GenRealMask,IOTot[VAT_OUTPUT, GOODS_ELEMENT]),
                    #9,FormatFloat(GenRealMask,IOTot[VAT_OUTPUT, VAT_ELEMENT])));

    m := ReportMode;
    ReportMode := 7;

    If (CurrentCountry=SingCCode) then
      PageTitle:=PageTitle+' - GST Form F5.'
    else
      If (CurrentCountry=NZCCode) then
        PageTitle:=PageTitle+' - GST form 101.';

    // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
    PrintNoTCNote;

    {LinkToVATGL;}

    ThrowNewPage(-1);

    Inc(DDPNo);

    ReportMode:=m;

    DefFont(2,[]);

    If (CurrentCountry <> NZCCode) then
      For m := 1 to 6 do
        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        Self.CRLF;

    If (CurrentCountry = SingCCode) then
      GST_Summary
    else
      If (CurrentCountry = IECCode) then
        IE_Summary
      else
      If (CurrentCountry = NZCCode) then
        NZGST_Summary(IOTot, IONet)
      else
        Begin
          Rnum := IOTot[VAT_OUTPUT, VAT_ELEMENT] - OPrTotals[VAT_OUTPUT, VAT_ELEMENT];  // Output VAT
          TmpR := IOTot[VAT_INPUT,  VAT_ELEMENT] - OPrTotals[VAT_INPUT,  VAT_ELEMENT];  // Input VAT

          LinkToVATGL;

          SendLine(ConCat(ConstStr(#9,4),'Input',' ',CCVATName^,' ','Due',' ','.:',#9,FormatFloat(GenRealMask,TmpR),
                          #9,'Output',' ',CCVATName^,' ','Due',' ','.:',#9,FormatFloat(GenRealMask,RNum)));

          LinkToVATGL;

          SendLine(ConCat(ConstStr(#9,4),'Over',' ','Declared',' ','.:',#9,FormatFloat(GenRealMask,OprTotals[VAT_INPUT, VAT_ELEMENT]),
                             #9,'Under',' ','Declared',' ','.:',#9,FormatFloat(GenRealMask,OprTotals[VAT_OUTPUT, VAT_ELEMENT])));

          DefLine(-2,TabStart(5),TabEnd(5),0);
          DefLine(-2,TabStart(7),TabEnd(7),0);

          LinkToVATGL;

          SendLine(ConCat(ConstStr(#9,4),'Total',' ','Input',' ',CCVATName^,':',#9,FormatFloat(GenRealMask,IOTot[VAT_INPUT, VAT_ELEMENT]),
                          #9,'Total',' ','Output',' ',CCVATName^,':',#9,FormatFloat(GenRealMask,IOTot[VAT_OUTPUT, VAT_ELEMENT])));

          VATBal:=0;

          TmpR := IOTot[VAT_OUTPUT, VAT_ELEMENT] - NoClaimOVAT;
          Rnum := EECAqui[VAT_OUTPUT, VAT_ELEMENT] + NoClaimOVAT;

          For m := 1 to 2 do
            // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
            Self.CRLF;

          Inc(DDPNo);

          ClearTabs;

          SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
          SetTab (NA, pjLeft, 100, 4, 0, 0);
          SetTab (NA, pjCenter, 10, 4, 0, 0);
          SetTab (NA, pjRight, 29, 4, 0, 0);

          SetTabCount;

          LinkToVATGL;

          SendLine(ConCat(#9,#9,CCVATName^,' due in this period on Sales and other outputs',#9,'[1]',
                         #9,FormatFloat(GenRealMask,TmpR)));

          SetLength(XMLVAT100Data, 9);
          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[0] := TmpR;

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          LinkToVATGL;

          SendLine(ConCat(#9,#9,CCVATName^,' due in this period on Acquisitions from other EC Member States',#9,'[2]',
                         #9,FormatFloat(GenRealMask,Rnum)));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[1] := Rnum;

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          VATDue := Rnum + TmpR;

          LinkToVATGL;

          SendLine(ConCat(#9,#9,'Total ',CCVATName^,' due (the sum of boxes 1 and 2)',#9,'[3]',
                         #9,FormatFloat(GenRealMask,VATDue)));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[2] := VATDue;

          Rnum := IOTot[VAT_INPUT, VAT_ELEMENT] + EECAqui[VAT_INPUT, VAT_ELEMENT];

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          LinkToVATGL;

          SendLine(ConCat(#9,#9,CCVATName^,' reclaimed in this period on Purchases and other inputs',#9,'[4]',
                         #9,FormatFloat(GenRealMask,Rnum)));
          SendLine(ConCat(#9,#9,'(including acquisitions from the EC)'));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[3] := Rnum;

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          VATBal := VATDue + Rnum;

          DefLine(-1, TabStart(2), TabEnd(4), 0);

          LinkToVATGL;

          SendLine(ConCat(#9,#9,'NET ',CCVATName^,
                               ' to be paid to Customs or reclaimed by you',#9,'[5]',
                         #9,FormatFloat(GenRealMask,VATBal)));
          SendLine(ConCat(#9,#9,'(Difference between boxes 3 and 4)'));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[4] := VATBal;

          DefLine(-1,TabStart(2),TabEnd(4),0);

          For m:=1 to 2 do
            // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
            Self.CRLF;

          {SendLine(ConCat(#9,#9,'Total value of Sales and all other outputs excluding',#9,'[6]',
                         #9,FormatFloat(GenRealMask,IOTot[BOn,1])));}

          LinkToVATGL;

          {* v4.31 Altered so goods flag taken into account *}
          SendLine(ConCat(#9,#9,'Total value of Sales and all other outputs excluding',#9,'[6]',
                         #9,FormatFloat(GenRealMask,OprTotals[VAT_OUTPUT, GOODS_ELEMENT])));
          SendLine(ConCat(#9,#9,'any ',CCVATName^,'. Including box 8 figure'));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML input.
          XMLVAT100Data[5] := OprTotals[VAT_OUTPUT, GOODS_ELEMENT];

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          {SendLine(ConCat(#9,#9,'Total value of Purchases and all other inputs excluding',#9,'[7]',
                         #9,FormatFloat(GenRealMask,IOTot[BOff,1])));}

          {* v4.31 Altered so goods flag taken into account *}

          LinkToVATGL;

          SendLine(ConCat(#9,#9,'Total value of Purchases and all other inputs excluding',#9,'[7]',
                         #9,FormatFloat(GenRealMask,OprTotals[VAT_INPUT, GOODS_ELEMENT])));
          SendLine(ConCat(#9,#9,'any ',CCVATName^,'. Including box 9 figure'));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[6] := OprTotals[VAT_INPUT, GOODS_ELEMENT];

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          LinkToVATGL;

          SendLine(ConCat(#9,#9,'Total value of all supplies of goods and related services,',#9,'[8]',
                         #9,FormatFloat(GenRealMask,EECTotals[VAT_OUTPUT, GOODS_ELEMENT])));
          SendLine(ConCat(#9,#9,'excluding any ',CCVATName^,', to other EC Member States'));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML output.
          XMLVAT100Data[7] := EECTotals[VAT_OUTPUT, GOODS_ELEMENT];

          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.CRLF;

          LinkToVATGL;

          SendLine(ConCat(#9,#9,'Total value of all acquisitions of goods and related services,',#9,'[9]',
                         #9,FormatFloat(GenRealMask,EECTotals[VAT_INPUT, GOODS_ELEMENT])));
          SendLine(ConCat(#9,#9,'excluding any ',CCVATname^,', from other EC Member States'));

          // ABSEXCH-13793. 11/06/2013. Include VAT100 XML input.
          XMLVAT100Data[8] := EECTotals[VAT_INPUT, GOODS_ELEMENT];

          // CJS 2014-11: Order Payments - Phase 5 - VAT Return
          AfterSummary;

          DefFont(0,[]);

        end;

    // ABSEXCH-13793. PKR. Include VAT100 XML output.
    // If we want an XML report (VAT100) for online submission, then generate one
    //PR: 10/06/2013 Add ifndef sopdll so entdllsp compiles.
    {$IFNDEF SOPDLL}
    if CRepParam.WantXMLOutput then
    begin
      CRepParam.XMLOutputFile := produceXMLVATReport(XMLVat100Data);

      // The submission form will be displayed during the Finish method.
    end;
    {$ENDIF}
    {LinkToVATGL;}

  end; {With..}

end; {Proc..}

{ ======================= VAT End ======================= }

//------------------------------------------------------------------------------
{$IFNDEF SOPDLL}
// ABSEXCH-13793. Include VAT100 XML output.

function TVATRReport.produceXMLVATReport(aXMLVat100Data : array of double) : string;
var
  XMLVATFilename : string;
  outputFile     : string;
  VATRepDate     : LongDate;

  // The VAT XML report object
  XMLVATReturn   : TXMLVATReturn;
  VATReportParams : VATRepPtr;
begin
  VATRepDate := CRepParam.VATEndD;

  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390 Refactored to avoid warnings + ensure that XMLVatReturn is freed

  // Create the XML VAT Return object
  XMLVATReturn := TXMLVATReturn.Create(aXMLVat100Data);
  Try

    // Output the report to the specified location.
    XMLVATFilename := XMLVATReturn.BuildVATXMLFilename(VATRepDate);

    // CJS 2015-08-19 - ABSEXCH-16771 - COM registration error on workstation setup
    // Defaulted the output path

    outputFile := CRepParam.XMLOutputPath;

    // If no path was supplied, fall back to using the company path
    if (outputFile = '') then
      outputFile := SetDrive;

  {$WARN SYMBOL_PLATFORM OFF}
    outputFile := IncludeTrailingPathDelimiter(outputFile) + XMLVATFilename;
  {$WARN SYMBOL_PLATFORM ON}

    XMLVATReturn.VATReportParams := CRepParam;

    XMLVATReturn.WriteXMLToFile(outputFile);

    Result := outputFile;
  Finally
    XMLVATReturn.Free;
  End;
end;
{$ENDIF}
//------------------------------------------------------------------------------


Procedure TVATRReport.PrintEndPage;

Var
  TmpRepMode  :  Integer;

Begin
  With RepFiler1,CRepParam^ do
  Begin

    If (Not IsVR2) then
    Begin
      If (ReportMode In [0,2]) then
      Begin
        ReportMode:=ReportMode+20; {* Print Split for Sales.. *}

        DefLine(-1,1,PageWidth-MarginRight-1,-0.5);

        PrintVATTot(BOff);

        PrintVATTot(BOn);

        ReportMode:=ReportMode-20;

        DefLine(-1,1,PageWidth-MarginRight-1,-0.5);

        PrintVATTot(BOff);

        PrintVATTot(BOn);

        Inherited PrintEndPage;

        RNoPageLine:=BOn;

        ICount:=1;

        TmpRepMode:=ReportMode;

        ReportMode:=7;

        ThrowNewPage(-1);

        ReportMode:=TmpRepMode;
      end;

      VAT_Summary;
    end;

    Inherited PrintEndPage;

  end; {With..}
end;


{ ======================= VAT Include ======================= }


Function TVATRReport.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;

  // CJS 2014-11-05 - T067 - UK VAT Return -  VAT Calculation Extension for Order Payment SRC's
  function IncludeTransaction: Boolean;
  var
    IsInRange: Boolean;
    IsPosted: Boolean;
    IsReceipt: Boolean;
    IsOPReceipt: Boolean;
  begin
    IsInRange   := (MTExLocal.LInv.VATPostDate <= CRepParam^.VATEndd) and
                   (MTExLocal.LInv.VATPostDate >= CRepParam^.VATStartd);
    IsPosted    := (MTExLocal.LInv.RunNo > 0) or (ReportMode = 2);
    IsReceipt   := (MTExLocal.LInv.InvDocHed in RecieptSet);
    IsOPReceipt := (MTExLocal.LInv.thOrderPaymentElement <> opeNA);

    Result  := (IsInRange and IsPosted and (not IsReceipt or IsOPReceipt));
  end;

Begin

  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      0,2
           :  With LInv do
              Begin

                // CJS 2014-11-05 - T067 - UK VAT Return -  VAT Calculation Extension for Order Payment SRC's
                TmpInclude := IncludeTransaction;
                If (TmpInclude) and (ReportMode=2) then {* Exclude any docs which have just been
                                                     Unallocated then re-allocated again *}
                Begin

                  Set_VATTotals(LInv,BOff);

                  TmpInclude:=((GoodsTot<>0) or (VATTot<>0));


                end;


                If (VATPostDate>VATEndd) then

                Begin
                  KeyS:=NdxWeight;

                  B_Next:=B_GetGEq;
                end;
              end;
           else  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390
             raise Exception.Create('Invalid ReportMode in TVATRReport.IncludeRecord: ' + IntToStr(ReportMode));

    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}







Function TVATRReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;


  VSYr,VSPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n  :  Integer;

  FoundCode
     :  Str20;



Begin
  With CRepParam^ do
  Begin


    VATScheme:=SyssVat.VATRates.VATScheme;


    If (VAT_CashAcc(VATScheme)) then
      ReportMode:=2;


    ThTitle:=CCVATName^+' Returns';


    If (CurrentCountry<>IECCode) then
      RepTitle:=GetIntMsg(2)+' for '+Form_Int(VPr,2)+'/'+FullYear(VYr)
    else
      RepTitle:=GetIntMsg(2)+' for '+Form_Int(VISPr,2)+'/'+FullYear(VISYr)+' - '+
                           Form_Int(VPr,2)+'/'+FullYear(VYr);


    PageTitle:=RepTitle;

    RFont.Size:=7;
    ROrient:=RPDefine.PoLandscape;

    RFnum:=InvF;

    RKeyPath:=InvVATK;

    RepKey:=VATEndd;


  end; {With..}

  Result:=BOn;
end;


Function TVATRReport.Start  :  Boolean;

Var
  IRepParam  :  CVATRepPtr;

Begin
  Result:=Inherited Start;

  If (Result) and (ReportMode=2) then {* Start Cash accounting reconcillication report first *}
  Begin
    New(IRepParam);

    FillChar(IRepParam^,Sizeof(IRepParam^),0);


    With CRepParam^ do
    Begin
      IRepParam^.VATEndD:=VATEndD;
      IRepParam^.VATStartD:=VATStartD;
      IRepParam^.VPr:=VPr;
      IRepParam^.VYr:=VYr;
      IRepParam^.VSPr:=VISPr;
      IRepParam^.VSYr:=VISYr;

      AquiCode:=#32;
    end;

    With IRepParam^.PParam do
    Begin
      PDevRec:=RDevRec;
    end;

    AddCVATRep2Thread(2,IRepParam,fmyOwner);

    Dispose(IRepParam);
  end;
end;


Procedure TVATRReport.Finish;


Begin
  If (Assigned(ThreadRec) and ChkRepAbort) then
  With MTExLocal^ do
  Begin
    If (Not ThreadRec^.THAbort) and (CRepParam.AutoCloseVAT) and (Assigned(LThPrintJob)) then {* Call back to Synchronise method *}
    Begin
      ThreadRec^.THAbort:=BOn; {* Force abort, as control now handed over to close VAT *}
      LThPrintJob(nil,0,8);
    end;
  end;

  // ABSEXCH-14371. 25/07/2013. PKR.
  // Allow the user to submit the VAT return to HMRC
  {$IFNDEF SOPDLL}
  if CRepParam.WantXMLOutput then
  begin
    { CJS 2013-08-09 - ABSEXCH-14525 - VAT100 form opens unnecessarily }
    // Ask the main window to create the VAT Submission Form (we can't create
    // it ourselves as we are still inside a thread).
    SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 253, 0);
    
    // Now submit the return to HMRC.
    // Show the VAT Return Submission Form
    VatSubForm.SetXMLFile(CRepParam.XMLOutputFile);
    VatSubForm.WindowState := wsNormal;
    // ABSEXCH-14509. PKR. 02/08/2013.  Removed Form Show.
  end;
  {$ENDIF}
  
  Inherited Finish;
end;


{ ======== }




Procedure AddVATRRep2Thread(LMode    :  Byte;
                            IRepParam:  VATRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TVATRReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;

        end;

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

// CJS 2014-11: Order Payments - Phase 5 - VAT Return
procedure TVATRReport.AdditionalSummaryTotals(ForSales: Boolean;
  VATCode: char; var Goods, VAT: Double);
begin
  { Default does nothing }
end;

// CJS 2014-11: Order Payments - Phase 5 - VAT Return
procedure TVATRReport.AfterSummary;
begin
  { Default does nothing }
end;

// CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
procedure TVATRReport.PrintNoTCNote;
begin
  if Syss.Intrastat then
  begin
    if (RepFiler1.LinesLeft < 3) then
      ThrowNewPage(3);

    DefFont(-1, []);
    Self.PrintLeft('Note: In accordance with HMRC Notice 60, transactions lines that use NoTC (Nature of Transaction Codes) 17, 20, 40 and 50 are excluded from this VAT report, but are included on the Intrastat Supplementary Declaration report.', RepFiler1.MarginLeft);
    Self.CRLF;
  end;
end;


Initialization



Finalization

end.