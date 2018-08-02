unit Report3U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  oSystemSetup,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExtGetU, ExBtTh1U,ReportU;


Const
  DocAnalRepTits  :  Array[0..7] of Str80  =  ('Document Analysis Report',
                                               'Sales Daybook Report',
                                               'Purchase Daybook Report',
                                               'Sales Receipts - Daybook Report',
                                               'Purchase Payments - Daybook Report',
                                               'Sales Order Daybook Report',
                                               'Purchase Order Daybook Report',
                                               'Nominal Transfer  - Daybook Report'
                                              );

type


  TDocReport  =  Object(TGenReport)
                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private

                       // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag.
                       fHasIntrastatOOP : Boolean; /// True if any row has its Intrastat Out-of-Period flag set.

                       DDMList:  TDDMList;

                       Procedure PrintDocLine(Const DocHed :  DocTypes;
                                              Const Cont   :  Boolean);

                       Procedure PrintDocTypeLine(Const DocHed :  DocTypes;
                                                  Const Cont   :  Boolean);

                       Procedure PrintDocHedLine(RCr,RTxCr    :  Byte;
                                                 Cont         :  Boolean);


                       Procedure PrintOCBal(NomType  :  Char;
                                            NomCode  :  Str10;
                                            Rcr,RTxCr,
                                            NYr,NPr,
                                            Mode,
                                            CommitMode
                                                     :  Byte;
                                            CloseBal :  Boolean);

                       Procedure PrintReconHed;

                       Function GetReportInput  :  Boolean; Virtual;

                     public
                       PrevPrintedInvDocHed :  DocTypes;    { Document Type that printed previously}

                       PMode  :  SmallInt;
                       StkRepMode :  Boolean;

                       CRepParam  :  DocRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function SummInclude  :  Boolean;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintDueTot(Gtot      :  Boolean);

                       Procedure CalcDueTotals(CrDr      :  DrCrDType;
                                               TTot,
                                               PTot      :  Totals);


                       Procedure CalcCTH(Var TTot  :  Totals;
                                             RCr,
                                             RTxCr :  Byte);

                       Procedure CustTHH(Var TTot     :  Totals;
                                         Var FoundOk  :  Boolean);

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddDocRep2Thread(LMode    :  Byte;
                           IMode    :  Byte;
                           IRepParam:  DocRepPtr;
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
  {DocSupU1,}
  RpDefine,
  InvListU,
  SalTxl1U,


  {$IFDEF DXXXBXXXD}
    DebugU,

  {$ENDIF}

  {$IFDEF REPPFC}
    SQLUtils,
    SQLFields,
  {$ENDIF}

  // MH 30/10/2013 v7.X MRD1.1: Added customer/Consumer support to Customer Trading History Report (8) and Summary Report (11)
  ConsumerUtils,

  RepCCShU,


  ExThrd2U;



  { ======================= Payments / Receipts Due Report ======================= }

Const

  DocAnalFilt     :  Array[0..7] of Char   =  (#0,'S','P','S','P','S','P','N');

  SDayRepSet     =  [SIN,SCR,SJI,SJC,SRF,SRI];           {* ----------- Documents Included in Sales Daybook Report ------- *}
  PDayRepSet     =  [PIN,PCR,PJI,PJC,PRF,PPI];           {* ----------- Documents Included in Purchase Daybook Report -----*}
  YDayRepSet     =  [PPY,PRF,PPI];                       {* ----------- Documents Included in Payments Daybook Report -----*}
  RDayRepSet     =  [SRC,SRF,SRI];                       {* ----------- Documents Included in Reciepts Daybook Report -----*}
  SODayRepSet    =  [SOR,SDN];                           {* ----------- Documents Included in Sales Order Daybook Report --*}
  PODayRepSet    =  [POR,PDN];                           {* ----------- Documents Included in Purchase Order Daybook Report*}
  NTDayRepSet    =  [NMT];                               {* ----------- Documents Included in Nominal Transfer Daybook Report*}





{ ========== TDocReport methods =========== }

Constructor TDocReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  DDMList:=nil;

  StkRepMode:=BOff;

end;


Destructor TDocReport.Destroy;

Begin
  If (Assigned(DDMList)) then
    DDMList.Free;

  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TDocReport.Process;


Begin
  {* Note this is called by ReportCU *}


  Inherited Process;

end;



Procedure TDocReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;
    Case ReportMode of

        0,5,10,20,30,40,50,60,70
         :  Begin
              // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag
              SetTab (MarginLeft, pjLeft, 6, 4, 0, 0);
              SetTab (NA, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 45, 4, 0, 0);
              SetTab (NA, pjLeft, 50{22}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);

            end;

        1:  Begin
              SetTab (MarginLeft, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 25, 4, 0, 0);
              SetTab (NA, pjLeft, 35, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        2:  Begin
              SetTab (MarginLeft, pjLeft, 21, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 42{32}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 85, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        3:  Begin
              SetTab (MarginLeft, pjRight, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 32{22}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 15{17}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 15{17}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 12{15}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 40{45}, 4, 0, 0);  // MHYR
              SetTab (NA, pjRight, 27{29}, 4, 0, 0);  // MHYR
              SetTab (NA, pjRight, 27{29}, 4, 0, 0);  // MHYR
              SetTab (NA, pjRight, 27{29}, 4, 0, 0);  // MHYR
              SetTab (NA, pjRight, 27{29}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft,  10{23}, 4, 0, 0);  // MHYR - was previously off side of page!

            end;

        7:  Begin
              SetTab (MarginLeft, pjRight, 10, 4, 0, 0);
              SetTab (NA, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 15{20}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 45, 4, 0, 0);
              SetTab (NA, pjLeft, 42{22}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 14{15}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
            end;
        8,9
         :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 28, 4, 0, 0);//TW 09/08/2011: Adjusted column
              SetTab (NA, pjLeft, 17, 4, 0, 0);//sizes for MMMYYYY display
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight, 23, 4, 0, 0);
              SetTab (NA, pjRight, 27, 4, 0, 0);
              SetTab (NA, pjRight, 27, 4, 0, 0);
              SetTab (NA, pjRight, 27, 4, 0, 0);
              SetTab (NA, pjRight, 27, 4, 0, 0);
              SetTab (NA, pjRight, 27, 4, 0, 0);
              SetTab (NA, pjRight, 19, 4, 0, 0);
            end;
        11,12
         :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 45, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjRight,19, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;



{ ====================== Get Full Doc Type Print ====================== }

  Procedure TDocReport.PrintDocLine(Const DocHed :  DocTypes;
                                    Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      DefFont(0,[fsBold]);

      If (Cont) then
        ContStr:=' (continued...)'
      else
      begin
        ContStr:='';
        PrevPrintedInvDocHed := DocHed;
      end;

      {ABSEXCH-16890: Purchase Daybook report showing Sales Credit Note heading
                    when totals moved to next page  }
      if Cont then
        Self.PrintLeft(ConCat(DocNames[PrevPrintedInvDocHed]+ContStr),MarginLeft)
      else
        Self.PrintLeft(ConCat(DocNames[DocHed]+ContStr),MarginLeft);
	  Self.CRLF;

      DefLine(-1,1,100,-0.3);

    end; {With..}
  end;


  { ====================== Get Full Doc Type Print ====================== }

  Procedure TDocReport.PrintDocTypeLine(Const DocHed :  DocTypes;
                                        Const Cont   :  Boolean);

  Var
    ContStr     :  Str255;
    DocTypeHed  :  Str20;


  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      DefFont(0,[fsBold]);

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

      DocTypeHed:='';


      If (DocHed In SalesSplit) then
        DocTypeHed:='Sales'
      else
        If (DocHed In PurchSplit) then
          DocTypeHed:='Purchase'
        else
          DocTypeHed:='Nominal';

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(ConCat(DocTypeHed,' Transactions '+ContStr),MarginLeft);
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

    end; {With..}
  end;

{ ====================== Print Full Doc Hed & Print ====================== }


procedure TDocReport.PrintDocHedLine(RCr,RTxCr    :  Byte;
                                     Cont         :  Boolean);


Var
  Total  :  Totals;
  UOR,
  n      :  Byte;
  ContStr:  Str255;



Begin
  With MTExLocal^,RepFiler1,LInv do
  Begin

    UOR:=0;

    Blank(Total,Sizeof(Total));

    If (Not (InvDocHed In QuotesSet)) then
    Begin
      Total[1]:=InvNetVal;
      Total[2]:=DiscAmount+(DiscSetAm*Ord(DiscTaken));
      Total[3]:=InvVAT;
      Total[4]:=ITotal(LInv);

      For n:= 1 to NoTotals do
        If (RCr=0) then
        Begin
          If (n<>3) then {* Convert @ Original Rate *}
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,OrigRates,UseORate,Currency,0);

            Total[n]:=Round_Up(Conv_TCurr(Total[n],XRate(OrigRates,UseCoDayRate,Currency),Currency,UOR,BOff),2)*DocCnst[InvDocHed]*DocNotCnst
          end
          else
          Begin
            Total[n]:=Round_Up(Conv_TCurr(Total[n],CXRate[BOn],Currency,UseORate,BOff),2)*DocCnst[InvDocHed]*DocNotCnst;
          end;
        end
        else
          Total[n]:=Total[n]*DocCnst[InvDocHed]*DocNotCnst;

      If (RCr=0) then
        Total[4]:=ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst;
    end;

    For n:= 1 to NoTotals do
      Total[n]:=Currency_Txlate(Total[n],RCr,RTxCr);

    If (FolioNum=0) then {* Deleted Item *}
    Begin
      CustCode:=LId.CustCode;
      TransDate:=LId.Pdate;
      OurRef:=DocCodes[LId.IdDocHed];
      YourRef:='Not Found';
      FolioNum:=LId.FolioRef;
    end;

    LGetMainRec(CustF,CustCode);

    DefFont(0,[fsBold]);

    If (Cont) then
    Begin
      // MHYR
      If (ReportMode = 3) Then
        ContStr:=' (cont)'
      Else
        ContStr:=' (continued...)';
    End
    else
      ContStr:='';

    SetReportDrillDown(1);

    SendLine(ConCat(#9,Form_Int(FolioNum,0),
             #9,OurRef,
             #9,YourRef,
             #9,PoutDate(TransDate),
             #9,PoutDateB(PostDate),
             #9,PPR_OutPr(AcPr,AcYr),
             #9,CustCode,
             #9,LCust.Company,
             #9,FormatFloat(GenRealMask,Total[1]),
             #9,FormatFloat(GenRealMask,Total[2]),
             #9,FormatFloat(GenRealMask,Total[3]),
             #9,FormatFloat(GenRealMask,Total[4]),
             #9,ContStr));

    DefLine(-1,MarginLeft,290,0);
  end;
end;


Procedure TDocReport.PrintReconHed;

  Var
    Y1 :  Double;

Begin
  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin
    ClearTabs;

    SetTab (MarginLeft+40, pjLeft, 50, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 36, 4, 0, 0);

    SetTabCount;

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    ShowDrCrD(StatTotal,RCrDr);

    DefFont(0,[fsBold]);

    Y1:=YD2U(CursorYPos)-LineHeight;

    SendLine(ConCat(#9,#9,'Debit (+)',#9,'Credit (-)'));

    DefFont(0,[]);

    DefLine(-1,100,128,0);
    DefLine(-1,134,163,0);


    SendLine(ConCat(#9,'Closing Balance of Statement :',#9,FormatFloat(GenRealMask,RCrDr[BOff]),
                    #9,FormatFloat(GenRealMask,RCrDr[BOn])));

    ShowDrCrD(ClearedTotal,RCrDr);

    SendLine(ConCat(#9,'Cleared Computer Balance :',#9,FormatFloat(GenRealMask,RCrDr[BOff]),
                   #9,FormatFloat(GenRealMask,RCrDr[BOn])));

    DefLine(-1,100,128,0);
    DefLine(-1,134,163,0);

    ShowDrCrD((StatTotal-ClearedTotal),RCrDr);


    SendLine(ConCat(#9,'Difference :',#9,
                   FormatFloat(GenRealMask,RCrDr[BOff]),
                   #9,FormatFloat(GenRealMask,RCrDr[BOn])));

    DefLine(-1,100,128,0);
    DefLine(-1,134,163,0);

    ShowDrCrD(NomBal,RCrDr);

    SendLine(ConCat(#9,'General Ledger Balance at Date :',#9,
                   FormatFloat(GenRealMask,RCrDr[BOff]),
                   #9,FormatFloat(GenRealMask,RCrDr[BOn])));

    DefFont(0,[fsUnderline]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    // HM 22/03/04: Extended for Print To HTML (7)
    If (RDevRec.Preview) And  (RDevRec.fePrintMethod <> 5) And (RDevRec.fePrintMethod <> 7) then
      DrillDownArea(TabStart(1),Y1,TabEnd(TotTabs),YD2U(CursorYPos),1,FullNomKey(ReconCode),NomF,NomCodeK,0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft('Uncleared General Ledger entries:-',MarginLeft);
    Self.CRLF;
    Self.CRLF;

    DefFont(0,[]);

    ClearTabs;
    RepSetTabs;
  end;
end;

Procedure TDocReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of

      0,5,10,20,30,40,50,60,70

         :  Begin

              // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag.
              SendLine(ConCat(#9, '', #9,'Our Ref',#9,'Acc No',#9,'Company',#9,'Your Ref',#9,'Pr Yr',#9,'Date',#9,'Date Due',
                                        #9,'Sub-Total',#9,CCVATName^,#9,'Total'));

            end;

      1  :  Begin

              If (CurrentPage=1) then
                PrintReconHed;

              SendLine(ConCat(#9,'Date',#9,'Doc Ref',#9,'Acc No',#9,'PayIn Ref',
                              #9,'Cheque No/Ref',#9,'Debit(+)',#9,'Credit(-)'));

            end;

      2  :  Begin

              SendLine(ConCat(#9,'Our Ref',#9,'Acc No',#9,'Your Ref',#9,'Pr Yr',#9,'Date',#9,'Due Date',#9,'Description',#9,'Debit',
                              #9,'Credit'));
            end;

      3  :  Begin

              SendLine(ConCat(#9,'Folio',#9,'Our Ref',#9,'Your Ref',#9,'Date',
                       #9,'Posted',#9,'Pr Yr',#9,'AC No',#9,'Company',#9,'Net',#9,'Disc',
                       #9,CCVATName^,#9,'Total',#9,' ')); // MHYR

            end;

      7  :  Begin

              SendLine(ConCat(#9,'Folio',#9,'Our Ref',#9,'Acc No',#9,'Company',
                              #9,'Your Ref',#9,'Pr Yr',#9,'Date',#9,'Date Due',#9,'Posted',
                              #9,'Sub-Total',#9,CCVATName^,#9,'Total'));

            end;


      8,9
         :  Begin

              SendLine(ConCat(#9,'Our Ref',#9,'Your Ref',#9,'Pr Yr',
                              #9,'Date',#9,'Date Due',#9,'Debit',#9,'Credit',#9,'Balance',
                              #9,CCVATName^,#9,'T/Over',#9,'Margin',#9,'GP%'));
            end;

      11,12
         :  Begin

               SendLine(ConCat(#9,'Acc No',#9,'Company',#9,'Debit',#9,'Credit',#9,
                    'T/Over',#9,'Margin',#9,'GP%'));

            end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}



Procedure TDocReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With RepFiler1,MTExLocal^ do
  If (CurrentPage>1) and (Not StkRepMode) then
    Case ReportMode of
      0,10,20,30,40,50,60,70
         :  PrintDocLine(LInv.InvDocHed,BOn);

      2  :  PrintNomLine(FullNomKey(LNom.NomCode),BOn);

      3  :  PrintDocHedLine(CRepParam^.RCr,CRepParam^.RTxCr,BOn);

      5  :
        begin
          PrintDocTypeLine(LInv.InvDocHed,BOn);
          fHasIntrastatOOP := false;
        end;


      8,9
         :  PrintCustLine(CRepParam^.LastCust,BOn);


    end; {Case..}
end;






{ ======================= Get Opening & Closing Balances & Print them =================== }

Procedure TDocReport.PrintOCBal(NomType  :  Char;
                                NomCode  :  Str10;
                                Rcr,RTxCr,
                                NYr,NPr,
                                Mode,
                                CommitMode
                                         :  Byte;
                                CloseBal :  Boolean);


Const
  OBalStr  :  Array[BOff..BOn] of Str50 = ('Opening','Closing');


Var
  Rnum                 :  Real;
  NCrDr                :  DrCrType;


Begin
  With RepFiler1 do
  Begin
    DefFont(0,[]);

    Rnum:=0.0;

    {$IFDEF SOP}
      If (CommitMode In [0,1]) then
    {$ENDIF}

      Rnum:=Get_OCBal(NomType,NomCode,RCr,NYr,NPr,0,CloseBal);

    {$IFDEF SOP}
        If (CommitMode In [1,2]) and (CommitAct) then {* Add in Commitment value *}
          Rnum:=Rnum+Get_OCBal(NomType,CommitKey+NomCode,RCr,NYr,NPr,0,CloseBal);

    {$ENDIF}


    Rnum:=Currency_Txlate(Rnum,RCr,RTxCr);

    ShowDrCr(Rnum,NCrDr);

    Case Mode of
      0  :  Begin
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.PrintLeft(OBalStr[CloseBal]+' Balance',MarginLeft);

              SendLine(ConCat(ConstStr(#9,8),FormatFloat(GenRealMask,NCrDr[BOff]),
                           #9,FormatFloat(GenRealMask,NCrDr[BOn])));

              If (CloseBal) then
              Begin
                DefLine(-1,MarginLeft,245,-0.6);
                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CrLf;
              end;

            end;

      8,9
          : Begin
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.PrintLeft(OBalStr[CloseBal]+' Balance',MarginLeft);

              SendLine(ConCat(ConstStr(#9,6),FormatFloat(GenRealMask,NCrDr[BOff]),
                           #9,FormatFloat(GenRealMask,NCrDr[BOn])));

              If (CloseBal) then
              Begin
                DefLine(-1,MarginLeft,155,-0.6);
                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CrLf;
              end;

              If (Not CloseBal) then
              With CRepParam^ do
              Begin
                StartBal:=Rnum;

                RunStartBal:=RunStartBal+StartBal;
              end;
            end;

    end;


  end; {With..}
end;


Procedure TDocReport.PrintDueTot(Gtot : Boolean);
Var
  n          :  Byte;
  Rnum,GPP
             :  Real;

  PostTotMsg :  Str80;

Begin
  PostTotMsg:='';

    GPP:=0;

  DefFont(0,[]);

  With MTExLocal^,RepFiler1 do
    With CRepParam^ do
      Case ReportMode of
        0,5,10,20,30,40,50,60,70 :
          Begin
            If (Not Gtot) then
              DefLine(-1,140,250,0)
            else
              DCrDr:=RCrDr;


            Rnum:=DCrDr[BOff]-DCrDr[BOn];

            // PKR. 28/01/2016. ABSEXCH-17223. Added an extra tab to fix column alignments
            SendLine(ConCat(ConstStr(#9,8),'Totals.:',#9,FormatFloat(GenRealMask,RNum),
                    #9,FormatFloat(GenRealMask,DCrDr[BOn]),
                    #9,FormatFloat(GenRealMask,DCrDr[BOff])));

            If (Not Gtot) then
              DefLine(-1,140,250,0);

            Blank(DCrDr,Sizeof(DCrDr));
          end; {Case..}
        2 :
          Begin
            If (Not Gtot) then
              DefLine(-1,210,275,0)
            else
              DCrDr:=RCrDr;

            SendLine(ConCat(ConstStr(#9,7),Spc(50)+'Totals.:',#9,FormatBFloat(GenRealMask,DCrDr[BOff],BOn),
                    #9,FormatBFloat(GenRealMask,DCrDr[BOn],BOn)));

            If (Not Gtot) then
            Begin
              DefLine(-2,210,275,0);

              If (ShowOCbal) then
                With LNom do
                  PrintOCBal(NomType,FullNomKey(NomCode),RCr,RTxCr,RYr2,RPr2,0,CommitMode,BOn);
            end;

            Blank(DCrDr,Sizeof(DCrDr));
          end;

        3 :
          Begin
            DCrDr:=RCrDr;

            If (Not Gtot) then
            Begin
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.PrintLeft('* denotes unposted transactions',MarginLeft);
              Self.CrLf;
              DefLine(-2,1,PageWidth-MarginRight-1,-0.5);
            end
            else
              PostTotMsg:='Posted ';

            SendLine(ConCat(ConstStr(#9,8),PostTotMsg+'Totals.:',
                     #9,FormatFloat(GenRealMask,RCrDr[Gtot])));
          end; {Case..}

        7 :
          Begin
            If (Not Gtot) then
            Begin
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.PrintLeft('* denotes unposted transactions',MarginLeft);
              Self.CrLf;
              PostTotMsg:=#9;
            end
            else
            Begin
              PostTotMsg:='Posted '+#9;

              RepTotals:=CustTot;

            end;

            DefLine(-1,147,277,-0.5);

            Rnum:=RepTotals[1]-RepTotals[2];

            SendLine(ConCat(ConstStr(#9,8),PostTotMsg,'Totals:',
                    #9,FormatFloat(GenRealMask,Rnum),
                    #9,FormatFloat(GenRealMask,RepTotals[2]),
                    #9,FormatFloat(GenRealMask,RepTotals[1])));
          end; {Case..}

        8,9 :
          Begin
            If (Not Gtot) then
            Begin
              DefLine(-1,1,PageWidth-MarginRight-1,-0.5);
            end
            else
            Begin
              CustTot:=RepTotals;

              StartBal:=RunStartBal;

              DefLine(-2,1,PageWidth-MarginRight-1,-0.5);
            end;

            Rnum:=CustTot[1]-CustTot[2]+StartBal;

            GPP:=Calc_Pcnt(CustTot[4],CustTot[5]);

            SendLine(ConCat(ConstStr(#9,5),'Totals:',#9,FormatBFloat(GenRealMask,CustTot[1],BOn),
                    #9,FormatBFloat(GenRealMask,CustTot[2],BOn),
                    #9,FormatFloat(GenRealMask,RNum),
                    #9,FormatFloat(GenRealMask,CustTot[3]),
                    #9,FormatFloat(GenRealMask,CustTot[4]),
                    #9,FormatFloat(GenRealMask,CustTot[5]),
                    #9,FormatFloat(GenPcntMask,GPP)));

            If (Not Gtot) then
              DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

            If (ShowOCbal) and (Not GTot) then
              PrintOCBal(CustHistPCde,LastCust,RCr,RTxCr,RYr2,RPr2,ReportMode,CommitMode,BOn);

            Blank(CustTot,Sizeof(CustTot));
          end; {Case..}

        11,12 :
          Begin
            CustTot:=RepTotals;

            DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

            GPP:=Calc_Pcnt(CustTot[4],CustTot[5]);

            SendLine(ConCat(#9,#9,'Totals:',#9,FormatBFloat(GenRealMask,CustTot[1],BOn),
                    #9,FormatBFloat(GenRealMask,CustTot[2],BOn),
                    #9,FormatFloat(GenRealMask,CustTot[4]),
                    #9,FormatFloat(GenRealMask,CustTot[5]),
                    #9,FormatFloat(GenPcntMask,GPP)));
          end; {Case..}
      end; {Case..}
end;




  { ======================= Calculate Due Totals ==================== }

  Procedure TDocReport.CalcDueTotals(CrDr      :  DrCrDType;
                                     TTot,
                                     PTot      :  Totals);
  Var
    n          :  SmallInt;
    nBo        :  Boolean;
    Rnum       :  Real;

  Begin

    Rnum:=0;

    With MTExLocal^,CRepParam^ do
      Case ReportMode of
        0,2,3,5,10,20,30,40,50,60,70
           :  Begin
                For nBo:=BOff to BOn do
                With CRepParam^ do
                Begin
                  DCrDr[NBo]:=Round_Up(DCrDr[NBo],2)+Round_Up(CrDr[NBo],2);
                  RCrDr[NBo]:=Round_up(RCrDr[NBo],2)+Round_Up(CrDr[NBo],2);
                end;
              end;

        1
           :  Begin
                RepTotal:=RepTotal+CrDr[BOff];
              end;

        7
           :  Begin
                For n:=1 to NoTotals do
                Begin

                  CustTot[n]:=CustTot[n]+Ptot[n];

                  RepTotals[n]:=RepTotals[n]+Ttot[n];
                end;
              end;
        8..9,11..12
           :  Begin
                For n:=1 to NoTotals do
                Begin
                  CustTot[n]:=CustTot[n]+Ttot[n];

                  RepTotals[n]:=RepTotals[n]+Ttot[n];
                end;
              end;

      end; {Case..With..}
  end;



{ ========= Procedure to Calculate Inv Totals ======= }

Procedure TDocReport.CalcCTH(Var TTot  :  Totals;
                                 RCr,
                                 RTxCr :  Byte);

Var
  PTot  :  Totals;
  n     :  Byte;

Begin

  Blank(PTot,Sizeof(PTot));

  With MTExLocal^,LInv do
  Begin

    If (RCr=0) then
    Begin
      PTot[1]:=ConvCurrItotal(LInv,BOff,BOn,BOn);
      PTot[3]:=Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,UseORate,BOff),2);

      If (Not (InvDocHed In RecieptSet)) then
        PTot[4]:=ConvCurrINet(LInv,BOff,BOn);

      If (InvDocHed In StkOutSet{-CreditSet}) then
      Begin
        PTot[5]:=(PTot[4]-ConvCurrICost(LInv,BOff,BOn));
      end;

    end
    else
    Begin
      PTot[1]:=Itotal(LInv);
      PTot[3]:=(InvVat);

      If (InvDocHed In StkOutSet{+CreditSet}) then
      Begin
        PTot[4]:=(PTot[1]-PTot[3]);
        PTot[5]:=(PTot[4]-TotalCost);
      end;

    end;

    For n:=1 to NoTotals do
      TTot[n]:=TTot[n]+(Currency_Txlate(PTot[n],RCr,RTxCr)*DocCnst[InvDocHed]*DocNotCnst);


  end; {with..}

end; {Proc..}



{ ========= Procedure to Calc Summary Values ======== }

Procedure TDocReport.CustTHH(Var TTot     :  Totals;
                             Var FoundOk  :  Boolean);
Var
  FoundMode  :  Boolean;

  N          :  Byte;
  Fnum,
  Keypath    :  Integer;

  Rnum       :  Double;

  KeyCS,
  KeyChk     :  Str255;

  CrDr       :  DrCrType;

Begin

  Fnum:=InvF;

  Keypath:=InvCustK;

  With MTExLocal^,CRepParam^ do
  Begin

    KeyChk:=FullCustType(LCust.CustCode,LCust.CustSupp);

    KeyCS:=KeyChk;

    Blank(TTot,Sizeof(TTot));

    Blank(CrDr,Sizeof(CrDr));

    FoundMode:=FoundOk;

    FoundOk:=BOff;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOff)) and (Not FoundOk) and (ChkRepAbort) do
    With LInv do
    Begin

      If (SummInclude) then
      Begin

        CalcCTH(TTot,RCr,RTxCr);

        FoundOk:=FoundMode;

      end;

      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    If (Not FoundMode) then
    Begin
      Rnum:=Get_OCBal(CustHistPCde,LCust.CustCode,RCr,RYr,RPr,0,BOff);

      TTot[1]:=TTot[1]+Rnum;

    end;

    If (FoundOk) and (FoundMode) then
    Begin

      ShowDrCr(TTot[1],CrDr);

      For FoundMode:=BOff to BOn do
      Begin

        TTot[1+Ord(FoundMode)]:=CrDr[FoundMode];

      end;
    end;

  end; {With..}

end; {Proc..}



Procedure TDocReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^, CRepParam^ do
  Begin
    Case ReportMode of
      0,5,10,20,30,40,50,60,70
         :  Begin
              SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
              SendRepDrillDown(2,3,2,LInv.CustCode,CustF,CustCodeK,0);
            end;

      1  :  Begin
              SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);
              SendRepDrillDown(3,3,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);
            end;

      2  :  Begin
              SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);
              SendRepDrillDown(2,2,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);
            end;

      3  :  Begin
              Case DDMode of
                0  :  Begin
                        SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);
                        SendRepDrillDown(3,4,2,FullNomKey(LId.NomCode),NomF,NomCodeK,0);
                      end;

                1  :  Begin
                        SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
                        SendRepDrillDown(6,7,2,FullCustCode(LInv.CustCode),CustF,CustCodeK,0);
                      end;
              end; {Case..}
            end;

      7  :  Begin
              SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
              SendRepDrillDown(3,4,2,LInv.CustCode,CustF,CustCodeK,0);
            end;
      8,9
         :  Begin
              SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
            end;
      11,12
         :  SendRepDrillDown(1,TotTabs,1,LCust.CustCode,CustF,CustCodeK,0);


    end; {Case..}
  end; {With..}
end;

Procedure TDocReport.PrintReportLine;


const
  KeyPath  =  IDFolioK;

Var
  UOR        :  Byte;
  GPP,
  Rnum       :  Double;
  CrDr       :  DrCrDType;
  TBo        :  Boolean;

  YRefStr,
  GenStr     :  Str255;

  NPChar     :  Char;

  PTot,
  TTot       :  Totals;

  // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag.
  IntrastatOOPFlag : string;
  hasIntrastatLines : Boolean;
  Key       : str255;
  ChkKey    : Str255;
Begin

  Rnum:=0; NPChar:=#32;

  YRefStr:=''; UOR:=0;

  Blank(CrDr,Sizeof(CrDr));

  Blank(PTot,Sizeof(PTot));

  Blank(TTot,Sizeof(TTot));


  With MTExLocal^,RepFiler1 do
    With CRepParam^ do
    Begin

      Case ReportMode of
        0,10,20,30,40,50,60,70
          :  With LInv do
             If (InvDocHed<>LastDoc) then
             Begin
               If (LastDoc<>Run) then
                 PrintDueTot(BOff);

               PrintDocLine(InvDocHed,BOff);

               LastDoc:=InvDocHed;
             end;

        2    :  With LId do
                If (NomCode<>LastNom) then
                Begin
                  If (LastNom<>0) then
                    PrintDueTot(BOff);

                  LastNom:=NomCode;

                  PrintNomLine(FullNomKey(NomCode),BOff);

                  If (ShowOCbal) then
                    With LNom do
                      PrintOCBal(NomType,FullNomKey(NomCode),RCr,RTxCr,RYr,RPr,0,CommitMode,BOff);

                end;

        3    :  With LId do
                If (FolioRef<>LastNom) then
                Begin

                  LastNom:=FolioRef;

                  PrintDocHedLine(RCr,RTxCr,BOff);


                end;

        5
              :  With LInv do
                 If (OurRef[1]<>LastDocType) then
                 Begin
                   If (LastDocType<>ResetKey) then
                     PrintDueTot(BOff);

                   PrintDocTypeLine(InvDocHed,BOff);

                   LastDocType:=OurRef[1];
                 end;

        8,9
               :  With LInv do
                  If (CustCode<>LastCust) then
                  Begin
                    If (LastCust<>'') then
                      PrintDueTot(BOff);

                    LastCust:=CustCode;

                    PrintCustLine(LastCust,BOff);

                    If (ShowOCbal) then
                      PrintOCBal(CustHistPCde,LastCust,RCr,RTxCr,RYr,RPr,ReportMode,CommitMode,BOff);

                  end;


      end; {Case..}


      DefFont (0,[]);

      If (ReportMode<>3) then
        SetReportDrillDown(0);

      Case ReportMode of
        0,5,10,20,30,40,50,60,70
             :  With LInv do
                Begin
                  If (ReportMode In [50,60]) then {* Show O/S order value *}
                  Begin
                      If (RCr=0) then
                    Begin
                      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                      CrDr[BOff]:=Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);

                      CrDr[BOn]:=0;
                    end
                    else
                    Begin
                      CrDr[BOff]:=TotOrdOS;
                      CrDr[BOn]:=0;
                    end;

                  end
                  else
                  Begin
                    If (RCr=0) then
                    Begin
                      If (ReportMode<>5) then
                        CrDr[BOff]:=ConvCurrItotOrg(LInv,BOff,BOn,BOn)
                      else
                        CrDr[BOff]:=ConvCurrItotal(LInv,BOff,BOn,BOn);

                      CrDr[BOn]:=Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,UseORate,BOff),2);
                    end
                    else
                    Begin
                      CrDr[BOff]:=Itotal(LInv);
                      CrDr[BOn]:=(InvVat);
                    end;
                  end;

                  LGetMainRec(CustF,CustCode);

                  For TBo:=BOff to BOn do
                  Begin
                    CrDr[TBo]:=CrDr[TBo]*DocCnst[InvDocHed]*DocNotCnst;

                  end;

                  If (ReportMode In [30,40]) and (InvDocHed In DirectSet) then
                  Begin
                    CrDr[BOff]:=CrDr[BOff]*DocNotCnst;
                    CrDr[BOn]:=0;
                  end;

                  Rnum:=CrDr[BOff]-CrDr[BOn];

                  // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period indicator.
                  // PKR. 27/01/2016. ABSEXCH-17160. Preposting reports not showing * for Out of Period Intrastat Transactions
                  // PKR. 29/01/2016. Restructured for efficiency following code review.
                  // NOTE: There is similar code to this in Report3U and SQLRep_GLPrePosting
                  // and it is based on code in PostingU.

                  IntrastatOOPFlag := '';
                  if (Syss.IntraStat) then
                  begin
                    if (LCust.EECMember) then
                    begin
                      // Need to examine the lines in the document to see if any have VAT Code A or D.
                      hasIntrastatLines := false;

                      Key := FullNomKey(FolioNum);
                      ChkKey := Key;

                      LStatus := LFind_Rec(B_GetGEq, IDetailF, KeyPath, Key);
                      while (LStatusOk) and (CheckKey(ChkKey, Key, Length(ChkKey), True)) do
                      begin
                         if (LId.VATCode in ['A', 'D']) then
                         begin
                           hasIntrastatLines := true;
                           break;
                         end;

                         LStatus := LFind_Rec(B_GetNext, IDetailF, KeyPath, Key);
                      end; // while (LStatusOK)...

                      if (hasIntrastatLines) then
                      begin
                        // Check for and report on transactions posted into closed
                        // Intrastat periods
                        if InvDocHed in [PIN, PJI, PCR, PJC, PPI, PRF] then
                        begin
                          if TransDate <= SystemSetup.Intrastat.isLastClosedArrivalsDate then
                          begin
                            IntrastatOOPFlag := '*';
                            fHasIntrastatOOP := true;
                          end;
                        end
                        else if InvDocHed in [SIN, SJI, SCR, SJC, SRI, SRF] then
                        begin
                          if TransDate <= SystemSetup.Intrastat.isLastClosedDispatchesDate then
                          begin
                            IntrastatOOPFlag := '*';
                            fHasIntrastatOOP := true;
                          end;
                        end;
                      end; // if has Intrastat lines
                    end; // Customer is an EC Member
                  end; // if Intrastat

                  // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag.
                  SendLine(ConCat(#9, IntrastatOOPFlag,
                          #9,LInv.OurRef,
                          #9,LInv.CustCode,
                          #9,LCust.Company,
                          #9,LInv.YourRef,
                          #9,PPR_OutPr(AcPr,AcYr),
                          #9,POutDateB(LInv.TransDate),
                          #9,POutDateB(LInv.DueDate),
                          #9,FormatFloat(GenRealMask,RNum),
                          #9,FormatFloat(GenRealMask,CrDr[BOn]),
                          #9,FormatFloat(GenRealMask,CrDr[BOff])));

                end;

        1  :  Begin
                With LId do
                Begin

                  If (IDDocHed=RUN) then
                    Summary:=BOn
                  else
                    Summary:=Not Syss.SepDiscounts;


                  Rnum:=DetLTotal(LId,Summary,BOff,0.0);

                  If (RCr=0) then
                    Rnum:=Round_Up(Conv_TCurr(Rnum,CXRate[UseCoDayRate],Currency,UseORate,BOff),2);

                  ShowDrCrD(Rnum,RCrDr);

                  GenStr:=Extract_PayRef2(StockCode);

                end; {With..}


                SendLine(ConCat(#9,POutDateB(LId.PDate),
                        #9,LInv.OurRef,
                        #9,LInv.CustCode,
                        #9,GenStr,
                        #9,LId.Desc,
                        #9,FormatBFloat(GenRealMask,RCrDr[BOff],BOn),
                        #9,FormatBFloat(GenRealMask,RCrDr[BOn],BOn)));


                CrDr[BOff]:=Rnum;
              end;


        2
              :
                Begin
                  With LId do
                  Begin
                    If (IDDocHed=RUN) then
                    Begin
                      Summary:=BOn;
                      LInv.OurRef:=DocCodes[IDDocHed]+' '+Strip('B',[#32],PDate);
                    end
                    else
                      Summary:=Not Syss.SepDiscounts;

                      
                    Rnum:=DetLTotal(LId,Summary,BOff,0.0);

                    If (RCr=0) then
                    Begin
                      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                      Rnum:=Round_Up(Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
                    end;


                    Rnum:=Round_Up(Currency_Txlate(Rnum,RCr,RTxCr),2);


                    ShowDrCrD(Rnum,CrDr);

                    If (IDDocHed=NMT) then
                      YRefStr:=LInv.TransDesc
                    else
                      YRefStr:=LInv.YourRef;
                  end; {With..}



                  SendLine(ConCat(#9,LInv.OurRef,
                          #9,LInv.CustCode,
                          #9,YRefStr,
                          #9,PPR_OutPr(LId.PPr,LId.PYr),
                          #9,POutDateB(LInv.TransDate),
                          #9,POutDateB(LInv.DueDate),
                          #9,LId.Desc,
                          #9,FormatBFloat(GenRealMask,CrDr[BOff],BOn),
                          #9,FormatBFloat(GenRealMask,CrDr[BOn],BOn)));

                end;


        3
              :
                Begin
                  With LId do
                  Begin

                    Summary:=BOff;

                    If (Not (IdDocHed In QuotesSet)) then  {* Only Display totals for Non quotations *}
                      Rnum:=DetLTotal(LId,Summary,BOff,0.0)*DocNotCnst;

                    If (RCr=0) then
                    Begin
                      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                      Rnum:=Round_Up(Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
                    end;

                    Rnum:=Currency_Txlate(Rnum,RCr,RTxCr);

                    CrDr[BOff]:=Rnum;

                    If (PostedRun>0) then {* Store Posted Totals *}
                      CrDr[BOn]:=Rnum
                    else
                      NPChar:='*';

                    LGetMainRec(NomF,FullNomKey(NomCode));

                  end; {With..}

                  ClearTabs;

                  SetTab (MarginLeft, pjRight, 15, 4, 0, 0);
                  SetTab (NA, pjLeft, 92{89}, 4, 0, 0);   // MHYR
                  SetTab (NA, pjRight, 18, 4, 0, 0);
                  SetTab (NA, pjLeft, 40{45}, 4, 0, 0);   // MHYR
                  SetTab (NA, pjRight, 27{29}, 4, 0, 0);   // MHYR

                  SetTabCount;
                  SetReportDrillDown(0);

                  SendLine(ConCat(#9,NPChar,' ',Form_Int(LId.FolioRef,0),
                          #9,LId.Desc,
                          #9,Form_BInt(LId.NomCode,0),
                          #9,LNom.Desc,
                          #9,FormatFloat(GenRealMask,RNum)));

                  RepSetTabs;
                end;

        7
             :  With LInv do
                Begin
                  If (RCr=0) then
                  Begin
                    CrDr[BOff]:=ConvCurrItotOrg(LInv,BOff,BOn,BOn);
                    CrDr[BOn]:=Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,UseORate,BOff),2);
                  end
                  else
                  Begin
                    CrDr[BOff]:=Itotal(LInv);
                    CrDr[BOn]:=(InvVat);
                  end;


                  LGetMainRec(CustF,CustCode);

                  
                  For TBo:=BOff to BOn do
                  Begin
                    CrDr[TBo]:=Currency_Txlate(CrDr[TBo],RCr,RTxCr)*DocCnst[InvDocHed]*DocNotCnst;

                    TTot[1+Ord(TBo)]:=CrDr[TBo];

                    If (RunNo>0) then
                      PTot[1+Ord(TBo)]:=CrDr[TBo]
                    else
                      NPChar:='*';

                  end;


                  Rnum:=CrDr[BOff]-CrDr[BOn];


                  SendLine(ConCat(#9,NPChar,' ',Form_Int(FolioNum,0),
                          #9,LInv.OurRef,
                          #9,LInv.CustCode,
                          #9,LCust.Company,
                          #9,LInv.YourRef,
                          #9,PPR_OutPr(AcPr,AcYr),
                          #9,POutDateB(LInv.TransDate),
                          #9,POutDateB(LInv.DueDate),
                          #9,POutDateB(LInv.PostDate),
                          #9,FormatFloat(GenRealMask,RNum),
                          #9,FormatFloat(GenRealMask,CrDr[BOn]),
                          #9,FormatFloat(GenRealMask,CrDr[BOff])));



                end;

          8,9
             :  With LInv do
                Begin

                  CalcCTH(TTot,RCr,RTxCr);

                  If (InvDocHed In DirectSet) then {* Set to Debit & Credit *}
                  Begin
                    TTot[2]:=ABS(TTot[1]);
                    TTot[1]:=TTot[2];
                  end
                  else
                  Begin

                    ShowDrCrD(TTot[1],CrDr);

                    For TBo:=BOff to BOn do
                    Begin

                      TTot[1+Ord(TBo)]:=CrDr[TBo];

                    end;
                  end;


                  GPP:=Calc_Pcnt(TTot[4],TTot[5]);


                  SendLine(ConCat(#9,LInv.OurRef,
                          #9,LInv.YourRef,
                          #9,PPR_OutPr(AcPr,AcYr),
                          #9,PoutDateB(LInv.TransDate),
                          #9,POutDateB(LInv.DueDate),
                          #9,FormatFloat(GenRealMask,TTot[1]),
                          #9,FormatFloat(GenRealMask,TTot[2]),
                          #9,
                          #9,FormatFloat(GenRealMask,TTot[3]),
                          #9,FormatFloat(GenRealMask,TTot[4]),
                          #9,FormatFloat(GenRealMask,TTot[5]),
                          #9,FormatFloat(GenPcntMask,GPP)));


                end;

          11,12
             :  With LCust do
                Begin

                  TBo:=BOff;

                  CustTHH(TTot,TBo);


                  GPP:=Calc_Pcnt(TTot[4],TTot[5]);



                  SendLine(ConCat(#9,CustCode,
                          #9,Company,
                          #9,FormatBFloat(GenRealMask,TTot[1],BOn),
                          #9,FormatBFloat(GenRealMask,TTot[2],BOn),
                          #9,FormatFloat(GenRealMask,TTot[4]),
                          #9,FormatFloat(GenRealMask,TTot[5]),
                          #9,FormatFloat(GenPcntMask,GPP)));


                end;

      end; {Case..}


      CalcDueTotals(CrDr,TTot,PTot);

    end; {With(s)..}
end;


function TDocReport.SummInclude  :  Boolean;

Begin
  With MTExLocal^,LInv do
    With CRepParam^ do
    Begin
      Result:=((LInv.RunNo>0)
                   and (Not (InvDocHed In QuotesSet))
                   and ((Pr2Fig(ACYr,ACPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(ACYr,ACPr)<=Pr2Fig(RYr2,RPr2)))
                   and ((RCr=Currency) or (RCr=0))
                   and ((LInv.CustCode=CustFilt) or (CustFilt=''))
                   and (CheckKey(DocWanted,DocCodes[InvDocHed],Length(DocWanted),BOff))
                   and (CheckKey(RCCDep[BOff],LCust.CustDep,Length(RCCDep[BOff]),BOff))
                   and (CheckKey(RCCDep[BOn],LCust.CustCC,Length(RCCDep[BOn]),BOff))
                   and (LCust.CustSupp=TradeCode[(ReportMode In [8,11])]));


      {* Establish if Opening/Closing balance needs to be shown *}

        ShowOCbal:=(EmptyKey(DocWanted,3));

      {$IFDEF PF_On}

        If (ShowOCBal) then
          ShowOCBal:=((EmptyKeyS(RCCDep[BOff],CCKeyLen,BOff)) and (EmptyKeyS(RCCDep[BOn],ccKeyLen,BOff)));

      {$ENDIF}


    end;

end;


function TDocReport.IncludeRecord  :  Boolean;

Const
  Fnum    =  InvF;
  KeyPath =  InvFolioK;

Var
  TmpInclude :  Boolean;
  DayRepInc  :  Boolean;

  ChkRecon   :  Byte;
  KeyCS      :  Str255;



Begin

  TmpInclude:=BOff;

  {$B-}

  With MTExLocal^,RepFiler1 do
    With CRepParam^ do
    Begin
      {$IFDEF DXXXBXXXD}
        IF (Debug) and (ReportMode=2) then
        With LId do
        Begin
          DebugForm.Add('I: '+Form_Int(FolioRef,0)+', '+DocPRef+'. '+FormatDateTime('hhmmss',Now));


        end;
      {$ENDIF}

      If (ReportMode In [1,2,3]) then
      Begin
        LResetRec(Fnum);

        KeyCS:=FullNomKey(LId.FolioRef);

        If (LId.FolioRef<>0) then
          LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS);


      end
      else
        If (ReportMode In [8,9]) then
        Begin
          If (LInv.CustCode<>LCust.CustCode) then
            LGetMainRec(CustF,LInv.CustCode);

        end;




      Case ReportMode of

        0,10,20,30,40,50,60,70
             :  With LInv do
                Begin

                  Case ReportMode of
                    50,60
                      :  TmpInclude:=((RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo) and (InvDocHed In PSOPSet));

                    else TmpInclude:=((RunNo>0) or (InvDocHed In QuotesSet+PSOPSet));

                  end; {Case..}


                  TmpInclude:=(TmpInclude
                               and (CheckKey(RepKey,DocCodes[InvDocHed],Length(RepKey),BOff))
                               and ((Pr2Fig(ACYr,ACPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(ACYr,ACPr)<=Pr2Fig(RYr2,RPr2)))
                               and ((RCr=Currency) or (RCr=0))
                               and ((CustCode=CustFilt) or (CustFilt='')));


                  Case ReportMode of
                    10  :  DayRepInc:=(InvDocHed In SDayRepSet);
                    20  :  DayRepInc:=(InvDocHed In PDayRepSet);
                    30  :  DayRepInc:=(InvDocHed In RDayRepSet);
                    40  :  DayRepInc:=(InvDocHed In YDayRepSet);
                    50  :  DayRepInc:=(InvDocHed In SODayRepSet);
                    60  :  DayRepInc:=(InvDocHed In PODayRepSet);
                    else   DayRepInc:=BOn;
                  end; {Case..}

                  TmpInclude:=(TmpInclude and DayRepInc);


                  {$IFDEF PF_On}

                    If (TmpInclude) then
                    With LCust do
                    Begin

                      If (CustCode<>LInv.CustCode) then
                        LGetMainRec(CustF,LInv.CustCode);

                      TmpInclude:=((CheckKey(RCCDep[BOff],CustDep,Length(RCCDep[BOff]),BOff))
                                  and (CheckKey(RCCDep[BOn],CustCC,Length(RCCDep[BOn]),BOff)));
                    end;

                  {$ENDIF}

                  If (Not CheckKey(RepKey,OurRef,Length(RepKey),BOff)) then
                  Begin
                    KeyS:=NdxWeight;

                    B_Next:=B_GetGEq;
                  end;
                end;


        5
             :  With LInv do
                Begin
                  TmpInclude:=((RunNo=NomToo)
                               and (InvDocHed In DayBkFlt)
                               and (Not OnHold(HoldFlg)));

                  If (RunNo<>NomToo) then
                  Begin
                    KeyS:=NdxWeight;

                    B_Next:=B_GetGEq;
                  end;

                end;

        1    :  With LId do
                Begin


                  ChkRecon:=ReconC;

                  If (PostedRun=PayInRunNo) and (ShowPIMode) then  {* Get Reconcile Status *}
                  Begin
                    {$IFDEF EXSQL}
                     if SQLUtils.UsingSQL then
                       Reconcile := LCheck_PayInStatus(LId)
                     else
                    {$ENDIF}
                    If (Assigned(DDMList)) then
                      Reconcile:=DDMList.Check_PayInStatus(LId)
                    else
                      Reconcile:=0;

                    ChkRecon:=ReconA;
                  end;

                  TmpInclude:=(CheckKey(FullNomKey(NomCode),RepKey,Length(FullNomKey(Nomcode)),BOn))
                              and (Reconcile<>ChkRecon) and ((IDDocHed<>RUN) or (ShowPIMode))
                              and ((PYr<=RYr) and (PDate<=DueLimit) and
                              ((RCr=Currency) or (RCr=0)));

                  {If (PYr>RYr) then
                  Begin
                    KeyS:=NdxWeight;

                    B_Next:=B_GetGEq;
                  end;}
                end;
        2,3
             :  With LId  do
                Begin
                  {* If Quote mode, Filter out Auto Items by checking Doc RunNo =0, as Auto Docs have a -2 RunNo*}
                  {* Also excluding Pay-in Ref Lines by filtering out <0 Posted run Nos *}
                  {* Exclude Quotaions from audit as they have -ve folio and we are not interested in them *}
                  {* and deleted quotes, with no parent *}



                  TmpInclude:=((((LInv.RunNo>0) or (IDDocHed=RUN)) or ((ReportMode=3) and (LInv.RunNo>=0) and (LInv.FolioNum>0))
                               or  ((QuoteMode) and (LInv.RunNo=0) and (LInv.FolioNum<>0)))

                                {$IFDEF SOP}
                                 and ((ReportMode<>2) or (Not CommitAct)
                                  or ((IdDocHed<>RUN) and (CommitMode In [0,1]))
                                  or ((PostedRun<>CommitOrdRunNo) and (CommitMode In [0,1]))
                                  or ((PostedRun=CommitOrdRunNo) and (CommitMode In [1,2])))

                               {$ENDIF}

                               and ((NomCode>=ReconCode) and (NomCode<=NomToo))
                               and (((FolioRef>=FolStart) and (FolioRef<=FolEnd)) or (ReportMode<>3))
                               and ((((Pr2Fig(PYr,PPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(PYr,PPr)<=Pr2Fig(RYr2,RPr2))) and (Not ByDate)) or
                                  ((PDate>=SDate) and (PDate<=EDate) and (ByDate)))
                               and ((RCr=Currency) or (RCr=0))
                               and ((LInv.CustCode=CustFilt) or (CustFilt=''))
                               and (((IDDocHed=RUN) and (Currency=RCr) and (PostedRun>0))
                               or (IDDocHed<>RUN)
                               or ((PostedRun=CommitOrdRunNo) and (CommitMode In [1,2])))
                               and (CheckKey(DocWanted,DocCodes[IdDocHed],Length(DocWanted),BOff)));


                  If (TmpInclude) then
                  Begin


                    {$IFDEF PF_On}

                      For DayRepInc:=BOff to BOn do
                        TmpInclude:=(TmpInclude
                                     and (CheckKey(RCCDep[DayRepInc],CCDep[DayRepInc],Length(RCCDep[DayRepInc]),BOff)));

                    {$ENDIF}

                    Case ReportMode of    {* Exclude automatic Items, but allow non posted items in *}

                      3  :  TmpInclude:=((TmpInclude) and (IDDocHed<>RUN) and (LInv.RunNo>=0));

                    end; {Case..}


                    {* Establish if Opening/Closing balance needs to be shown *}

                    ShowOCbal:=((EmptyKey(CustFilt,CustKeyLen)) and (Trim(DocWanted)='')) and (Not ByDate);


                    {$IFDEF PF_On}

                      For DayRepInc:=BOff to BOn do
                        ShowOCbal:=(ShowOCbal
                                     and (EmptyKeyS(RCCDep[DayRepInc],CCKeyLen,BOff)));

                    {$ENDIF}


                  end;



                  If (((NomCode>NomToo) or ((QuoteMode) and (LId.PostedRun>0))) and (ReportMode=2))
                    or ((FolioRef>FolEnd) and (ReportMode=3)) then
                  Begin
                    KeyS:=FullNomKey(LastAddrD);

                    B_Next:=B_GetGEq;
                  end;
                end;

        7
             :  With LInv  do
                Begin
                  {* Exclude Quotaions from audit as they have -ve folio and we are not interested in them *}
                  {* and deleted quotes, with no parent *}

                  TmpInclude:=((LInv.RunNo>=0)
                               and ((FolioNum>=ReconCode) and (FolioNum<=NomToo))
                               and ((Pr2Fig(ACYr,ACPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(ACYr,ACPr)<=Pr2Fig(RYr2,RPr2)))
                               and ((RCr=Currency) or (RCr=0))
                               and ((LInv.CustCode=CustFilt) or (CustFilt=''))
                               and (CheckKey(DocWanted,DocCodes[InvDocHed],Length(DocWanted),BOff)));



                  If (FolioNum>NomToo) then
                  Begin
                    KeyS:=FullNomKey(LastAddrD);

                    B_Next:=B_GetGEq;
                  end;
                end;

        8,9
             :  With LInv  do
                Begin
                  // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer support to Customer Trading History Report (8) and Summary Report (11)
                  If (ReportMode = 8) And (IncludeAccountTypes <> atCustomersAndConsumers) And (CustFilt = '') Then
                  Begin
                    // Apply the subtype filtering for Customer Only / Consumer Only
                    If (IncludeAccountTypes = atCustomersOnly) Then
                      TmpInclude := (LCust.acSubType = ConsumerUtils.CUSTOMER_CHAR)
                    Else If (IncludeAccountTypes = atConsumersOnly) Then
                      TmpInclude := (LCust.acSubType = ConsumerUtils.CONSUMER_CHAR)
                    Else
                      // Shouldn't ever happen, but running in thread so we can't raise an exception or display a message
                      TmpInclude := True;  // Better to include unwanted info, than to potentially hide wanted info
                  End // If (ReportMode = 8)
                  Else
                    TmpInclude := True;

                  If TmpInclude Then
                    TmpInclude:=SummInclude;

                  If (Not TmpInclude) then
                  Begin

                    If (CustCode>CustFilt) and (CustFilt<>'') then
                    Begin
                      KeyS:=NdxWeight;

                      B_Next:=B_GetGEq;
                    end
                    else
                      If (CustSupp>TradeCode[(ReportMode=8)]) then
                      Begin
                        KeyS:=FullCustType(CustCode,NdxWeight);

                        B_Next:=B_GetGEq;
                      end
                      else
                        B_Next:=B_GetNext;
                  end
                  else
                    B_Next:=B_GetNext;
                end;

        11,12
             :  With LCust do
                Begin

                  TmpInclude:=(CustSupp=TradeCode[(ReportMode=11)]);


                  If (TmpInclude) then
                    CustTHH(CustTot,TmpInclude);


                  If (CustCode>CustFilt) and (CustFilt<>'') then
                  Begin
                    KeyS:=NdxWeight;

                    B_Next:=B_GetGEq;
                  end;
                end;


      end; {Case..}
    end; {With..}

    {$B+}

    Result:=TmpInclude;
end;




Procedure TDocReport.PrintEndPage;



Begin
  With RepFiler1,CRepParam^ do
  Begin
    If (Not StkRepMode) then
      Case ReportMode of
        0,2,3,5,10,20,30,40,50,60,70
          :  Begin

                PrintDueTot(BOff);

                If RepPrintExcelTotals then
                Begin
                  DefLine(-1,1,PageWidth-MarginRight-1,0);

                  PrintDueTot(BOn);
                  
                  // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag.
                  if (fHasIntrastatOOP ) then
                  begin
                    DefFont(-1,[fsItalic,fsBold]);
                    // Clear the tabs to prevent the text being chopped off - this is called at the end of
                    // the report so we don't need the tabs anymore anyway
                    with RepFiler1 do
                    begin
                      ClearTabs;
                      SetTab (MarginLeft, pjLeft, PageWidth-MarginLeft, 4, 0, 0);

                      SendLine(#9'* denotes an Out of Period Intrastat Transaction');

                      // PKR. 01/03/2016. ABSEXCH-17342. Report Totals out of alignment or not showing.
                      // Clear the tabs and reinstate the ones for the report.
                      ClearTabs;
                      RepSetTabs;
                    end;
                  end;
                end;
             end;
        1 :  Begin

               DefLine(-1,1,PageWidth-MarginRight-1,0);

               ShowDrCrD(RepTotal,RCrDr);


               If RepPrintExcelTotals then
               Begin

                 SendLine(ConCat(ConstStr(#9,5),'Total Un-Cleared .:',#9,FormatFloat(GenRealMask,RCrDr[BOff]),
                          #9,FormatFloat(GenRealMask,RCrDr[BOn])));

                 ShowDrCrD((NomBal-RepTotal),RCrDr);

                 SendLine('');

                 SendLine(ConCat(ConstStr(#9,5),'Calculated Cleared Bal:',#9,FormatFloat(GenRealMask,RCrDr[BOff]),
                          #9,FormatFloat(GenRealMask,RCrDr[BOn])));

                 ShowDrCrD((ClearedTotal-(NomBal-RepTotal)),RCrDr);

                 SendLine(ConCat(ConstStr(#9,5),'Difference:',#9,FormatFloat(GenRealMask,RCrDr[BOff]),
                          #9,FormatFloat(GenRealMask,RCrDr[BOn])));
               end;

             end;

      7..9
         :  Begin

              PrintDueTot(BOff);

              If RepPrintExcelTotals then
                PrintDueTot(BOn);
            end;
      11,12
         :  If RepPrintExcelTotals then
              PrintDueTot(BOn);



      end; {Case..}


    Inherited PrintEndPage;

  end; {With..}
end;





Function TDocReport.GetReportInput  :  Boolean;

{$IFDEF SOP}
  Const
    CommitTitle  :  Array[1..2] of Str50 = ('Committed & Actual values.','Committed values only.');

{$ENDIF}

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundLong
     :  LongInt;

  FoundCode
     :  Str20;

  TmpCleared
     :  Double;

  CrDr
     :  DrCrDType;

  CCTitle
     :  Str50;
  {$IFDEF REPPFC}
  sCompany : ShortString;
  sColName : ShortString;
  {$ENDIF}

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, '')
  End; // ColName
  {$ENDIF}

Begin
  Blank(CrDr,Sizeof(CrDr));
  TmpCleared:=0.0;

  With CRepParam^ do
  Begin
    Case ReportMode of
      0,10,20,30,40,50,60,70
         :  Begin
              If (Debug) then
              Begin
                {RCr:=0;

                RPr:=1;  RYr:=Syss.CYr;

                RPr2:=Syss.CPr; RYr2:=Syss.CYr;

                DocWanted:='';}

              end;


              ThTitle:=DocAnalRepTits[Round(ReportMode/10)];

              RepTitle:=ThTitle;

              LastDoc:=RUN;


              If (ReportMode<>0) then
                DocWanted:=DocAnalFilt[Round(ReportMode/10)];



              {$IFDEF MC_On}
                RepTitle:=CurrDesc(RCr)+RepTitle;
              {$ENDIF}

              If (CustFilt<>'') then
              Begin
                {$IFDEF EXSQL}
                If SQLUtils.UsingSQL and (Assigned(MTExLocal)) then
                With MTExLocal^ do
                Begin
                  If LGetMainRec(CustF,CustFilt) then
                    RepTitle2:=RepTitle2+'For '+Strip('B',[#32],LCust.Company);
                end
                else
                {$ENDIF}
                begin
                  GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);


                  RepTitle2:='For '+Strip('B',[#32],Cust.Company);
                end;
              end;

              If (DocWanted<>'') then
              Begin
                If (RepTitle2<>'') then
                  RepTitle2:=RepTitle2+', ';

                RepTitle2:=RepTitle2+'Document Filter : '+DocWanted;
              end;


              {$IFDEF PF_On}

                For BoLoop:=BOff to BOn do

                  If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
                  Begin

                    FoundCode:=RCCDep[BoLoop];

                    {$IFDEF EXSQL}
                    If SQLUtils.UsingSQL and (Assigned(MTExLocal)) then
                    With MTExLocal^ do
                    Begin
                      If LGetMainRec(PWrdF,FullCCKey(CostCCode,CSubCode[boLoop],FoundCode)) then
                        CCTitle:=LPassword.CostCtrRec.CCDesc;
                    end
                    else
                    {$ENDIF}
                      GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

                  end; {Loop..}

              {$ENDIF}



              PageTitle:=RepTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')';

              RFnum:=InvF;

              RKeyPath:=InvOurRefK;

              If (DocWanted<>DocCodes[RUN]) then
                RepKey:=DocWanted;

              RFont.Size:=7;

              ROrient:=RPDefine.PoLandscape;
            end;

      1  :  Begin

              If (Debug) then
              Begin
                {RCr:=0;

                RPr:=Syss.CPr; RYr:=Syss.CYr;

                DueLimit:=Today;

                ReconCode:=20010;

                ShowPIMode:=BOn;}

              end;

	      RepTitle:='Reconciliation';
              ThTitle:=RepTitle+' Report';

              {$IFDEF EXSQL}
              if SQLUtils.UsingSQL and Assigned(MTExLocal) then
              begin
                MTExLocal^.LGetMainRec(NomF, FullNomKey(ReconCode));
                Nom := MTExLocal^.LNom;
              end
              else
              {$ENDIF}
                GetNom(Application.MainForm,Form_Int(ReconCode,0),FoundLong,-1);

              With Nom do
              Begin

                {$IFDEF EXSQL}
                if SQLUtils.UsingSQL and Assigned(MTExLocal) then
                  NomBal:=MTExLocal^.LProfit_To_Date(NomType,FullNomKey(NomCode),RCr,RYr,RPr,CrDr[BOff],CrDr[BOn],TmpCleared,BOn)
                else
                {$ENDIF}
                NomBal:=Profit_To_Date(NomType,FullNomKey(NomCode),RCr,RYr,RPr,CrDr[BOff],CrDr[BOn],TmpCleared,BOn);

                ClearedTotal:=TmpCleared;

                RCrDr[BOff]:=CrDr[BOff]; RCrDr[BOn]:=CrDr[BOn];
              {$IFDEF MC_On}

                RepTitle:=CurrDesc(RCr)+RepTitle;

              {$ELSE}

              {$ENDIF}

                PageTitle:=RepTitle+' of '+Desc+' at '+PoutDate(DueLimit)+' ('+PPR_OutPr(RPr,RYr)+')';
              end;

              If (ShowPIMode) then
                DDMList:=TDDMList.Create(TComponent(fMyOwner));

              RFnum:=IDetailF;

              RKeyPath:=IdNomK;


              If (ShowPIMode) then
                RepKey:=Strip('R',[#0],FullIdPostKey(ReconCode*DocNotCnst,0,PayInNomMode,RCr,0,0))
              else
                RepKey:=FullNomKey(ReconCode);  {* Mode 0 *}

              {RFont.Size:=7;}
            end;
      2,3
         :  Begin
              If (Debug) then
              Begin
                {RCr:=0;  RTxCr:=0;

                RPr:=1;  RYr:=Syss.CYr;

                RPr2:=Syss.CPr; RYr2:=Syss.CYr;

                NomToo:=MaxInt;

                FolEnd:=MaxInt;}

              end;

              QuoteMode:=((DocWanted=DocCodes[SQU]) or (DocWanted=DocCodes[PQU]));

              Case ReportMode of
                2  :  Begin
                        ThTitle:='G/L History Report';
                        RepTitle:='General Ledger History Report';
                      end;
                3  :  Begin
                        ThTitle:='Audit Trail';
                        RepTitle:=ThTitle;
                        RFont.Size:=7;  // MHYR
                      end;
              end; {Case..}


              {$IFDEF Ex32} {* This needs replacing with a scratch version *}
                If (Auto) and (AutoData<>NIL) then
                Begin
                  NomH3Ptr:=AutoData;

                  With NomH3Ptr^ do
                  Begin
                    ReconCode:=NNomToo[1]; NomToo:=NNomToo[2];

                    FolStart:=NNomToo[3]; FolEnd:=NNomToo[4];

                    RYr:=NYrF; RYr2:=NYrT;
                    RPr:=NPrF; RPr2:=NPrT;

                    RCr:=NCr; RTxCr:=NTxCr;

                    CustFilt:=NCFilt;

                    RCCDep:=NCCDep;  DocWanted:=NDocWant;

                    QuoteMode:=NQMode;

                  end; {With..}

                end;
                {$ENDIF}

              {$IFDEF MC_On}

                If (RTxCr<>0) and (RTxCr<>RCr) then
                  RepTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+RepTitle
                else
                  RepTitle:=CurrDesc(RCr)+RepTitle;

              {$ENDIF}

              If (ReportMode=3) then
                RepTitle2:='Folio : '+Form_Int(FolStart,0)+'-'+Form_Int(FolEnd,0)+'.'
              else
              Begin
                {$IFDEF SOP}
                   If (CommitAct) and (CommitMode In [1,2]) then
                     RepTitle2:=CommitTitle[CommitMode];


                {$ENDIF}

              end;

              If (CustFilt<>'') then
              Begin

                If (Assigned(MTExLocal)) then
                With MTExLocal^ do
                Begin
                  If LGetMainRec(CustF,CustFilt) then
                    RepTitle2:=RepTitle2+'For '+Strip('B',[#32],LCust.Company);
                end
                else
                Begin
                  GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);

                  RepTitle2:=RepTitle2+'For '+Strip('B',[#32],Cust.Company);
                end;
              end;

              If (DocWanted<>'') then
              Begin
                If (RepTitle2<>'') then
                  RepTitle2:=RepTitle2+', ';

                RepTitle2:=RepTitle2+'Document Filter : '+DocWanted;
              end;

              {$IFDEF PF_On}

                For BoLoop:=BOff to BOn do
                  If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then

                  Begin

                    FoundCode:=RCCDep[BoLoop];

                    CCTitle:='';

                    If (Assigned(MTExLocal)) then
                    With MTExLocal^ do
                    Begin
                      If LGetMainRec(PWrdF,FullCCKey(CostCCode,CSubCode[boLoop],FoundCode)) then
                        CCTitle:=LPassword.CostCtrRec.CCDesc;
                    end
                    else
                    Begin
                      GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                      CCTitle:=Password.CostCtrRec.CCDesc;
                    end;


                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+CCTitle;

                  end; {Loop..}


              {$ENDIF}

              If (ByDate) then
                PageTitle:=RepTitle+' ('+POutDate(SDate)+' - '+POutDate(EDate)+')'
              else
                PageTitle:=RepTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')';

              RFnum:=IDetailF;

              RepLen:=256;

              If (ReportMode<>3) then
              Begin
                If (Not QuoteMode) then
                Begin
                  RKeyPath:=IdNomK;

                  RepKey:=FullNomKey(ReconCode);  {* Mode 0 *}
                end
                else
                Begin
                  RKeyPath:=IdRunK;

                  RepKey:=FullNomKey(0)+FullNomKey(1);  {* By Pass Desc Only *}
                end;
              end
              else
              Begin
                RKeyPath:=IdFolioK;

                RepKey:=FullNomKey(FolStart);
              end;

              {$IFDEF REPPFC}
                If (ReportMode = 2) Then
                Begin
                  UseSQLPrefillCache := UsingSQLAlternateFuncs;
                  If UseSQLPrefillCache Then
                  Begin
                    // Duplicate the filtering effect caused by the Manual Key index n Btrieve
                    SQLWhereClause := '((tlGLCode > 0) And ((tlNominalMode <> 0) Or (tlYear <> 0) or (tlPeriod <> 0) or (tlCurrency <> 0)) And (tlRunNo <> 0))';

                    SQLWhereClause := SQLWhereClause + ' And (('  + ColName('f_id_doc_hed') + ' = ' + IntToStr(Ord(RUN)) +')';


                    sCompany := GetCompanyCode(SetDrive);
                    sColName := ColName('f_run_no', 'Document.Dat');
                    SQLWhereClause := SQLWhereClause + ' Or (' + ColName('f_folio_ref') + ' In (Select Distinct ' + ColName('f_folio_num', 'Document.Dat') + ' ' +
                                                                                                'From ' + sCompany + '.Document ' +
                                                                                                'Where (' + sColName + ' > 0)';

                    If QuoteMode Then
                      SQLWhereClause := SQLWhereClause + ' Or ((' + sColName + ' = 0) And (' + ColName('f_folio_num', 'Document.Dat') + ' <> 0))';

                    SQLWhereClause := SQLWhereClause + ')))';

                    {$IFDEF SOP}
                    If CommitAct And (CommitMode In [0, 1, 2]) Then
                    Begin
                      // Commitment Accounting
                      Case CommitMode Of
                        0 : SQLWhereClause := SQLWhereClause + ' And ( (' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ') ' +
                                                                     'Or ' +
                                                                     '(' + ColName('f_posted_run') + ' <> ' + IntToStr(Ord(CommitOrdRunNo)) + ')' +
                                                                   ')';

                        // MH 31/07/08: Removed this as was incorrectly excluding RUN lines - don't want to do any additional checks for CommitMode = 1
                        1 : ; //SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ')';

                        2 : SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_posted_run') + ' = ' + IntToStr(Ord(CommitOrdRunNo)) + ')';
                      End; // Case CommitMode
                    End; // If CommitAct And (CommitMode In [0, 1, 2])
                    {$ENDIF}

                    SQLWhereClause := SQLWhereClause + ' And (((' + ColName('f_id_doc_hed') + ' = ' + IntToStr(Ord(RUN)) + ') And ' +
                                                              '(' + ColName('f_currency') + ' = ' + IntToStr(RCr) + ') And ' +
                                                              '(' + ColName('f_posted_run') + ' > 0)) ' +
                                                             'Or ' +
                                                             '(' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ')';
                    If (CommitMode In [1,2]) Then
                    Begin
                      SQLWhereClause := SQLWhereClause +   ' Or ' +
                                                            '(' + ColName('f_posted_run') + ' = ' + IntToStr(Ord(CommitOrdRunNo)) + ')';
                    End; // If (CommitMode In [1,2]
                    SQLWhereClause := SQLWhereClause +     ')';

                    If (ReconCode <> 0) Or (NomToo <> MaxInt) Then
                    Begin
                      sColName := ColName('f_nom_code');
                      SQLWhereClause := SQLWhereClause + ' And ((' + IntToStr(ReconCode) + ' <= ' + sColName + ') And (' + sColName + ' <= ' + IntToStr(NomToo) + '))';
                    End; // If (ReconCode <> 0) Or (NomToo <> MaxInt)

                                  // Filter on Folio Number Range - Not used in GL History Report
//                                  and
//                                  (
//                                    (
//                                      (FolioRef>=FolStart)
//                                      and
//                                      (FolioRef<=FolEnd)
//                                    )
//                                    or
//                                    (ReportMode<>3)
//                                  )

                    If (Not ByDate) Then
                    Begin
                      // Check Period Range filter
                      SQLWhereClause := SQLWhereClause + ' And (' +
                                                               '(((' + ColName('f_p_yr') + ' = ' + IntToStr(RYr) + ') And (' + ColName('f_p_pr') + ' >= ' + IntToStr(RPr) + ')) Or (' + ColName('f_p_yr') + ' > ' + IntToStr(RYr) + ')) ' +
                                                               'And ' +
                                                               '(((' + ColName('f_p_yr') + ' = ' + IntToStr(RYr2) + ') And (' + ColName('f_p_pr') + ' <= ' + IntToStr(RPr2) + ')) Or (' + ColName('f_p_yr') + ' < ' + IntToStr(RYr2) + '))' +
                                                              ')';
                    End // If (Not ByDate)
                    Else
                    Begin
                      // Date Range
                      SQLWhereClause := SQLWhereClause + ' And ((' + QuotedStr(SDate) + ' <= ' + ColName('f_p_date') + ') And (' + ColName('f_p_date') + ' <= ' + QuotedStr(EDate) + '))';
                    End; // Else

                    If (RCr <> 0) Then
                    Begin
                      // Filter on Currency
                      SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_currency') + ' = ' + IntToStr(Rcr) + ')';
                    End; // If (RCr <> 0)

                    If (Trim(CustFilt) <> '') Then
                    Begin
                      // Filter by Account Code
                      SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_folio_ref') + ' In (Select Distinct ' + ColName('f_folio_num', 'Document.Dat') + ' ' +
                                                                                                  'From ' + sCompany + '.Document ' +
                                                                                                  'Where (' + ColName('f_cust_code', 'Document.Dat') + ' = '  + QuotedStr(CustFilt) + ')))';
                    End; // If (Trim(CustFilt) <> '')

                    // Filter on Document Type
                    If (Trim(DocWanted) <> '') Then
                    Begin
                      SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_folio_ref') + ' In (Select Distinct ' + ColName('f_folio_num', 'Document.Dat') + ' ' +
                                                                                                  'From ' + sCompany + '.Document ' +
                                                                                                  'Where (' + ColName('f_our_ref', 'Document.Dat') + ' LIKE ' + QuotedStr(Trim(DocWanted) + '%') + ')))';
                    End; // If (Trim(DocWanted) <> '')

                    SQLColumns := GetAllDetailsFields;
                  End; // If UseSQLPrefillCache
                End; // If (ReportMode = 2)
              {$ENDIF}



              {RFont.Size:=7;}
              ROrient:=RPDefine.PoLandscape;
            end;

      5  :  Begin

              If (Debug) then
              Begin
                RCr:=0;

              end;

              LastDocType:=ResetKey;

	      ThTitle:='Doc Post Report';
              RepTitle:='Document Posting Report';

              GetPostMode(PMode,DayBkFlt);

              If (NomToo=0) then
                RepTitle:=RepTitle+' - Unposted Items '
              else
                RepTitle:=RepTitle+' - Run '+Form_Int(NomToo,1);

              PageTitle:=RepTitle;


              RFnum:=InvF;

              RKeyPath:=InvRNoK;

              RepKey:=FullNomKey(NomToo);

              RepLenCnst:=Length(RepKey);

              RepLen:=257;

              RepKey:=RepKey+'A'; {* Bias this key to avoid any corruption caused by incomplete docs *}

              RFont.Size:=8;
              ROrient:=RPDefine.PoLandscape;

            end;

      7
         :  Begin

              If (Debug) then
              Begin
                {RCr:=0;

                RPr:=1;  RYr:=Syss.CYr;

                RPr2:=Syss.CPr; RYr2:=Syss.CYr;

                ReconCode:=0;

                NomToo:=MaxInt;
                DocWanted:='';}
              end;

              ReconCode:=FolStart;
              NomToo:=FolEnd;

              ThTitle:='Doc Audit Trail';
              RepTitle:='Document Audit Trail';





              {$IFDEF MC_On}

                PageTitle:=CurrDesc(RCr)+RepTitle;

              {$ENDIF}

              RepTitle2:='Folio : '+Form_Int(ReconCode,0)+'-'+Form_Int(NomToo,0)+'.';

              If (CustFilt<>'') then
              Begin
                {$IFDEF EXSQL}
                If SQLUtils.UsingSQL and (Assigned(MTExLocal)) then
                With MTExLocal^ do
                Begin
                  If LGetMainRec(CustF,CustFilt) then
                    RepTitle2:=RepTitle2+'For '+Strip('B',[#32],LCust.Company);
                end
                else
                {$ENDIF}
                begin
                  GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);

                  RepTitle2:=RepTitle2+'For '+Strip('B',[#32],Cust.Company);
                end;

              end;

              If (DocWanted<>'') then
              Begin
                If (RepTitle2<>'') then
                  RepTitle2:=RepTitle2+', ';

                RepTitle2:=RepTitle2+'Document Filter : '+DocWanted;
              end;



              PageTitle:=PageTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')';

              RFnum:=InvF;

              RKeyPath:=InvFolioK;

              RepKey:=FullNomKey(ReconCode);
              RepLen:=256;

              ROrient:=RPDefine.PoLandscape;
            end;

       8..9,11..12
          : Begin

              If (Debug) then
              Begin
                {RCr:=0;  RTxCr:=0;

                RPr:=1;  RYr:=Syss.CYr;

                RPr2:=Syss.CPr; RYr2:=Syss.CYr;

                DocWanted:='';

                ReportMode:=ReportMode+3;}

              end;

              ThTitle:=Copy(TradeType[(ReportMode In [8,11])],1,4)+' Trading Hist Report';

              RepTitle:=TradeType[(ReportMode In [8,11])]+' Trading History Report';


              {$IFDEF EX32}
              With RepCtrl^ do
              Begin
                Pg1Len:=40; Pg2Len:=50;

                If (Auto) and (AutoData<>NIL) then
                Begin
                  NomH3Ptr:=AutoData;

                  With NomH3Ptr^ do
                  Begin

                    RYr:=NYrF; RYr2:=NYrT;
                    RPr:=NPrF; RPr2:=NPrT;

                    RCr:=NCr; RTxCr:=NTxCr;

                    CustFilt:=NCFilt;

                    RCCDep:=NCCDep;  DocWanted:=NDocWant;

                    CMode:=CMode+(2*Ord(NQMode));

                  end; {With..}

                end;

              end;
              {$ENDIF}

              If (ReportMode>9) then
                PageTitle:='Summary '+RepTitle
              else
                PageTitle:=RepTitle;

              {$IFDEF MC_On}

                If (RTxCr<>0) and (RTxCr<>RCr) then
                  PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
                else
                  PageTitle:=CurrDesc(RCr)+PageTitle;

              {$ENDIF}

              If (CustFilt<>'') then
              Begin
                {$IFDEF EXSQL}
                If SQLUtils.UsingSQL and (Assigned(MTExLocal)) then
                With MTExLocal^ do
                Begin
                  If LGetMainRec(CustF,CustFilt) then
                    RepTitle2:=RepTitle2+'For '+Strip('B',[#32],LCust.Company);
                end
                else
                {$ENDIF}
                begin
                  GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);

                  RepTitle2:='For '+Strip('B',[#32],Cust.Company);
                end;
              end;

              If (DocWanted<>'') then
              Begin
                If (RepTitle2<>'') then
                  RepTitle2:=RepTitle2+', ';

                RepTitle2:=RepTitle2+'Document Filter : '+DocWanted;
              end;

              {$IFDEF PF_On}

                For BoLoop:=BOff to BOn do
                  If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
                  Begin

                    FoundCode:=RCCDep[BoLoop];

                    {$IFDEF EXSQL}
                    If SQLUtils.UsingSQL and (Assigned(MTExLocal)) then
                    With MTExLocal^ do
                    Begin
                      If LGetMainRec(PWrdF,FullCCKey(CostCCode,CSubCode[boLoop],FoundCode)) then
                        CCTitle:=LPassword.CostCtrRec.CCDesc;
                    end
                    else
                    {$ENDIF}
                      GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;
                  end; {Loop..}


              {$ENDIF}

              PageTitle:=PageTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')';

              ROrient:=RPDefine.PoLandscape;

              Case ReportMode of

                8,9  :  Begin
                          RFnum:=InvF;

                          RKeyPath:=InvCustK;

                          If (CustFilt='') then
                          Begin
                            RepKey:='!'; {* Jump Nom Txfr & Adjustments *}
                            RepLen:=256;
                          end
                          else
                            RepKey:=FullCustType(CustFilt,TradeCode[(ReportMode=8)]);

                        end;


                11,12:  Begin
                          RFnum:=CustF;

                          RKeyPath:=CustCodeK;

                          RepKey:=CustFilt;

                          // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer support to Customer Trading History Report (8) and Summary Report (11)
                          If (ReportMode = 11) And (CustFilt = '') Then
                          Begin
                            Case IncludeAccountTypes Of
                              atCustomersAndConsumers : Begin
                                                          // Switch to CustSupp+Code index and specify correct CustSupp key
                                                          RKeyPath := ATCodeK;
                                                          RepKey := TradeCode[BOn]; // CustSupp='C'
                                                        End; // atCustomersOnly
                              atCustomersOnly         : Begin
                                                          // Switch to SubType+Code index and specify correct subtype key
                                                          RKeyPath := CustACCodeK;
                                                          RepKey := ConsumerUtils.CUSTOMER_CHAR;  // SubType='C'
                                                        End; // atCustomersOnly
                              atConsumersOnly         : Begin
                                                          // Switch to SubType+Code index and specify correct subtype key
                                                          RKeyPath := CustACCodeK;
                                                          RepKey := ConsumerUtils.CONSUMER_CHAR;  // SubType='U'
                                                        End; // atConsumersOnly
                            Else
                              Raise Exception.Create ('TDocReport.GetReportInput: Unhandled Account Type setting (' + IntToStr(Ord(IncludeAccountTypes)) + ')');
                            End; // Case IncludeAccountTypes
                            RepLen := Length(RepKey);
                          End; // If (ReportMode = 11) And (CustFilt = '')
                        end;
              end; {Case..}

              RFont.Size:=7;  // MHYR
            end;

    end; {Case..}
  end; {With..}

  Result:=BOn;
end;





Procedure TDocReport.Finish;


Begin
  Inherited Finish;
end;


{ ======== }



Procedure AddDocRep2Thread(LMode    :  Byte;
                           IMode    :  Byte;
                           IRepParam:  DocRepPtr;
                           AOwner   :  TObject);

  Begin
    AddCCDepReportThread(LMode,IMode,IRepParam,AOwner);

  end;


{$IFDEF OLDVERSION}{Pre auto report}

  Var
    EntTest  :  ^TDocReport;

  Begin

    If (Create_BackThread) then
    Begin

      New(EntTest,Create(AOwner));

      try
        With EntTest^ do
        Begin
          ReportMode:=LMode;
          PMode:=IMode;

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
{$ENDIF}




Initialization


Finalization

end.