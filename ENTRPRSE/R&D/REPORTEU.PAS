unit ReportEU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TSHistReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintSOCBal(SType  :  Char;
                                             SFolio :  LongInt;
                                             LocFilt:  Str10;
                                             Rcr,
                                             NYr,NPr  :  Byte;
                                             CloseBal :  Boolean);

                       Procedure PrintDueTot(Gtot      :  Boolean);

                       Procedure CalcDueTotals(LTot      :  Totals);

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  SHistRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddSHistRep2Thread(LMode    :  Byte;
                             IRepParam:  SHistRepPtr;
                             AOwner   :  TObject);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  VarRec2U,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  InvListU,
  RpDefine,
  {$IFDEF Inv}
    InvCTSuU,
  {$ENDIF}

  {$IFDEF REPPFC}
    SQLUtils,
    SQLFields,
    SavePos,
  {$ENDIF}

  ExThrd2U;


{ ========== TSHistReport methods =========== }

Constructor TSHistReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

end;


Destructor TSHistReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;







Procedure TSHistReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
            end;

        2 :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 47{22}, 4, 0, 0);  // MHYR
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 47, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;





Procedure TSHistReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  SendLine(ConCat(#9'Stock',' ','Code',#9,'Description',#9,'Qty',' ','Sold',#9,
                    'Sales',' ','Value',#9,'Cost',' ','Value',#9,'In',' ','(+)',#9,'Out',' ',
                    '(-)'));



      2   :  SendLine(ConCat(#9,'Our',' ','Ref',#9,'Your',' ','Ref',#9,'Per/Yr',#9,'Date',#9,'A/C',
                             ' ','No.',#9,#9,'Qty',' ','Sold',#9,'Sales',' ','Value',#9,'Cost',' ','Value',#9,
                             'In',' ','(+)',#9,'Out'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TSHistReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1,CRepParam^ do
  Case ReportMode of
      2  :  If (CurrentPage>1) then
              PrintStkLine(LastStk,BOn);

  end; {Case..}

end;


Procedure TSHistReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^  do
  Begin
    Case DDMode of

      0  :  SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

      1  :  Begin
              SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);
              SendRepDrillDown(5,6,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);

            end;


    end; {Case..}
  end; {With..}
end;



{ ======================= Get Opening & Closing Balances & Print them =================== }

Procedure TSHistReport.PrintSOCBal(SType  :  Char;
                                   SFolio :  LongInt;
                                   Locfilt:  Str10;
                                   Rcr,
                                   NYr,NPr  :  Byte;
                                   CloseBal :  Boolean);


Const
  OBalStr  :  Array[BOff..BOn] of Str50 = ('Opening','Closing');


Var
  Purch,Sales,Cleared,
  PostBal  :  Double;

  TmpStatus
           :  Integer;


Begin
  With MTExLocal^, RepFiler1 do
  Begin
    If (Not CloseBal) then
      AdjPr(Nyr,NPr,CloseBal);


    TmpStatus:=LStatus;

    PostBal:=LProfit_To_Date(SType,CalcKeyHist(SFolio,LocFilt),RCr,NYr,NPr,Purch,Sales,Cleared,BOn);


    SetReportDrillDown(0);

    SendLine(ConCat(#9,OBalStr[CloseBal]+' Stock',ConstStr(#9,9),
                    FormatFloat(GenQtyMask,Cleared)));


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

Procedure TSHistReport.PrintDueTot(Gtot      :  Boolean);

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

              LGetMainRec(StockF,LastStk);

              SetReportDrillDown(0);

              SendText(ConCat(#9,LStock.StockCode,
                       #9,LStock.Desc[1]));

            end
            else
            Begin

              SendText(ConCat(#9,'Totals:'));

              StkTot:=RepTotal;

            end;


            SendLine(ConCat(ConstStr(#9,3),FormatFloat(GenQtyMask,StKTot[1]),
                            #9,FormatFloat(GenRealMask,StKTot[2]),
                            #9,FormatFloat(GenRealMask,StKTot[3]),
                            #9,FormatFloat(GenQtyMask,StKTot[4]),
                            #9,FormatFloat(GenQtyMask,StKTot[5])));

            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}

   2
       :  Begin
            If (Not Gtot) then
            Begin
              DefLine(-1,TabStart(6),TabEnd(11),0);

              LGetMainRec(StockF,LastStk);

              SetReportDrillDown(0);

            end
            else
              StkTot:=RepTotal;



            SendLine(ConCat(ConstStr(#9,6),'Totals:',
                            #9,FormatFloat(GenQtyMask,StKTot[1]),
                            #9,FormatFloat(GenRealMask,StKTot[2]),
                            #9,FormatFloat(GenRealMask,StKTot[3]),
                            #9,FormatFloat(GenQtyMask,StKTot[4]),
                            #9,FormatFloat(GenQtyMask,StKTot[5])));


            If (Not Gtot) then
            Begin
              DefLine(-2,TabStart(6),TabEnd(11),0);

              If (ShowOCbal) then
                 With LStock do
                   PrintSOCBal(Calc_AltStkHCode(StockType),StockFolio,LocFilt,RCr,RYr2,RPr2,BOn);


            end;


            Blank(STKTot,Sizeof(StkTot));

          end; {Case..}


  end; {Case..With..}

end;


{ ======================= Calculate Due Totals ==================== }

Procedure TSHistReport.CalcDueTotals(LTot      :  Totals);

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









{ ======================= Customer Line ======================= }


Procedure TSHistReport.PrintReportLine;

Var
  Rnum,
  Rnum2      :  Real;

  n,UOR      :  Byte;

  LineTot    :  Totals;

  TBo        :  Boolean;

  StockPos   :  StockPosType;

  YRefStr    :  Str255;

  CostRates  :  CurrTypes;


Begin

  Rnum:=0;

  Rnum2:=0;

  YRefStr:='';  UOR:=0;

  Blank(LineTot,Sizeof(LineTot));

  Blank(StockPos,Sizeof(StockPos));

  Blank(CostRates,Sizeof(CostRates));

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Case ReportMode of
      1,2    :  With LId do
                 If (StockCode<>LastStk) then
                 Begin
                   If (LastStk<>'') then
                     PrintDueTot(BOff);

                   LastStk:=StockCode;

                   If (ReportMode=2) then
                   Begin
                     PrintStkLine(StockCode,BOff);

                     If (ShowOCbal) then
                       With LStock do
                       Begin
                         If (LStock.StockCode<>LId.StockCode) then
                           LGetMainRec(StockF,LId.StockCode);


                         PrintSOCBal(Calc_AltStkHCode(StockType),StockFolio,LocFilt,RCr,RYr,RPr,BOff);

                       end;
                   end;

                 end;


    end; {Case..}

    With LId do
    Begin



      Rnum2:=(Qty*QtyMul)*StkAdjCnst[IdDocHed]*DocNotCnst;

      If (IdDocHed In StkAdjSplit) then
        Rnum:=CostPrice*Rnum2*DocNotCnst
      else
        Rnum:=DetLTotal(LId,BOn,BOff,0.0)*DocCnst[IdDocHed];


      If (RCr=0) then
      Begin
        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        Rnum:=Round_Up(Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
      end;

      Rnum:=Currency_Txlate(Rnum,RCr,RTxCr);


      {$IFDEF Inv}

        Stock_Effect(StockPos,LId,DeductQty,BOn);

        {$IFDEF PF_On}

          Job_StockEffect(StockPos,LId);

        {$ENDIF}


      {$ENDIF}

      
      If (IdDocHed In SalesSplit) then
      Begin

        If (Rnum2<0) then  {* This added calculation needed as credit notes not correctly signed *}
          Rnum:=Rnum*DocNotCnst;

        LineTot[1]:=Rnum2;

        LineTot[2]:=Rnum;

        LineTot[3]:=Calc_IdQty(Qty,QtyMul,UsePack)*CostPrice;

        If (RCr=0) then
        Begin
          UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

          If (IdDocHed In SalesSplit) then {* We need to convert using the original rate *}
          Begin
            CostRates:=LInv.OrigRates;

            If (COSConvRate<>0.0) then
              CostRates[UseCoDayRate]:=COSConvRate;
          end
          else
            CostRates:=CXRate;

          LineTot[3]:=Round_Up(Conv_TCurr(LineTot[3],XRate(CostRates,BOff,Currency),Currency,UOR,BOff),2);
        end;

        LineTot[3]:=Currency_Txlate(LineTot[3],RCr,RTxCr);

        //AP:06/09/2017:2017-R12:ABSEXCH-19137 Stock History Report - Cost Value signage is incorrect for sales
        If (IdDocHed In StkDedSet) then
          LineTot[3] := LineTot[3]*DocNotCnst;

      end
      else
      Begin
        //AP:06/09/2017:2017-R12:ABSEXCH-19137 Stock History Report - Cost Value signage is incorrect for sales
        If (IdDocHed In StkDedSet+[PRF]) then
          Rnum:=Rnum*DocNotCnst;

          LineTot[3]:=Rnum;
      end;

      LineTot[4]:=StockPos[1];
      LineTot[5]:=StockPos[2];

    end; {With..}


    If (Not Summary) then
      SetReportDrillDown(1);

    Case ReportMode of

      2
          : Begin
              {* Note Use of PPr_Pr/Yr *}

              If (LId.IDDocHed=ADJ) then
                YRefStr:=LInv.TransDesc
              else
                YRefStr:=LInv.YourRef;

              SendLine(ConCat(#9,LInv.OurRef,
                       #9,YRefStr,
                       #9,PPR_OutPr(LId.PPr,LId.PYr),
                       #9,POutDateB(LInv.TransDate),
                       #9,LInv.CustCode,
                       #9,LCust.Company,
                       #9,FormatFloat(GenQtyMask,LineTot[1]),
                       #9,FormatFloat(GenRealMask,LineTot[2]),
                       #9,FormatFloat(GenRealMask,LineTot[3]),
                       #9,FormatFloat(GenQtyMask,LineTot[4]),
                       #9,FormatFloat(GenQtyMask,LineTot[5])));

            end;

    end; {Case..}


    CalcDueTotals(LineTot);
  end; {With..}
end;


{ ======================= Customer End ======================= }


Procedure TSHistReport.PrintEndPage;
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


Function TSHistReport.IncludeRecord  :  Boolean;


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

    If (ReportMode In [1,2]) then
    Begin
      LResetRec(Fnum);

      KeyS:=FullNomKey(LId.FolioRef);

      If (LId.FolioRef<>0) then
        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      LGetMainRec(StockF,LId.StockCode);
      LGetMainRec(CustF,LId.CustCode);
    end;


    Case ReportMode of

      1,2
           :  With LId  do
              Begin



                TmpInclude:=(((LInv.RunNo>0) or (LInv.RunNo=StkAdjRunNo) or (LInv.RunNo=PRNPRunNo) )
                             and (Not EmptyKey(LStock.StockCode,StkKeyLen))
                             and (((Pr2Fig(PYr,PPr)>=Pr2Fig(RYr,RPr)) and (Pr2Fig(PYr,PPr)<=Pr2Fig(RYr2,RPr2)))
                             or  ((PDate>=SDate) and (Pdate<=EDate)))
                             and ((RCr=Currency) or (RCr=0))
                             and ((LInv.CustCode=CustFilt) or (CustFilt=''))
                             and (CheckKey(DocWanted,DocCodes[IdDocHed],Length(DocWanted),BOff))
                             and (CheckKey(LocFilt,MLocStk,Length(LocFIlt),BOff))
                             and ((CheckKey(StkToo,LStock.StockCode,Length(StkToo),BOff)) or (Not SingProd)));


                If (TmpInclude) then
                Begin


                  {$IFDEF PF_On}

                    For DayRepInc:=BOff to BOn do
                      TmpInclude:=(TmpInclude
                                   and (CheckKey(RCCDep[DayRepInc],CCDep[DayRepInc],Length(RCCDep[DayRepInc]),BOff)));

                  {$ENDIF}

                  {* Establish if Opening/Closing balance needs to be shown *}

                  ShowOCbal:=((EmptyKey(CustFilt,CustKeyLen)) and (EmptyKey(DocWanted,DocKeyLen))
                              and (SDate='') and (Edate='') and (Not Summary));


                  {$IFDEF PF_On}

                    For DayRepInc:=BOff to BOn do
                      ShowOCbal:=(ShowOCbal
                                   and (EmptyKeyS(RCCDep[DayRepInc],CCKeyLen,BOff)));

                  {$ENDIF}

                  If (TmpInclude) then
                  Begin

                    If (Not SingProd) then
                      TmpInclude:=Stk_InGroup(StkToo,LStock);

                  end;
                end
                else
                Begin

                  If (SingProd) and (Not CheckKey(StkToo,LStock.StockCode,Length(StkToo),BOff)) then
                  Begin
                    KeyS:=NdxWeight;

                    B_Next:=B_GetEq;
                  end;
                end;




              end;

    end; {Case..}

  end; {With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TSHistReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;

  {$IFDEF REPPFC}
  sCompany : ShortString;
  sColName : ShortString;
  {$ENDIF}

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, '')
  End; // GetDBColumnName

  Function StockGroupFilter(ParentGroup, ColumnName : ShortString; Const Init : Boolean = True) : ANSIString;
  Var
    iStatus  : SmallInt;
    KeyS : Str255;
    sTemp : ANSIString;
  Begin // StockGroupFilter
    Result := '';

    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (StockF, GetPosKey);
        SaveDataBlock (@Stock, SizeOf(Stock));

        // Check Parent exists
        KeyS := FullStockCode(ParentGroup);
        iStatus := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCATK, KeyS);
        While (iStatus = 0) And (Stock.StockCat = ParentGroup) Do
        Begin
          If (Stock.StockType = StkGrpCode) Then
            // For Stock Groups run through their children
            sTemp := StockGroupFilter(Stock.StockCode, ColumnName, False)
          Else
            // Otherwise add stock item into Query
            sTemp := '(' + ColumnName + ' = ' + QuotedStr(Trim(Stock.StockCode)) + ')';

          If (Trim(sTemp) <> '') Then
          Begin
            If (Trim(Result) <> '') Then
              Result := Result + ' Or ';
            Result := Result + sTemp;
          End; // If (Trim(sTemp) <> '')

          iStatus := Find_Rec(B_GetNext, F[StockF], StockF, RecPtr[StockF]^, StkCATK, KeyS);
        End; // While (iStatus = 0) And (Stock.StockCat = ParentGroup)

        // Restore position in file
        RestoreDataBlock (@Stock);
        RestoreSavedPosition;
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create

    If Init And (Result <> '') Then
      Result := ' Where ' + Result;
  End; // StockGroupFilter
  {$ENDIF}

Begin
  With CRepParam^ do
  Begin
    ThTitle:='Stk Hist Rep';

    RepTitle:='Stock History Report';

    PageTitle:=RepTitle;

    RFont.Size:=7;

    RFnum:=IDetailF;

    RKeyPath:=IdStkK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;

    ReportMode:=ReportMode-Ord(Summary);

    If (Not Summary) then
      ROrient:=RPDefine.PoLandscape;


    If (SDate='') then
      PageTitle:=RepTitle+' ('+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2)+')'
    else
      PageTitle:=RepTitle+' ('+PoutDate(Sdate)+' - '+PoutDate(EDate)+')';



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

     If (Not EmptyKey(StkToo,StkKeyLen)) then
     Begin
       GetStock(Application.MainForm,StkToo,FoundCode,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Stock Filter : '+dbFormatName(StkToo,Stock.Desc[1]);

       SingProd:=(Stock.StockType<>StkGrpCode);
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

           GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

           If (RepTitle2<>'') then
             RepTitle2:=RepTitle2+', ';

           RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

         end; {Loop..}


     {$ENDIF}

     {$IFDEF SOP}
        If (Not EmptyKey(LocFilt,LocKeyLen)) then
        Begin
          If (RepTitle2<>'') then
            RepTitle2:=RepTitle2+', ';

          RepTitle2:=RepTitle2+MLocRepTitle(LocFilt);
        end;
     {$ENDIF}

     If (Not SingProd) or (EmptyKey(StkToo,StkKeyLen)) then
     Begin
       RepKey:=' ';

       RepLen:=256;
     end
     else
       RepKey:=StkToo;

     {$IFDEF REPPFC}
       UseSQLPrefillCache := UsingSQLAlternateFuncs;
       If UseSQLPrefillCache Then
       Begin
         sCompany := GetCompanyCode(SetDrive);
         sColName := ColName('f_run_no', 'Document.Dat');
         SQLWhereClause := '(' + ColName('f_folio_ref') + ' In (Select Distinct ' + ColName('f_folio_num', 'Document.Dat') + ' ' +
                                                               'From ' + sCompany + '.Document ' +
                                                               'Where ((' + sColName + ' > 0) Or (' + sColName + ' = -30) Or (' + sColName + ' = -129))';

         If (Trim(CustFilt) <> '') Then
           // Add filter on Account Code
// MH 21/05/08: GetDBColumName doesn't support Computed Columns at this time
           //SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_cust_code', 'Document.Dat') + ' = ' + QuotedStr(CustFilt) + ')';
           SQLWhereClause := SQLWhereClause + ' And (thAcCodeComputed = ' + QuotedStr(CustFilt) + ')';

         // Check Document Type Filter
         If (Trim(DocWanted) <> '') Then
         Begin
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_our_ref', 'Document.Dat') + ' LIKE ' + QuotedStr(Trim(DocWanted) + '%') + ')';
         End; // If (Trim(DocWanted) <> '')

         SQLWhereClause := SQLWhereClause + '))';

         // Stock Code must exist - must try to load Stock Record to prove its a valid stock code
         // as other things are stored in the Stock Code field which aren't anything to do with Stock
         sColName := ColName('f_stock_code', 'Stock.Dat');
         SQLWhereClause := SQLWhereClause + ' And (SubString(' + ColName('f_stock_code') + ',2, 16) In (Select ' + sColName + ' From ' + sCompany + '.Stock';

         If (Trim(StkToo) <> '') Then
         Begin
           If SingProd Then
             // Filter by Stock Code as well
             SQLWhereClause := SQLWhereClause + ' Where (' + sColName + ' = ' + QuotedStr(Trim(StkToo)) + ')'
           Else
             // Get list of stock codes within the stock group
             SQLWhereClause := SQLWhereClause + StockGroupFilter(StkToo, sColName);
         End; // If (Trim(StkToo) <> '')

         SQLWhereClause := SQLWhereClause + '))';

         // Check Period and Year
         SQLWhereClause := SQLWhereClause + ' And ((' +
                                                   '(((' + ColName('f_p_yr') + ' = ' + IntToStr(RYr) + ') And (' + ColName('f_p_pr') + ' >= ' + IntToStr(RPr) + ')) Or (' + ColName('f_p_yr') + ' > ' + IntToStr(RYr) + '))' +
                                                   ' And ' +
                                                   '(((' + ColName('f_p_yr') + ' = ' + IntToStr(RYr2) + ') And (' + ColName('f_p_pr') + ' <= ' + IntToStr(RPr2) + ')) Or (' + ColName('f_p_yr') + ' < ' + IntToStr(RYr2) + '))' +
                                                  ')' +
                                                  ' Or ' +
                                                  '((' + QuotedStr(SDate) + ' <= ' + ColName('f_p_date') + ') And (' + ColName('f_p_date') + ' <= ' + QuotedStr(EDate) + '))' +
                                                 ')';

         // Check Currency
         If (RCr <> 0) Then
         Begin
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_currency') + ' = ' + IntToStr(Rcr) + ')';
         End; // If (RCr <> 0)

         // Check Location Filter
         If (Trim(LocFilt) <> '') Then
         Begin
           SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_m_loc_stk') + ' = ' + QuotedStr(LocFilt) + ')';
         End; // If (Trim(LocFilt) <> '')

         SQLColumns := GetAllDetailsFields;
       End; // If UseSQLPrefillCache
     {$ENDIF} // REPPFC
  end; {With..}

  Result:=BOn;
end;




Procedure TSHistReport.Process;

Begin
  Inherited Process;

end;


Procedure TSHistReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddSHistRep2Thread(LMode    :  Byte;
                             IRepParam:  SHistRepPtr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TSHistReport;

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
