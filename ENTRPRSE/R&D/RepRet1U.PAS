unit RepRet1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, SCRTCH2U,
  StkWarnU;


type


  TRet1Report  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       CurrMode    :  Byte;

                       ThisScrt    :  Scratch2Ptr;

                       CCust       :  CustRec;
                       SStock      :  StockRec;

                       StatusStr   :  TStringList;

                       Function BuildSortKey  :  Str255;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Function RepPageTitle(Mode  :  Byte)  :  Str80;

                       Function RepContent(Mode  :  Byte)  :  Str80;

                       Procedure PrintRETLine(GMode    :  Byte;
                                              ContMode :  Boolean);

                       Procedure PrintRETTot(GMode     :  Byte);

                       Procedure CalcStkTotals(StkVal     :  AgedTyp);

                       Function GetReportInput  :  Boolean; Virtual;


                       Procedure Build_Data(Mode     :  Byte;
                                            DocFilt  :  Char;
                                            CustFilt,
                                            LocFilt  :  Str10;
                                            StkFilt  :  Str20;
                                        Var FoundOk  :  Boolean);


                     public

                       CRepParam  :  RetRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure RetReportOrd(Var FoundOk  :  Boolean);

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddRet1Rep2Thread(LMode    :  Byte;
                            IRepParam:  RETRepPtr;
                            AOwner   :  TObject);

Procedure TESTRET1Rep(LMode    :  Byte;
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
  MiscU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  SysU1,
  SalTxl1U,
  SysU2,
  PWarnU,
  BTSupU1,
  BTSupU2,
  RpDefine,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U;


{ ========== TRET1Report. methods =========== }

Constructor TRET1Report.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  CurrMode:=1;

  ThisScrt:=nil;

  StatusStr:=TStringList.Create;

end;


Destructor TRET1Report.Destroy;

Begin
  Dispose(CRepParam);

  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);

  If (Assigned(StatusStr)) then
    StatusStr.Destroy;

  Inherited Destroy;
end;





