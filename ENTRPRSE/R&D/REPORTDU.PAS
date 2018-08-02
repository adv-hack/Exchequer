unit ReportDU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU;


type



  TSListReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       ValMode  :  Byte;

                       ThisScrt :  Scratch2Ptr;

                       Procedure RepSetValTabs;

                       Procedure RepPrintPageHeader2;

                       Procedure VCalcStkTotals(StkVal    :  Real);

                       Procedure VPrintStkTot;

                       Procedure StkEnd;

                       Function StkInclude  :  Boolean;

                       Procedure AgeStock(TDate,RDate  :  LongDate;
                                      Var nDays,
                                          nMonths      :  Integer;
                                      Var nYears       :  Double);

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure StkLine;

                       Function Find_LastAverage(SCode      :  Str20;
                                                 AsAtDate   :  LongDate)  :  Boolean;

                       Procedure PrintValDetail(StkAgingMode  :  Byte);

                       Procedure PrintStockTot(GMode     :  Byte);

                       Procedure CalcStkTotals(StkVal,
                                               QtyVal    :  Real);

                       Procedure Build_SVReport(Var AbortPrint :  Boolean);

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  SListRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Function RetSVGL(StockR  :  StockRec)  :  LongInt;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddSListRep2Thread(LMode    :  Byte;
                             IRepParam:  SListRepPtr;
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
  VarRec2U,
  BTKeys1U,
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

  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}

  {$IFDEF POST}
    ReValueU,
  {$ENDIF}

  {$IFDEF REPPFC}
    SQLUtils,
    SQLFuncs,
  {$ELSE}
    {$IFDEF EXSQL}
      SQLUtils,
    {$ENDIF}
  {$ENDIF}



  RpDefine,
  ExThrd2U,
  BtSupU2;


{ ========== TSListReport methods =========== }

Constructor TSListReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ValMode:=0;

  ThisScrt:=Nil;
end;


Destructor TSListReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TSListReport.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ValMode of

        9 :  Begin
              SetTab (MarginLeft+29, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
             end;

        10:  Begin
               SetTab (MarginLeft+29, pjLeft, 45, 4, 0, 0);
               SetTab (NA, pjLeft, 20, 4, 0, 0);
               SetTab (NA, pjLeft, 13, 4, 0, 0);
               SetTab (NA, pjLeft, 15, 4, 0, 0);
               SetTab (NA, pjLeft, 20, 4, 0, 0);
               SetTab (NA, pjRight, 29, 4, 0, 0);
             end;


        29..31
         :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 25, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 15, 4, 0, 0);
              SetTab (NA, pjRight, 15, 4, 0, 0);
             end;

      59,60
         :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 16, 4, 0, 0);
             end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TSListReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
            end;

        2 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 16, 4, 0, 0);
            end;

        3 :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report
        //- Posted runs blank to screen and excel
        4,5,44
         :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TSListReport.RepPrintPageHeader2;