Procedure TRET1Report.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1
         :  With CRepParam^ do
            Begin
              SetTab (MarginLeft, pjLeft, 5, 4, 0, 0);
              SetTab (NA, pjLeft, 53, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 08, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjRight, 23, 4, 0, 0);
              SetTab (NA, pjLeft, 25, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;


Function TRET1Report.RepPageTitle(Mode  :  Byte)  :  Str80;

Begin
  Result:='';

  With CRepParam^ do
  Begin
    Case SortOrd of
      0
         :  Case Mode of
              1  :  Result:='Stock Code•,Description';
              2  :  Result:='Date';

              3  :  Result:='A/C Code';

              4  :  Result:='Reason';
            end; {Case..}

      1
         :  Case Mode of
              1  :  Result:='Stock Code•,Description';

              2  :  Result:='OurRef';
              3  :  Result:='Date';
              4  :  Result:='Reason';
            end; {Case..}

      2
         :  Case Mode of
              1  :  Result:='Date';

              2  :  Result:='OurRef';
              3  :  Result:='A/C';
              4  :  Result:='Reason';
            end; {Case..}

      3
         :  Case Mode of
              1  :  Result:='Stock Code•,Description';
              2  :  Result:='OurRef';
              3  :  Result:='A/C';
              4  :  Result:='Date';
            end; {Case..}
      4
         :  Case Mode of
              1  :  Result:='Stock Code•,Description';
              2  :  Result:='OurRef';
              3  :  Result:='A/C';
              4  :  Result:='Reason';
            end; {Case..}

    end; {Case..}
  end; {With..}
end; {Func..}


Procedure TRET1Report.RepPrintPageHeader;


Var
  ThisRMode  :  Integer;
  LocStr     :  Str10;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    LocStr:='';

    {$IFDEF SOP}
      If (Syss.UseMLoc) then
        LocStr:='Loc ';

    {$ENDIF}

    DefFont(0,[fsBold]);

    Case ReportMode of


      1
          :  Begin
               If (Not Summary) then
                 SendLine(ConCat(#9,#9,RepPageTitle(1),#9,RepPageTitle(2),#9,LocStr,#9,RepPageTitle(3),#9,'Exp. Qty',#9,'Qty Ret.',#9,'Qty Rep.',#9,'Qty WOff.',
                       #9,'Qty O/S',#9,'% Complte',#9,'Unit Cost',#9,'Total Cost',#9,RepPageTitle(4),#9,'Age'))
               else
                 SendLine(ConCat(#9,#9,RepPageTitle(1),#9,#9,#9,#9,'Exp. Qty',#9,'Qty Ret.',#9,'Qty Rep.',#9,'Qty WOff.',
                       #9,'Qty O/S',#9,#9,#9,'Total Cost',#9));

             end;

    end; {case..}

    DefFont(0,[]);


  end; {With..}
end; {Proc..}





Procedure TRET1Report.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With RepFiler1 do
  Case ReportMode of
    1
       :  If (CurrentPage>1) then
            PrintRETLine(CRepParam^.SortOrd,BOn);
  end; {Case..}

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TRET1Report.CalcStkTotals(StkVal     :  AgedTyp);

Var
  n  :  Byte;

Begin


  With CRepParam^ do
    Case ReportMode of

        1
           :  Begin

                For n:=Low(StkVal) to High(StkVal) do
                Begin
                  BreakTot[n]:=BreakTot[n]+StkVal[n];
                  StkTot[n]:=StkTot[n]+StkVal[n];
                  RepTotal[n]:=RepTotal[n]+StkVal[n];
                end;

              end;

    end; {Case..With..}
end;




Procedure TRET1Report.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      1       :  Begin
                   SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

                   SendRepDrillDown(2,2,2,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

                   SendRepDrillDown(5,5,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);

                 end;

    end; {Case..}
  end; {With..}
end;

Procedure TRET1Report.PrintRETLine(GMode    :  Byte;
                                   ContMode :  Boolean);

Const
  Fnum1     =  InvF;
  Keypath1  =  InvFolioK;
  Fnum2     =  IdetailF;
  Keypath2  =  IdLinkK;

Var
  FoundOk   :  Boolean;

  NoSpc     :  Byte;

  KeyI,
  KeyChkI   :  Str255;
  LocalInv  :  InvRec;

  LocalId   :  Idetail;

  LocalStk  :  StockRec;

  LevelStr,
  SubHead   :  String;


Begin
  With MTExLocal^,RepFiler1, CRepParam^ do
  Begin
    LocalId:=LId;
    LocalInv:=LInv;
    LocalStk:=LStock;

    NoSpc:=0; LevelStr:='';

    
    DefFont(0,[fsUnderline,fsBold]);

    Case GMode of
      0,3,4
         :  Begin
              SubHead:=DocNames[RepDocHed]+' '+LId.DocPRef+', not found!';

              FoundOk:=(LInv.FolioNum=LId.FolioRef);

              If (Not FoundOk) then
              Begin
                KeyI:=FullNOmKey(LId.FolioRef);

                FoundOk:=(LFind_Rec(B_GetEq,Fnum1,KeyPath1,KeyI)=0);

              end;

              If (FoundOk) then
              Begin
                LocalInv:=LInv;

                With LId,LStock do
                Begin
                  Case GMode of
                    0  :  With LInv do
                          Begin
                            SubHead:=LInv.OurRef;

                            If (Trim(TransDesc)<>'') then
                              SubHead:=SubHead+'. From '+Trim(TransDesc);
                              
                            SubHead:=SubHead+'. '+PoutDate(TransDate)+', Status : '+StatusStr[TransMode]+'. % Complete : '+FormatFloat(GenPcntMask,(Round(DivWChk(Round_Up(DocLSplit[3]+DocLSplit[4],2),Round_Up(DocLSplit[1],2))*100)));

                            
                          end;
                    3  :  SubHead:=Get_RetLineStat(DocLTLink);
                    4  :  SubHead:=StatusStr[LInv.TransMode];
                  end; {Case..}
                end; {With..}

                {$B-}
                If (GMode=0) then
                  With LInv,LCust do
                  Begin
                    If (Trim(LInv.CustCode)<>'') and LGetMainRecPos(CustF,LInv.CustCode) then
                  {$B+}
                      SubHead:=SubHead+'. A/C : '+dbFormatName(CustCode,Company);

                    If (Tagged<>0) then
                      SubHead:=SubHead+'. Tag No. '+SetN(Tagged);
                  end;



              end;
            end;
      1  :  Begin
              {$B-}
                With LInv,LCust do
                Begin
                  If (Trim(LInv.CustCode)<>'') and LGetMainRecPos(CustF,LInv.CustCode) then
                {$B+}
                    SubHead:=' A/C : '+dbFormatName(CustCode,Company);
                end;

            end;

      2  :  Begin
              {$B-}
                With LId,LStock do
                Begin
                  If (Trim(LId.StockCode)<>'') and LGetMainRecPos(StockF,LId.StockCode) then
                {$B+}
                    SubHead:=dbFormatName(StockCode,Desc[1]);
                end;
            end;

    end; {Case..}

    If (ContMode) then
      SubHead:=SubHead+'./Cont...';

    Case GMode of
      0,3,4
           :  SendRepDrillDown(0,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
      1    :  SendRepDrillDown(0,TotTabs,1,LInv.CustCode,CustF,CustCodeK,0);
      2    :  SendRepDrillDown(0,TotTabs,1,LId.StockCode,StockF,StkCodeK,0);
    end; {Case..}

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft(SubHead,MarginLeft);
    Self.CRLF;

    If (GMode=0) then
    Begin
      DefFont(-4,[]);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;

    DefFont(0,[]);

    LInv:=LocalInv;
    LId:=LocalId;
    LStock:=LocalStk;
  end; {With..}
end;



{ ======================= Due Sub / Grand Total ================ }

Procedure TRET1Report.PrintRetTot(GMode     :  Byte);

Var
  n          :  Byte;
  Dnum       :  Double;
  GenStr     :  Str255;
  TStock     :  StockRec;


Begin
  With RepFiler1, CRepParam^ do
  Case ReportMode of
    1
       :  Begin
            If (GMode<>3) then
              DefFont(0,[fsBold]);

            Case GMode of
              0,2  :  DefLine(-2,TabStart(5),TabEnd(13),0);

            end; {Case..}


            Case GMode of
              0  :  BreakTot:=RepTotal;
              2  :  BreakTot:=StkTot;
              3  :  With MTExlocal^ do
                    Case SortOrd of
                      2  :  Begin
                              n:=LId.DocLTlink;
                              LId.DocLTlink:=LastFolio;

                              SendText(ConCat(ConstStr(#9,2),RepContent(4)));

                              LId.DocLTLink:=n;
                            end;
                      1,3  :
                            Begin
                              TStock:=LStock;

                              LGetMainRec(StockF,LastStkStr);

                              SendText(ConCat(ConstStr(#9,2),RepContent(1)));

                              LStock:=TStock;
                            end;
                    end; {Case..}

            end; {Case..}

            SendText(ConCat(ConstStr(#9,5),'Total :'));

            For n:=1 to 5 do
              SendText(ConCat(ConstStr(#9,n+5),FormatBFloat(GenQtyMask,BreakTot[n],(BreakTot[n]=0.0))));

            SendLine(ConCat(ConstStr(#9,13),FormatCurFloat(GenRealMask,BreakTot[7],BOff,RCr)));

            If (GMode=2) then
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;

            Blank(BreakTot,Sizeof(BreakTot));

            If (GMode=2) then
              Blank(StkTot,Sizeof(StkTot));


            DefFont(0,[]);

          end; {Case..}



  end; {Case..}

end;





{ ======================= Customer End ======================= }


Procedure TRET1Report.PrintEndPage;
Var

  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  With RepFiler1 do
  Begin

    If (ReportMode In [1]) then
    Begin
      With CRepParam^ do
        If (SortOrd In [1..3]) and (Summary) then
          PrintRetTot(3);

      PrintRetTot(2);

      If (RepPrintExcelTotals) then
      Begin


        PrintRetTot(0);
      end;
    end;

  end;

  Inherited PrintEndPage;


end;



Function TRET1Report.RepContent(Mode  :  Byte)  :  Str80;

Begin
  With CRepParam^,MTExLocal^,LInv,LId do
  Begin
    Case SortOrd of
      0
         :  Case Mode of
              1  :  Result:=dbFormatName(LStock.StockCode,LStock.Desc[1]);
              2  :  Result:=POutDate(TransDate);

              3  :  Result:=CustCode;

              4  :  Result:=Get_RetLineStat(DocLTLink);
            end; {Case..}

      1
         :  Case Mode of
              1  :  Result:=dbFormatName(LStock.StockCode,LStock.Desc[1]);
              2  :  Result:=OurRef;
              3  :  Result:=POutDate(TransDate);

              4  :  Result:=Get_RetLineStat(DocLTLink);
            end; {Case..}

      2
         :  Case Mode of
              1  :  Result:=POutDate(TransDate);
              2  :  Result:=OurRef;
              3  :  Result:=CustCode;

              4  :  Result:=Get_RetLineStat(DocLTLink);
            end; {Case..}

      3
         :  Case Mode of
              1  :  Result:=dbFormatName(LStock.StockCode,LStock.Desc[1]);
              2  :  Result:=OurRef;
              3  :  Result:=CustCode;
              4  :  Result:=POutDate(TransDate);
            end; {Case..}
      4
         :  Case Mode of
              1  :  Result:=dbFormatName(LStock.StockCode,LStock.Desc[1]);
              2  :  Result:=OurRef;
              3  :  Result:=CustCode;
              4  :  Result:=Get_RetLineStat(DocLTLink);
            end; {Case..}

    end; {Case..}
  end; {With..}
end; {Func..}


{ ======================= RET Line ======================= }


Procedure TRET1Report.PrintReportLine;

Var
  Rnum,
  Rnum2,
  RnumC,
  OldQty     :  Real;

  Dnum       :  Double;

  UOR,
  n          :  Byte;

  LineTot    :  AgedTyp;

  TBo
             :  Boolean;

  BMFlg      :  Char;


  LKitFolio  :  LongInt;
  LKitQty    :  Real;


  GenStr     :  Str255;

  DelDate    :  LongDate;

  LocalInv   :  InvRec;

{== Work out the difference in days weeks & months ==}

Function AgeStock(TDate,RDate  :  LongDate)  :  Str50;

Var nDays,
    nMonths      :  Integer;
    nYears       :  Double;

  Begin
    Result:='';

    If (Qty_OS(MTExLocal^.LID)>0.0) then
    Begin
      nDays:=NoDays(TDate,RDate);
      nMonths:=MonthDiff(TDate,RDate);
      nYears:=Round(DivwChk(nMonths,12));

      If (nYears>0) then
        Result:=Form_Real(nYears,0,0)+' yrs'
      else
        If (nMonths>0) and (nDays>28) then
          Result:=Form_Int(nMonths,0)+' mths'
        else
          Result:=Form_Int(nDays,0)+' days';
    end
    else
      Result:='----';
  end;



Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0;

    Rnum2:=0;

    RnumC:=0;  Dnum:=0.0;

    OldQty:=0;

    GenStr:='';

    BMFlg:=#32;

    Blank(LineTot,Sizeof(LineTot));


    DelDate:='';

    Case ReportMode of
      1
            :  With LId do
               Begin
                 Case SortOrd of
                   0  :  If (FolioRef<>LastFolio) then
                         Begin
                           If (LastFolio<>0) then
                             PrintRETTot(2);

                           LastFolio:=FolioRef;

                           PrintRetLine(SortOrd,BOff);

                         end;
                   1  :  If (CustCode<>LastCustStr) or (LastStkStr<>StockCode) then
                         Begin
                           If ((LastStkStr<>StockCode) or (CustCode<>LastCustStr)) and (LastStkStr<>'') and (Summary) then
                             PrintRETTot(3);


                           If (CustCode<>LastCustStr) then
                           Begin
                             If (LastCustStr<>'') then
                               PrintRETTot(2);

                             PrintRetLine(SortOrd,BOff);
                           end;

                           LastCustStr:=CustCode;

                           LastStkStr:=StockCode;

                         end;
                   2  :  If (StockCode<>LastStkStr) or (DocLTLink<>LastFolio) then
                         Begin
                           If ((LastStkStr<>StockCode) or (DocLTLink<>LastFolio)) and (LastStkStr<>'') and (Summary) and (LastFolio<>-1) then
                             PrintRETTot(3);


                           If (StockCode<>LastStkStr) then
                           Begin
                             If (LastStkStr<>'') then
                               PrintRETTot(2);

                             PrintRetLine(SortOrd,BOff);

                           end;

                           LastStkStr:=StockCode;

                           LastFolio:=DocLTLink;

                         end;
                   3  :  If (DocLTLink<>LastFolio) or (LastStkStr<>StockCode) then
                         Begin
                           If ((LastStkStr<>StockCode) or (DocLTLink<>LastFolio)) and (LastStkStr<>'') and (Summary) then
                             PrintRETTot(3);

                           If  (DocLTLink<>LastFolio) then
                           Begin
                             If (LastFolio<>-1) then
                               PrintRETTot(2);

                             PrintRetLine(SortOrd,BOff);
                           end;

                           LastStkStr:=StockCode;

                           LastFolio:=DocLTLink;

                           
                         end;
                   4  :  If (LInv.TransMode<>LastFolio) then
                         Begin
                           If (LastFolio<>-1) then
                             PrintRETTot(2);

                           LastFolio:=LInv.TransMode;

                           PrintRetLine(SortOrd,BOff);

                         end;
                  end; {Case..}
                end; {0}

      
    end; {Case..}


    SetReportDrillDown(0);

    Case ReportMode of

      1
         : Begin

              With LId do
              Begin
                Linetot[1]:=QtyPick;

                LineTot[2]:=Qty;

                Linetot[3]:=QtyDel+QtyPWOff;

                LineTot[4]:=QtyWOff+SSDUplift;

                LineTot[5]:=Qty_OS(LId);

                If PChkAllowed_In(143) then
                  Linetot[6]:=LId.CostPrice;  {* Currency of Document *}


                LineTot[7]:=Round_Up(InvLCost(LId),2);

                If (RCr=0) then
                Begin
                  UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                 LineTot[7]:=Round_Up(Conv_TCurr(LineTot[7],XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
               end;

               LineTot[7]:=Currency_Txlate(LineTot[7],RCr,RTxCr);


                If (Qty_OS(LId)<>0.0) then
                  GenStr:='*'
                else
                  GenStr:=#32;

                If (Not Summary) then
                  SendLine(ConCat(#9,GenStr,#9,RepContent(1),
                        #9,RepContent(2),
                        #9,LId.MLocStk,
                        #9,RepContent(3),
                        #9,FormatBFloat(GenQtyMask,LineTot[1],LineTot[1]=0.0),
                        #9,FormatBFloat(GenQtyMask,LineTot[2],LineTot[2]=0.0),
                        #9,FormatBFloat(GenQtyMask,LineTot[3],LineTot[3]=0.0),
                        #9,FormatBFloat(GenQtyMask,LineTot[4],LineTot[4]=0.0),
                        #9,FormatBFloat(GenQtyMask,LineTot[5],LineTot[5]=0.0),
                        #9,FormatFloat(GenPcntMask,(Round(DivWChk(Round_Up(QtyWOff+QtyDel,2),Round_Up(Qty,2))*100))),
                        #9,FormatCurFloat(GenUnitMask[BOff],LineTot[6],BOff,Currency),
                        #9,FormatCurFloat(GenRealMask,LineTot[7],BOff,RCr),
                        #9,RepContent(4),
                        #9,AgeStock(PDate,Today)));

                CalcStkTotals(LineTot);
              end;
            end;



    end; {Case..}


  end;
end;






{ ======================= Customer Include ======================= }


Function TRET1Report.IncludeRecord  :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;

  Fnum2     =  IdetailF;
  Keypath2  =  IdLinkK;


Var
  TmpInclude,
  TBo        :  Boolean;
  KeyCS      :  Str255;


Begin
  TmpInclude:=BOff;

  TBo:=BOff;


  {$B-}

  With MTExLocal^, CRepParam^ do
  Case ReportMode of

        1
           :  With LId do
              Begin
                If (Assigned(ThisScrt)) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);

                LResetRec(RFnum);


                KeyCS:=FullNomKey(FolioRef); {Get parent Header}

                TmpInclude:=(LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS)=0);

                LastId:=LId;

                If (TmpInclude) and (Is_FullStkCode(StockCode)) then
                  TmpInclude:=LGetMainRec(StockF,StockCode);

                LId:=LastId;
              end;


      end; {Case..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TRET1Report.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;

  KeyCS
     :  Str255;


Begin
  With CRepParam^ do
  Begin
    SLocTit:='';

    try
      Set_DefaultRetStat(StatusStr,UseSales,BOn);

    except;
      FreeandNil(StatusStr);
    end; {try..}


    Case ReportMode of

       1
            :   Begin
                  ThTitle:='Returns Report';


                  Case ReportMode of
                    1
                       :  Begin
                            RepTitle:=DocNames[RepDocHed]+' Analysis Report';
                            ROrient:=RPDefine.PoLandscape;

                            Case SortOrd of
                              0  :  RepTitle:=RepTitle+'.';
                              1  :  RepTitle:=RepTitle+' by A/C Code.';
                              2  :  RepTitle:=RepTitle+' by Stock Code.';
                              3  :  RepTitle:=RepTitle+' by Line Reason Code.';
                              4  :  RepTitle:=RepTitle+' by Return Status Code.';
                            end; {Case..}

                            If (Summary) then
                              RepTitle:='Summary '+RepTitle;
                          end;

                  end;

                  PageTitle:=RepTitle;

                  {$IFDEF MC_On}

                    If (RTxCr<>0) and (RTxCr<>RCr) then
                      PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
                    else
                      PageTitle:=CurrDesc(RCr)+PageTitle;

                  {$ENDIF}

                  RFont.Size:=8;

                  RFnum:=ReportF;

                  RKeyPath:=RpK;

                  If (Not EmptyKey(STCode,StkKeyLen)) then
                  Begin
                    GetStock(Application.MainForm,FullStockCode(STCode),FoundCode,-1);
                    SStock:=Stock;
                  end;


                  If (Not EmptyKey(CustFilt,CustKeyLen)) then
                  Begin
                    GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);
                    CCust:=Cust;
                  end;

                  {$IFDEF SOP}
                     If (Not EmptyKey(LocFilt,LocKeyLen)) then
                     Begin
                       SLocTit:=MLocRepTitle(LocFilt);
                     end;
                  {$ENDIF}

                end;


    end; {Case..}




  end; {With..}

  Result:=BOn;
end;

{ =========== Func to Build WOR Sort Key ========= }

Function TRET1Report.BuildSortKey  :  Str255;

Begin
  FillChar(Result,Sizeof(Result),#0);

  With MTExLocal^,LInv,LId,CRepParam^ do
  Begin
    Case SortOrd of
      0  :  Result:=OurRef+StockCode+PDate+SetN(DocLTLink);
      1  :  Result:=FullCustCode(CustCode)+StockCode+TransDate+SetN(DocLTLink);
      2  :  Result:=FullStockCode(StockCode)+SetN(DocLTLink)+TransDate;
      3  :  Result:=SetN(DocLTLink)+StockCode+TransDate;
      4  :  Result:=SetN(TransMode)+TransDate;
    end; {Case..}

    Result:=Result+FullNomKey(FolioNum);

    Result:=Result+Form_Int(LId.LineNo,6);
  end;

end;

{ =========== Proc to Scan and Build Report ========= }

Procedure TRET1Report.Build_Data(Mode     :  Byte;
                                 DocFilt  :  Char;
                                 CustFilt,
                                 LocFilt  :  Str10;
                                 StkFilt  :  Str20;
                             Var FoundOk  :  Boolean);


Const
  Fnum      =  IDetailF;
  Keypath   =  IdAnalK;

  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;



Var
  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  RecAddr  :  LongInt;

  MatchStr :  Str255;
  BODate   :  LongDate;

  TmpInclude,
  TBo,
  FirstFind
           :  Boolean;



Begin

  With MTExLocal^,CRepParam^ do
  Begin

    KeyChk:=DocFilt;
    KeyCS:=KeyChk;

    RecAddr:=0;  FirstFind:=BOn;  TBo:=Boff;

    FoundOk:=BOff;
    TmpInclude:=BOff;

    ShowStatus(2,'Please Wait, Building Report');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LInv,LId do
    Begin

      Case Mode of
        0,1 :  Begin   {* Delivery date is header...}

                If (LInv.FolioNum<>FolioRef) then
                Begin
                  KeyInv:=FullNomKey(FolioRef);

                  LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

                end;

              end;


      end; {Case..}


      TmpInclude:=(((Qty_OS(LId)<>0) or (FiltOrd In [1,2]))
                     and (Not EmptyKey(StockCode,StkKeyLen))
                     and (((TransDate>=SDate) and (TransDate<=EDate)) or (EDate='') or (Mode=0))
                     and (((OurRef>=StartDocNo) and (OurRef<=EndDocNo)) or (EndDocNo=''))
                     and ((Tagged=TagFilt) or (TagFilt=0))
                     {$IFDEF MC_On}
                       and ((Currency=RCr) or (RCr=0))
                     {$ENDIF}
                     and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                     and (GetHoldType(HoldFlg)<>HoldQ)
                     and (Not XReasonCodes[DocLTLink])
                     and (Not XStatusCodes[TransMode])
                     and (InvDocHed In StkRetSplit)
                     and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)));

      If (TmpInclude) then
      Begin

        LGetMainRec(StockF,StockCode);

        {$B-}

          TmpInclude:=(CheckKey(StkFilt,StockCode,Length(StkFilt),BOff) or Stk_InGroup(StkFilt,LStock));

        {$B+}
      end;


      If (TmpInclude) then
      Begin
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        MatchStr:=FullNomKey(FolioRef);

        ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,BuildSortKey,MatchStr);

        FoundOk:=BOn;


      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}


  end; {With..}
end; {Proc..}




Procedure TRET1Report.RetReportOrd(Var FoundOk  :  Boolean);

Const
  ModeDoc    :  Array[1..1] of DocTypes = (WOR);

Var
  n,
  ScrMode  :  Byte;

  HaveRC   :  Boolean;

  LocalInv :  InvRec;
  LocalId  :  IDetail;

Begin
  If (ReportMode In [1]) then
  With CRepParam^ do
  Begin
    FillChar(LocalInv,Sizeof(LocalInv),#0);
    FillChar(LocalId,Sizeof(LocalId),#0);


    If (Assigned(ThisScrt)) then
      Dispose(ThisScrt,Done);

    ScrMode:=27;

    New(ThisScrt,Init(ScrMode,MTExLocal,BOff));

    RepTitle2:='';

    If (Not EmptyKey(CustFilt,CustKeyLen)) then
      RepTitle2:=RepTitle2+' For '+Strip('B',[#32],CCust.Company)+'.';

    If (Not EmptyKey(STCode,StkKeyLen)) then
      RepTitle2:=RepTitle2+' Stock Filter: '+Strip('B',[#32],SStock.Desc[1])+'.';

    If (SLocTit<>'') then
      RepTitle2:=RepTitle2+' '+SLocTit+'.';

    If (FiltOrd<>0) then
    Begin
      If (EDate<>'') and (SDate<>'')  then
        RepTitle2:=RepTitle2+' For : '+POutDate(SDate)+' - '+POutDate(EDate)+'.'
      else
        If (EDate<>'') then
          RepTitle2:=RepTitle2+' up to: '+POutDate(EDate)+'.';
    end;

    Case FiltOrd of
      0  :  RepTitle2:=RepTitle2+' O/S ';
      1  :  RepTitle2:=RepTitle2+' Completed ';
      2  :  RepTitle2:=RepTitle2+' O/S & Completed ';
    end; {Case..}

    RepTitle2:=RepTitle2+DocNames[RepDocHed]+'s.';

    If (EndDocNo<>'') and (StartDocNo<>'')  then
      RepTitle2:=RepTitle2+' Doc Range : '+StartDocNo+' - '+EndDocNo+'.'
    else
      If (EndDocNo<>'') then
        RepTitle2:=RepTitle2+' Doc Range up to: '+EndDocNo+'.';

    If (TagFilt<>0) then
      RepTitle2:=RepTitle2+' Tag Filter : '+SetN(TagFilt)+'.';

    HaveRC:=BOff;

    For n:=Low(xReasonCodes) to High(XReasonCodes) do
      If (xReasonCodes[n]) then
      Begin
        If (Not HaveRC) then
          RepTitle2:=RepTitle2+'. Exclude: ';

        RepTitle2:=RepTitle2+Get_RetLineStat(n)+', ';

        HaveRC:=BOn;
      end;

    HaveRC:=BOff;


      For n:=Low(xStatusCodes) to High(XStatusCodes) do
      If (xStatusCodes[n]) then
      Begin
        If (Not HaveRC) then
          RepTitle2:=RepTitle2+'. Exclude Status:';

        HaveRC:=BOn;

        RepTitle2:=RepTitle2+StatusStr[n]+', ';

      end;


    BSTot:=0; BSTotc:=0;

    RepTot:=0; RepTotc:=0;

    ICount:=0;

    RepKey:=FullNomKey(ThisScrt^.Process);

    If (SortOrd In [3,4]) then
      LastFolio:=-1;

    Case ReportMode of
      1  :  Begin
              If (FiltOrd In [0,2]) then {* Get unposted *}
                Build_Data(0,
                           StkLineType[RepDocHed],
                           CustFilt,
                           LocFilt,
                           STCode,
                           FoundOk);

              If (FiltOrd In [1,2]) then {* Get Posted *}
                Build_Data(1,
                           Chr(Ord(StkLineType[RepDocHed])+1),
                           CustFilt,
                           LocFilt,
                           STCode,
                           FoundOk);


            end;
    end; {Case..}

  end;

  Inc(CurrMode);

end;


Procedure TRET1Report.Process;

Var
  FoundOk  :  Boolean;

Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}
  InitStatusMemo(4);

  ShowStatus(0,RepTitle);

  If (ReportMode In [1]) then
  Begin
    RetReportOrd(FoundOk);

  end;

  Inherited Process;

end;


Procedure TRET1Report.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddRET1Rep2Thread(LMode    :  Byte;
                            IRepParam:  RETRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TRET1Report;

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

{Test RET Report, Mode 1}

Procedure TESTRET1Rep(LMode    :  Byte;
                      AOwner   :  TObject);


Var
  IRepParam:  RETRepPtr;

Begin
  New(IRepParam);

  FillChar(IRepParam^,Sizeof(IRepParam^),#0);

  With IRepParam^ do
  Begin
    SDate:=''; EDate:='';  FiltOrd:=0;
    RPr:=01; RYr:=99; RPr2:=12; RYr2:=109;  UseSales:=BOff;

    LinkDocNo:='SOR000163';

    AddRET1Rep2Thread(LMode,IRepParam,AOwner);
  end;

  Dispose(IRepParam);
end;


Initialization



Finalization

end.