Begin
  RepSetValTabs;

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ValMode of

      9
          :  Begin
               SendLine(ConCat(#9'Our',' ','Ref',#9,'Acc',' ','No',#9,'Locn',#9,'Qty',#9,'In',' ','Stk',#9,
                              'U/Cost',#9,'Value'));

               DefLine(-1,TabStart(1),TabEnd(7),0);
             end;



      10
          :  Begin
               SendLine(ConCat(#9,'Serial',' ','No.',#9,'Batch',' ','No.',#9,'Locn',#9,'Bin',#9,'Use by date',#9,'Value'));

               DefLine(-1,TabStart(1),TabEnd(6),0);
             end;


      29..31
          :  Begin
               SendLine(ConCat(#9'Our',' ','Ref',#9,'Serial/Batch No.',#9,'Locn',#9,'Qty In Stk',#9,
                              'U/Cost',#9,'Total Cost',#9,'Date',#9,'Age - Days',#9,'Months',#9,'Years'));

               DefLine(-1,TabStart(1),TabEnd(10),0);
             end;

      59,60
         :  Begin
              SendLine(ConCat(#9,'Bin',' ','Locn',#9,'Stock',' ','Code',#9,'Description',#9,'UOM',#9,
                   'In',' ','Stk',#9,'Actual',#9,'Diff.'));
            end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}



Procedure TSListReport.VCalcStkTotals(StkVal    :  Real);

  Var
    nBo        :  Boolean;
    Rnum       :  Real;

  Begin

    Rnum:=0;

    With CRepParam^ do
    Case ValMode of

      9,10,29..31,59,60
             :  Begin

                  VBSTot:=VBSTot+StkVal;

                  VRepTot:=VRepTot+StkVal;

                end;

    end; {Case..With..}
  end;






  { ======================= Due Sub / Grand Total ================ }

  Procedure TSListReport.VPrintStkTot;

  Var
    n          :  Byte;


  Begin

    With RepFiler1,CRepParam^ do
    Case ValMode of
      9,10,29..31
         :  Begin
              n:=ValMode;

              Case ValMode of
                29..31  :  ValMode:=29;
                else       ValMode:=9;
              end; {Case..}

              RepSetValTabs;

              DefLine(-1,TabStart(1),TabEnd(7+(3*Ord(ValMode=29))),0);

              SetReportDrillDown(0);

              Case ValMode of
                9  :  SendLine(ConCat(#9,'Total',' ','in',' ','Stock:',
                                      #9,#9,#9,#9,FormatFloat(GenQtyMask,VBSTot)));
                else  SendLine(ConCat(#9,'Total',' ','in',' ','Stock:',
                                      #9,#9,#9,FormatFloat(GenQtyMask,VBSTot)));
              end;

              ValMode:=n;
              RepSetValTabs;

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end; {Case..}



    end; {Case..}

  end;




  { ======================= Due End ======================= }


  Procedure TSListReport.StkEnd;

  Var
    KitEnd     :  Str255;

    n,m        :  Byte;

  Begin

    With RepFiler1, CRepParam^ do
    Begin

      Case ValMode of

        9,10,29..31
               :  Begin

                    VPrintStkTot;

                    RepSetTabs;

                  end;
      end; {Case..}
    end; {With..}
  end;




  { ======================= Due Include ======================= }


  Function TSListReport.StkInclude  :  Boolean;


  Var
    TmpInclude :  Boolean;
    DayRepInc  :  Boolean;

    ChkRecon   :  Byte;

    KeyS2      :  Str255;


  Begin
    TmpINclude := False;
    {$B-}

    With MTExLocal^, CRepParam^, RepFiler1 do
    Begin
      Case ValMode of

          9,29
               :  With LMiscRecs^.FIFORec do
                  Begin

                    TmpInclude:=((QtyLeft<>0) and
                                 CheckKey(LocFilt,FIFOMLoc,Length(LocFilt),BOff));


                  end;

          10,30
               :  With LMiscRecs^.SerialRec do
                  Begin

                    TmpInclude:=((Not Sold) and
                                 CheckKey(LocFilt,InMLoc,Length(LocFilt),BOff));


                  end;

           31  :  TmpIncLude:=Find_LastAverage(LStock.StockCode,StkAgeDate);

         59,60
             :  With LMLocCtrl^.brBinRec do
                Begin

                  TmpInclude:=((Not brSold) and
                               CheckKey(LocFilt,brInMLoc,Length(LocFilt),BOff));


                end;


        end; {Case..}



      end; {With..}

      {$B+}



      StkInclude:=TmpInclude;
  end; {Func..}

  {== Work out the difference in days weeks & months ==}

  Procedure TSListReport.AgeStock(TDate,RDate  :  LongDate;
                              Var nDays,
                                  nMonths      :  Integer;
                              Var nYears       :  Double);


  Begin
    nDays:=NoDays(TDate,RDate);
    nMonths:=MonthDiff(TDate,RDate);

    nYears:=DivwChk(nMonths,12);
  end;


Procedure TSListReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    If (DDMode=0) or (ValMode In [59,60]) then
      SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

    If (DDMode=1) then
    Case ValMode of
      9,29  :  With LMiscRecs^.FIFORec do
               Begin
                 SendRepDrillDown(1,TotTabs,1,DocRef,InvF,InvOurRefK,0);

                 If (ValMode=9) then
                   SendRepDrillDown(2,2,2,FullCustCode(FIFOCust),CustF,CustCodeK,0);
               end;
      10,30
            :  With LMiscRecs^.SerialRec do
               Begin
                 SendRepDrillDown(1,TotTabs,1,InDoc,InvF,InvOurRefK,0);
               end;

      31    :  With LID do
                 SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

    end; {Case..}
  end; {With..}
end;


  { ======================= Due Line ======================= }


  Procedure TSListReport.StkLine;

  Const
    GenDaysMask   =  '#0 ;#0-';
    GenYearsMask   =  '#0.0 ;#0.0-';

  Var
    nDays,
    nMonths    :  Integer;

    Rnum,
    Rnum2,
    Rnum3,
    nYears     :  Double;

    UseRate,
    TBo        :  Boolean;

    N,UOR      :  Byte;

    RepDate    :  LongDate;


    GenStr     :  Str255;




  Begin
    Rnum:=0;

    Rnum2:=0;  Rnum3:=0.0;  RepDate:='';

    UOR:=0;  nDays:=0; nMonths:=0; nYears:=0.0;

    UseRate:=UseCoDayRate;


    With MTExLocal^, RepFiler1, CRepParam^ do
    Begin

      SetReportDrillDown(1);

      Case ValMode of


        9,29
           :  With LMiscRecs^.FIFORec do
              Begin

                If (Not RevalueStkCid(LStock.NomCodes[4],MTExLocal)) and (FIFOCRates[UseRate]<>0.0) then
                  Rnum2:=Conv_TCurr(FIFOCost,FIFOCRates[UseRate],FIFOCurr,FUseORate,BOff)
                else
                  Rnum2:=Currency_ConvFT(FIFOCost,FIFOCurr,0,UseCoDayRate);

                {Rnum2:=Currency_ConvFT(FIFOCost,FIFOCurr,0,UseCoDayRate);}

                Rnum:=Round_Up(QtyLeft*Rnum2,Syss.NoCosDec);

                If (ValMode=29) then
                Begin
                  LGetMainRecPosKey(InvF,InvOurRefK,DocRef);

                  AgeStock(FIFODate,StkAgeDate,nDays,nMonths,nYears);
                end;


                Case ValMode of
                  9  :  SendLine(ConCat(#9,DocRef,
                                 #9,FIFOCust,
                                 #9,FIFOMLoc,
                                 #9,FormatFloat(GenQtyMask,FIFOQty),
                                 #9,FormatFloat(GenQtyMask,QtyLeft),
                                 #9,FormatFloat(GenUnitMask[BOff],RNum2),
                                 #9,FormatFloat(GenRealMask,Rnum)));

                  29 :  SendLine(ConCat(#9,DocRef,
                                 #9,
                                 #9,FIFOMLoc,
                                 #9,FormatFloat(GenQtyMask,QtyLeft),
                                 #9,FormatFloat(GenUnitMask[BOff],RNum2),
                                 #9,FormatFloat(GenRealMask,Rnum),
                                 #9,POutDate(FIFODate),
                                 #9,FormatFloat(GenDaysMask,nDays),
                                 #9,FormatFloat(GenDaysMask,nMonths),
                                 #9,FormatFloat(GenDaysMask,nYears)));
                end; {Case..}

                VCalcStkTotals(QtyLeft);

              end;

      {$IFDEF SOP}

        10,30
           :  With LMiscRecs^.SerialRec do
              Begin

                If (BatchRec) then
                Begin
                  Rnum2:=BuyQty-QtyUsed;

                  If (ValMode=10) then
                    GenStr:=Batch_AQty(BuyQty,QtyUsed,BatchChild)
                  else
                    GenStr:='';
                end
                else
                Begin
                  Rnum2:=1;
                  GenStr:=SerialNo;
                end;

                If (ValMode=30) then
                Begin
                  LGetMainRecPosKey(InvF,InvOurRefK,InDoc);
                  If (DateIn='') then
                    DateIn:=LInv.TransDate;

                  AgeStock(DateIn,StkAgeDate,nDays,nMonths,nYears);
                end;



                Rnum3:=Round_Up(Ser_CalcCrCostCid(0,LMiscRecs^,MTExLocal),Syss.NoCosDec);
                Rnum:=Round_Up(Ser_CalcCrCostCid(0,LMiscRecs^,MTExLocal)*Rnum2,Syss.NoCosDec);

                                                              {** Note use of GenStr vv **}
                Case ValMode of
                  10  :  SendLine(ConCat(#9,GenStr,
                                         #9,BatchNo,
                                         #9,InMLoc,
                                         #9,InBinCode,
                                         #9,POutDateB(DateUseX),
                                         #9,FormatFloat(GenRealMask,RNum)));

                  30  :  SendLine(ConCat(#9,InDoc,
                                         #9,dbFormatName(GenStr,BatchNo),
                                         #9,InMLoc,
                                         #9,FormatFloat(GenQtyMask,Rnum2),
                                         #9,FormatFloat(GenUnitMask[BOff],Rnum3),
                                         #9,FormatFloat(GenRealMask,RNum),
                                         #9,POutDate(DateIn),
                                         #9,FormatFloat(GenDaysMask,nDays),
                                         #9,FormatFloat(GenDaysMask,nMonths),
                                         #9,FormatFloat(GenDaysMask,nYears)));

                end; {Case..}

                VCalcStkTotals(Rnum2);


              end;

        {$ENDIF}


        31  :  With LId do
               Begin
                 Rnum2:=CaseQty(LStock,AgeAvQty);

                 Rnum3:=AgeAvUP;

                 Rnum:=Round_Up(AgeAvQty*AgeAvUP,2);

                 If (PDate='') then
                   RepDate:=Today
                 else
                   RepDate:=PDate;

                 AgeStock(PDate,StkAgeDate,nDays,nMonths,nYears);

                 SendLine(ConCat(#9,DocPRef,
                                 #9,
                                 #9,MLocStk,
                                 #9,FormatFloat(GenQtyMask,Rnum2),
                                 #9,FormatFloat(GenUnitMask[BOff],Rnum3),
                                 #9,FormatFloat(GenRealMask,RNum),
                                 #9,POutDate(RepDate),
                                 #9,FormatFloat(GenDaysMask,nDays),
                                 #9,FormatFloat(GenDaysMask,nMonths),
                                 #9,FormatFloat(GenDaysMask,nYears)));




                 VCalcStkTotals(AgeAvQty);
               end;

        59,60
           :  With LStock,LMLocCtrl^.brBinRec do
              Begin
                If (ShowQty) then
                  Rnum2:=brBuyQty-brQtyUsed
                else
                  Rnum2:=0.0;

                  {GenStr:=Batch_AQty(brBuyQty,brQtyUsed,brBatchChild)
                else
                  GenStr:='';}

                SendLine(ConCat(#9,brBinCode1,
                                #9,StockCode,
                                #9,Desc[1],
                                #9,UnitK,
                                #9,FormatFloat(GenQtyMask,Rnum2)));


                DefLine(-1,TabStart(5),TabEnd(5),0);
                DefLine(-1,TabStart(6),TabEnd(6),0);

              end;

      end; {Case..}

    end; {With(s)..}
  end;




Function TSListReport.Find_LastAverage(SCode      :  Str20;
                                       AsAtDate   :  LongDate)  :  Boolean;

Const
  Fnum      = IDetailF;
  Keypath   = IdAnalK;

Var
  Loop,
  FoundOk,
  LastFind  :  Boolean;

  fKeyChk,
  fKeyS      :  Str255;

  PINId     :  Idetail;

  LoopSearch:  Array[BOff..Bon] of Char;


Begin
  Result:=BOff;

  LoopSearch[BOff]:=StkLineType[PIN];

  LoopSearch[BOn]:=StkLinetype[ADJ];


  Loop:=BOff; LastFind:=BOff;

  Blank(PINId,Sizeof(PINId));

  With MTExLocal^ do
  Begin
    Repeat
      FoundOk:=BOff;

      fKeyChk:=LoopSearch[Loop]+FullStockCode(SCode);
      fKeyS:=fKeyChk+AsAtDate;

      LStatus:=LFind_Rec(B_GetLessEq,Fnum,KeyPath,fKeyS);

      While (LStatusOk) and (Checkkey(fKeyChk,fKeyS,Length(fKeyChk),BOn)) and (ChkRepAbort) and (Not FoundOk) do
      With LId do
      Begin
        FoundOk:=(IdDocHed In [ADJ,PIN,PJI,PPI]);

        If (FoundOk) and (Loop) and (IdDocHed=ADJ) then
          FoundOk:=(Qty>0);

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetPrev,Fnum,KeyPath,fKeyS);

      end;

      If (Not Loop) and (FoundOk) then
      Begin
        PINId:=LId;
        LastFind:=BOn;
      end;

      Loop:=Not Loop;

    Until (Not Loop) or (Not ChkRepAbort);


    Result:=FoundOk or LastFind;

    If (Result) then
    Begin
      If (Not FoundOk) and (LastFind) then
        LId:=PINId
      else
        If (PINId.PDate>LId.PDate) then
          LId:=PINId;

    end;

  end; {With..}

end;


Procedure TSListReport.PrintValDetail(StkAgingMode  :  Byte);





Var
  Fnum,
  Keypath    :  Integer;

  KeyCS,
  KeyChk     :  Str255;

  NewLine    :  Boolean;

  Rnum       :  Real;


Begin

  Rnum:=0;

  NewLine:=BOn;

  Fnum       :=  MiscF;
  Keypath    :=  MIK;


  With MTExLocal^,CRepParam^ do
  Begin
    ValMode:=10-Ord(Is_FIFO(LStock.StkValType))+StkAgingMode;

    Case ValMode of

      9,29  :  KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(LStock.StockFolio));
     10,30  :  KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(LStock.StockFolio)+#0);
     31     :  KeyChk:=NdxWeight;

     59,60
            :  Begin
                  If (EmptyKey(LocFilt,MLocKeyLen)) then
                    KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(LStock.StockFolio))
                 else
                    KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(LStock.StockFolio)+Full_MLocKey(LocFilt)+Chr(0));

                 Fnum       :=  MLocF;
                 Keypath    :=  MLSecK;

                 NewLine:=BOff;

               end;

   end; {Case..}

    VBSTot:=0;
    VRepTot:=0;

    KeyCS:=KeyChk;

    If (ValMode<>31) then
      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS)
    else
      LStatus:=0;

    While (LStatusOk) and ((Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) or (ValMode=31)) and (ChkRepAbort) do
    With CRepParam^ do
    Begin

      If (StkInclude) then
      Begin
        If (NewLine) then
          RepPrintPageHeader2;

        NewLine:=BOff;

        StkLine;
      end;

      With RepFiler1 do
        If (LinesLeft<5) then
          ThrowNewPage(5);

      If (ValMode<>31) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS)
      else
        LStatus:=9;

    end; {While..}

    If (Not NewLine) then
      StkEnd;

    ValMode:=0;
    RepSetTabs;
  end; {With..}
end; {Proc..}



Procedure TSListReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'In',' ','Stk',#9,'Alloc',
                      #9,'Free',#9,'Min',' ','Stk',#9,'OnOrd',#9,'Need',' ','Min',#9,'Need',' ','Max',
                      #9,'RO',' ','Unit'));
      2   :  SendLine(ConCat(#9,'Bin',' ','Locn',#9,'Stock',' ','Code',#9,'Description',#9,'UOM',#9,
                     'In',' ','Stk',#9,'Actual',#9,'Diff.'));

      3   :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'Alt.',' ','Code',#9,'Cost',
                    ' ','Price',#9,'In',' ','Stk',#9,'Alloc',#9,'Free',#9,'On',' ','Ord'));

      //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
      4,5,44
          :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'In',' ',
                    'Stk',#9,'Last',' ','Cost',#9,'Value'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TSListReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1 do
  Case ReportMode of
      1  :  If (CurrentPage>1) then
              PrintCustLine(LCust.CustCode,BOn);

  //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
      4,5,44
         :  If (CurrentPage>1) then
            Begin
               PrintNomLine(FullNomKey(LNom.NomCode),BOn);

               If (ValMode<>0) and (Not CRepParam^.ShowQty) then
               Begin
                 PrintStkLine(LStock.StockCode,BOn);

                 RepPrintPageHeader2;
               end;
            end;

  end; {Case..}

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TSListReport.CalcStkTotals(StkVal,
                                     QtyVal    :  Real);

Var
  nBo        :  Boolean;
  Rnum       :  Real;

Begin

  Rnum:=0;

  With CRepParam^ do
    Case ReportMode of

    //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
        4,5,44
          :  Begin

                BSTot:=BSTot+StkVal;

                RepTot:=RepTot+StkVal;

                BQtyTot:=BQtyTot+QtyVal;

                RQtyTot:=RQtyTot+QtyVal;

              end;

    end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TSListReport.PrintStockTot(GMode     :  Byte);

Var
  n          :  Byte;


Begin


  With RepFiler1, CRepParam^ do
  Case ReportMode of
    4, 5
       :  Begin
            DefFont(0,[fsBold]);

            Case GMode of
              1  :  DefLine(-1,TabStart(3),TabEnd(5),0);



              2  :  Begin

                      BSTot:=RepTot;

                      BQtyTot:=RQtyTot;


                      DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

                    end;

            end; {Case..}


            Case ReportMode of
              4,5  :  SendLine(ConCat(ConstStr(#9,3),FormatFloat(GenQtyMask,BQtyTot),
                             #9,'<-Totals->',#9,FormatFloat(GenRealMask,BSTot)));

              44 :  SendLine(ConCat(ConstStr(#9,2),FormatFloat(GenQtyMask,BQtyTot),
                             #9,'<-Totals->',#9,FormatFloat(GenRealMask,BSTot)));

            end; {Case..}



            Case GMode of
              1  :  DefLine(-2,TabStart(3),TabEnd(5),0);

            end; {Case..}

            BSTot:=0;
            BQtyTot:=0;


            DefFont(0,[]);

          end; {Case..}

  end; {Case..}

end;





{ == Function to return Stk Va;, or WIP G/L codes depending on Prod Type == }

Function TSListReport.RetSVGL(StockR  :  StockRec)  :  LongInt;

Begin
  With StockR do
    If (StockType=StkBillCode) then
      RetSVGL:=NomCodeS[5]
    else
      RetSVGL:=NomCodeS[4];

end;



{ ======================= Customer Line ======================= }


Procedure TSListReport.PrintReportLine;

Var
  AgeMode   :  Byte;
  Profit,
  Purch,
  Sales,
  Cleared,
  Rnum,
  Rnum2,
  Rnum3,

  RnumP2,
  RnumP      :  Double;

  GenStr     :  Str255;


Begin

  Profit:=0; Purch:=0; Sales:=0;  Cleared:=0;  AgeMode:=0;

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    With LStock do
    Case ReportMode of
      1  :  Begin
              If (LastSupp<>SuppTemp) then
              Begin

                PrintCustLine(SuppTemp,BOff);

                LastSupp:=SuppTemp;

              end;

            end;

    //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
      4,5,44
         :  Begin
              If (RetSVGL(LStock)<>LastNomCode) then
              Begin
                If (LastNomCode<>0) then
                  PrintStockTot(1);

                PrintNomLine(FullNomKey(RetSVGL(LStock)),BOff);

                LastNomCode:=RetSVGL(LStock);

              end;

            end;


    end; {Case..}


    Rnum:=0;

    Rnum2:=0;


    Rnum3:=0;

    RnumP:=0;


    GenStr:='';

    SetReportDrillDown(0);

    With LStock do
    Case ReportMode of
      1  :  Begin

              Rnum3:=CaseQty(LStock,FreeStock(LStock)+QtyOnOrder);

              Rnum2:=CaseQty(LStock,(QtyMax-Rnum3));

              Rnum:=CaseQty(LStock,(QtyMin-Rnum3));
              //HV and R Jha 06/01/2016, JIRA-14841, To set Need Min and Need Max to 0 if items are not required instead of minus quantities.
              if Rnum2 < 0.00 then Rnum2:= 0;
              if Rnum < 0.00 then Rnum:= 0;
              QtyInStock:=CaseQty(LStock,QtyInStock);
              QtyAllocated:=CaseQty(LStock,AllocStock(LStock)+WOPAllocStock(LStock));
              QtyMin:=CaseQty(LStock,QtyMin);
              QtyOnOrder:=CaseQty(LStock,QtyOnOrder);

              SendLine(ConCat(#9,StockCode,
                       #9,Desc[1],
                       #9,FormatFloat(GenQtyMask,QtyInStock),
                       #9,FormatFloat(GenQtyMask,QtyAllocated),
                       #9,FormatFloat(GenQtyMask,RNum3),
                       #9,FormatFloat(GenQtyMask,QtyMin),
                       #9,FormatFloat(GenQtyMask,QtyOnOrder),
                       #9,FormatFloat(GenQtyMask,RNum),
                       #9,FormatFloat(GenQtyMask,RNum2),
                       #9,FormatFloat(FormatDecStrSD(4,GenRealMask,BOff),BuyUnit)));

            end;

      2  :  Begin

              If (ShowQty) then
                Rnum:=CaseQty(LStock,QtyInStock)
              else
                Rnum:=0;

              GenStr:=BinLoc;

              If (MultiBinMode) and (ShowBins) then
              Begin
                GenStr:='Total';

                DefFont(0,[fsBold,fsUnderline]);

              end;


              SendLine(ConCat(#9,GenStr,
                              #9,StockCode,
                              #9,Desc[1],
                              #9,UnitK,
                              #9,FormatFloat(GenQtyMask,Rnum)));


              DefLine(-1,TabStart(5),TabEnd(5),0);
              DefLine(-1,TabStart(6),TabEnd(6),0);


              If (MultiBinMode) and (ShowBins) then
              Begin
                DefFont(0,[]);

                PrintValDetail(50);

              end;

            end;


      3  :  Begin

              Rnum:=CaseQty(LStock,FreeStock(LStock));


              QtyInStock:=CaseQty(LStock,QtyInStock);
              QtyAllocated:=CaseQty(LStock,AllocStock(LStock));
              QtyOnOrder:=CaseQty(LStock,QtyOnOrder);


              SendLine(ConCat(#9,StockCode,
                       #9,Desc[1],
                       #9,AltCode,
                       #9,FormatCurFloat(GenRealMask,CostPrice,BOff,PCurrency),
                       #9,FormatFloat(GenQtyMask,QtyInStock),
                       #9,FormatFloat(GenQtyMask,QtyAllocated),
                       #9,FormatFloat(GenQtyMask,RNum),
                       #9,FormatFloat(GenQtyMask,QtyOnOrder)));


            end;

    //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
      4,5,44
         :  Begin
              {$IFDEF SOP}

                LStock_LocRep1Subst(LStock,LocFilt);

              {$ENDIF}


              Rnum:=StkCalc_AVCost(LStock,LocFilt,MTExLocal);

              If (ShowLive) then
                RnumP:=QtyInStock
              else                  {* Should always be posted qty
                                       as even live valuation only affects
                                       nominal when its posted *}

              Begin
                {* Get current posted qty in stock *}

                Profit:=LProfit_To_Date(Calc_AltStkHCode(StockType),
                                       CalcKeyHist(StockFolio,LocFilt),
                                       0,GetLocalPr(0).CYr,GetLocalPr(0).CPr,
                                       Purch,Sales,Cleared,BOn);

                RnumP:=Cleared;

                {Removed in v4.31.004 as this scenario should be taken care of within FIFO}

                {If (Rnum=0.0) then {* v4.22 For some reason the returned value is zero, so overwrite with last known cost
                                      This could happen when using posted stock levels *}
                {Begin
                  Rnum:=Currency_ConvFT(Calc_StkCP(CostPrice,BuyUnit,CalcPack),PCurrency,0,UseCoDayRate);

                end;}

              end;

              Rnum2:=Round_Up(Rnum*RnumP,2);

              RnumP2:=CaseQty(LStock,RnumP);


              SendLine(ConCat(#9,StockCode,
                       #9,Desc[1],
                       #9,FormatFloat(GenQtyMask,RnumP2),
                       #9,FormatFloat(GenUnitMask[BOff],RNum),
                       #9,FormatFloat(GenRealMask,RNum2)));


              CalcStkTotals(Rnum2,RnumP);


              {$IFDEF PF_On}

                Case ReportMode of
                  44  :  Begin
                           If (Not ShowQty)  then
                           Begin
                             AgeMode:=20 + Ord(FIFO_Mode(StkValType)=4);
                             AgeAvQty:=RnumP;
                             AgeAvUP:=Rnum;

                             PrintValDetail(AgeMode)
                           end;

                         end;

                  else   If (Not ShowQty) and (Is_FIFO(StkValType) or IS_SerNo(StkValType)) then
                           PrintValDetail(0);

                end; {Case..}

              {$ENDIF}

            end;

    end; {Case..}



  end;
end;


{ ======================= Customer End ======================= }


Procedure TSListReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin

  //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
    If (ReportMode In [4,5,44]) and (RepPrintExcelTotals) then
        For n:=1 to 2 do
          PrintStockTot(n);

  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TSListReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;


Begin

  TmpInclude:=BOff;



  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin

    {$IFDEF SOP}

      LStock_LocRep1Subst(LStock,LocFilt);

    {$ENDIF}



    Case ReportMode of

          1,2
             :  With LStock do
                Begin
                  TmpInclude:=((StockType In StkProdSet-[StkDListCode])
                              and (Stk_InGroup(StkToo,LStock))
                              and (CheckKey(CustFilt,SuppTemp,Length(CustFilt),BOff))
                              and (CheckKey(RepValType,BinLoc,Length(RepValType),BOff))
                              and ((MinFlg) or (ReportMode=2)));
                end;

          3  :  With LStock do
                Begin


                  TmpInclude:=(((StockType In StkProdSet-[StkDListCode]) or
                               ((StockType=StkDescCode) and (Syss.AnalStkDesc))) 
                               and (Stk_InGroup(StkToo,LStock))
                               and (CheckKey(CustFilt,SuppTemp,Length(CustFilt),BOff))
                               and (CheckKey(LastSupp,Supplier,Length(LastSupp),BOff))
                               and (CheckKey(RepValType,BinLoc,Length(RepValType),BOff)));

                end;

    //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
          4,5,44
             :  With LStock do
                Begin
                  If (ThisScrt<>NIL) then {* Get Id Link *}
                  Begin
                    ThisScrt^.Get_Scratch(LRepScr^);
                    TmpInclude:=BOn;

                    {$IFDEF SOP}
                      LStock_LocRep1Subst(LStock,LocFilt);

                    {$ENDIF}

                  end;
                end;

        end; {Case..}
    end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}



{ == Proc to build the Stock Valuation report == }

Procedure TSListReport.Build_SVReport(Var AbortPrint :  Boolean);


Const
  Fnum   =  StockF;
  Keypath=  StkValK;


Var
  KeyScr,
  MatchStr :  Str255;
  RecAddr  :  LongInt;

  TmpInclude :  Boolean;

  Purch,Sales,
  Cleared,
  Profit     :  Double;




Begin
  AbortPrint:=BOn;

  TmpInclude:=BOff;


  Purch:=0; Sales:=0;

  Cleared:=0;

  Profit:=0;



  ShowStatus(2,'Calculating Totals.');


  With MTExLocal^, CRepParam^ do
  Begin

    LStatus:=LFind_Rec(B_GetFirst,Fnum,KeyPath,KeyScr);


    While (LStatusOk) and (ChkRepAbort) do
    With LStock do
    Begin
      {$IFDEF SOP}
        LStock_LocRep1Subst(LStock,LocFilt);

      {$ENDIF}

      // MH 01/07/2008: Moved before LProfit_To_Date check to optimise performance
      TmpInclude := CheckKey(RepValType,StkValType,Length(RepValType),BOff) and Stk_InGroup(StkToo,LStock);

      If TmpInclude Then
      Begin
        If (Not ShowLive) then
        Begin
          Profit:=LProfit_To_Date(Calc_AltStkHCode(StockType),
                               CalcKeyHist(StockFolio,LocFilt),
                               0,GetLocalPr(0).CYr,GetLocalPr(0).CPr,
                               Purch,Sales,Cleared,BOn);

          QtyPosted:=Cleared;

          TmpInclude:=(Round_Up(QtyPosted,Syss.NoQtyDec)<>0);

        end
        else
          TmpInclude:=(Round_Up(QtyInStock,Syss.NoQtyDec)<>0);
      End; // If TmpInclude

// MH 01/07/2008: Moved before LProfit_To_Date check to optimise performance
//      If (TmpInclude) then
//        TmpInclude:=((CheckKey(RepValType,StkValType,Length(RepValType),BOff))
//                     and (Stk_InGroup(StkToo,LStock)));


      If (TmpInclude) and (ReportMode=44) then {Only include FIFO/Ser + Average items}
      Begin
        TmpInclude:=(Is_FIFO(StkValType) or IS_SerNo(StkValType) or (FIFO_Mode(StkValType)=4));

      end;

      If (TmpInclude) then
      Begin


        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        MatchStr:=Form_Int(RetSVGL(LStock),6)+StockCode;

        ThisScrt^.Add_Scratch(Fnum,KeyPath,RecAddr,MatchStr,'');

        If (AbortPrint) then
          AbortPrint:=BOff;

      end;


      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyScr);

    end; {While..}

  end; {With..}

end; {Proc..}





Function TSListReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    {RepOrd:='C';}


    Case ReportMode of

       1    :   Begin
                  ThTitle:='Reorder Report';

                  RepTitle:='Stock Re-Order Report';

                  PageTitle:=RepTitle;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandscape;

                  RKeyPath:=StkMinK;
                end;


       2    :   Begin
                  ThTitle:='Stock Take Report';

                  RepTitle:=ThTitle;

                  PageTitle:=RepTitle;
                end;


       3    :   Begin
                  ThTitle:='Stock List';

                  RepTitle:=ThTitle;

                  PageTitle:=RepTitle;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandscape;
                end;
       { PL 18/04/2017 2017-R1 ABSEXCH-18497 : added Case-5 to execute valuation
        report as Posted and existing case-4 is used for Valuation Live report}
       4,5,44
           :   Begin

                  If (Debug) then
                  Begin
                    {ShowQty:=BOff;

                    ShowLive:=BOff;}
                  end;

                  If (ReportMode=44) then
                  Begin
                    ThTitle:='Stock Aging Report';

                    RepTitle:='Stock Aging Report as at '+POutDate(StkAgeDate);
                  end
                  else
                  Begin
                    If (ReportMode=4) then
                    begin
                      ThTitle:='Stock Val - Live Report';

                      RepTitle:='Stock Valuation - Live Report';

                    end
                    else If (ReportMode=5) then
                    begin
                      ThTitle:='Stock Val - Posted Report';

                      RepTitle:='Stock Valuation - Posted Report';
                    end
                    else
                    begin
                      ThTitle:='Stock Val - Live Report';

                      RepTitle:='Stock Valuation - Live Report';
                    end;
                  end;

                  PageTitle:=RepTitle;

                  If (Not EmptyKey(StkToo,StkKeyLen)) then
                  Begin
                    GetStock(Application.MainForm,FullStockCode(StkToo),FoundCode,-1);

                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+'Stock Group '+Strip('B',[#32],Stock.Desc[1]);

                  end;


                  RFont.Size:=7;

                  RKeyPath:=RpK;
                end;

    end; {Case..}


    {$IFDEF SOP}
      If (Not EmptyKey(LocFilt,LocKeyLen)) then
      Begin
        If (RepTitle2<>'') then
          RepTitle2:=RepTitle2+', ';

        RepTitle2:=RepTitle2+MLocRepTitle(LocFilt)+'. ';
      end;

      If (ReportMode In [1,2]) then
      Begin
        If (LocOverride(LocFilt,2+ReportMode)) then
        Begin
          {$IFDEF POST}
             AddStkLocOR2Thread(Self.fMyOwner,LocFilt,Ord(ReportMode=2)*2,2);
          {$ENDIF}
        end;
      end;
    {$ENDIF}

    If (ReportMode In [2,3]) then
    Begin
      If (Not EmptyKey(StkToo,StkKeyLen)) then
      Begin
        GetStock(Application.MainForm,FullStockCode(StkToo),FoundCode,-1);


        RepTitle2:=RepTitle2+'Stock Group '+Strip('B',[#32],Stock.Desc[1]);
      end;

      If (CustFilt<>'') then
      Begin
        GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);

        If (RepTitle2<>'') then
          RepTitle2:=RepTitle2+', ';

        RepTitle2:=RepTitle2+'For Supplier'+Strip('B',[#32],Cust.Company);
      end;

      If (RepValType<>'') then
      Begin
        If (RepTitle2<>'') then
          RepTitle2:=RepTitle2+', ';

        RepTitle2:=RepTitle2+'Bin Loc Filter : '+RepValType;
      end;

      Case RepOrd of
        'B'  :  RKeyPath:=StkBinK;
        'C'  :  RKeyPath:=StkCodeK;
        'D'  :  RKeyPath:=StkDescK;

      end;
    end;
   { PL 18/04/2017 2017-R1 ABSEXCH-18497 : added Case-5 to execute valuation
        report as Posted and existing case-4 is used for Valuation Live report}
    If (ReportMode In [4,5,44]) then
    Begin
      RFnum:=ReportF;
    end
    else
      RFnum:=StockF;


  end; {With..}

  Result:=BOn;
end;




Procedure TSListReport.Process;

Var
  AbortPrint   :  Boolean;


Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}
  With MTExLocal^,CRepParam^ do
  Begin
    AbortPrint:=BOff;

  //PL 21/09/2017 2017-R2 ABSEXCH-19181 Stock valuation report- Posted runs blank to screen and excel
    If (ReportMode In [4,5,44]) then
    Begin
      New(ThisScrt,Init(15,MTExLocal,BOff));

      RepKey:=FullNomKey(ThisScrt^.Process);

      InitStatusMemo(4);

      ShowStatus(0,RepTitle);

      Build_SVReport(AbortPrint);

    end;
  end; {With..}

  inherited Process;

end;


Procedure TSListReport.Finish;


Begin
  {$IFDEF SOP}
    With MTExLocal^, CRepParam^ do
      If (ReportMode In [1,2]) and (LLocOverride(LocFilt,2+ReportMode)) then
      Begin
        {$IFDEF POST}
          AddStkLocOR2Thread(Self.fMyOwner,LocFilt,3+(Ord(ReportMode=2)*2),2);
        {$ENDIF}
      end;
  {$ENDIF}

  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);


  Inherited Finish;
end;


{ ======== }



Procedure AddSListRep2Thread(LMode    :  Byte;
                             IRepParam:  SListRepPtr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TSListReport;

  //PR: 21/10/2009 Function to add this report's parameters to the report's PrintParameters object.
  procedure AddParametersToValuation;
  begin
    if Assigned(EntTest.oPrintParams) then
    begin
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Product Group';
        Value := IRepParam.StkToo;
      end;

	    //PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: New Menu Positions
      if (LMode = rmStockValuationLive) or (LMode = rmStockValuationPosted)  then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Summary Report';
        Value := IRepParam.ShowQty;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Use Live Stock Levels';
        //AP 02/02/2018 ABSEXCH-19628:Stock Valuation reports showing incorrect results
        if IRepParam.ShowLive then
          Value := 'Yes'
        else
          Value := 'No';
      end;

      //PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: New Menu Positions
      if (LMode = rmStockValuationLive) or (LMode = rmStockValuationPosted) then
      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'For valuation types';
        if IREpParam.RepValType = '' then
          Value := 'All'
        else
          Value := STDValList[StkVM2I(IREpParam.RepValType[1])];
      end;

      if LMode = rmStockAging then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Age Stock as at';
        Value := POutDate(IRepParam.StkAgeDate);
      end;

      if Syss.UseMLoc then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Location Filter';
        Value := IRepParam.LocFilt;
      end;

      EntTest.bPrintParams := True;
    end;
  end;

  //PR: 21/10/2009 Function to add this report's parameters to the report's PrintParameters object.
  procedure AddParametersToStockTakeList;

    function StockSortString(Idx : Char) : string;
    begin
      Case Idx of
        'C' : Result := 'Code';
        'D' : Result := 'Description';
        'B' : Result := 'Bin Location';
        else
          Result := 'Code';
      end;
    end;

  begin
    if Assigned(EntTest.oPrintParams) then
    begin
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Product Group';
        Value := IRepParam.StkToo;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Sort by Stock';
        Value := StockSortString(IRepParam.RepOrd);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Show Stock Levels';
        Value := IRepParam.ShowQty;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Bin Location Filter';
        Value := IRepParam.RepValType;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Show Bins';
        Value := IRepParam.ShowBins;
      end;

      if Syss.UseMLoc then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Location Filter';
        Value := IRepParam.LocFilt;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Supplier Filter';
        Value := IRepParam.CustFilt;
      end;

      EntTest.bPrintParams := True;
    end;
  end;

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
          // MH 14/10/2010 v6.5 ABSEEXCH-9935: Was crashing because with locations turned off there are no parameters
          // so IRepParam is NIL - did as separate IF due to unknown state of boolean shortcut evaluation
          if Assigned(IRepParam) then
            //PR: 21/10/2009
            if IRepParam.PrintParameters then
            begin
              //PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: New Menu Positions
              if ReportMode in [rmStockValuationLive, rmStockValuationPosted, rmStockAging] then
                AddParametersToValuation
              else
              if ReportMode = rmStockTakeList then
                AddParametersToStockTakeList;
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





Initialization



Finalization

end.