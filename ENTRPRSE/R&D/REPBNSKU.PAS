unit RepBNSKU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, SCRTCH2U,
  StkWarnU;


type


  TBin1Report  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       CurrMode    :  Byte;

                       BreakCounter:  LongInt;

                       SStock      :  StockRec;
                       SLocTit     :  Str80;

                       ThisScrt    :  Scratch2Ptr;


                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintBINLine(GMode    :  Byte;
                                              ContMode :  Boolean);

                       Procedure PrintBINTot(GMode     :  Byte);

                       Procedure CalcStkTotals(StkVal,QtyVal     :  Double);

                       Function GetReportInput  :  Boolean; Virtual;


                       {$IFDEF SOP}
                         Procedure Build_SNORecord(Mode     :  Byte;
                                                   BinFilt,
                                                   rLocFilt :  Str10;
                                                   StkFilt  :  Str20;
                                                   StkFolio :  LongInt;
                                               Var FoundOk  :  Boolean);

                         Procedure Build_PORRecord(Mode     :  Byte;
                                                   rLocFilt :  Str10;
                                               Var FoundOk  :  Boolean);

                       {$ENDIF}


                       Procedure Build_BinRecord(Mode     :  Byte;
                                                 BINFilt,
                                                 rLocFilt :  Str10;
                                                 StkFilt  :  Str20;
                                                 StkFolio :  LongInt;
                                             Var FoundOk  :  Boolean);

                     public

                       CRepParam  :  BINRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddBIN1Rep2Thread(LMode    :  Byte;
                            IRepParam:  BINRepPtr;
                            AOwner   :  TObject);

Procedure TESTBIN1Rep(LMode    :  Byte;
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
  RpDefine,
  ExtGetU,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U;


{ ========== TBIN1Report. methods =========== }

Constructor TBIN1Report.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  CurrMode:=1;

  BreakCounter:=0;

  ThisScrt:=nil;

end;


Destructor TBIN1Report.Destroy;

Begin
  Dispose(CRepParam);

  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);

  Inherited Destroy;
end;





Procedure TBIN1Report.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,2
         :  With CRepParam^ do
            Begin
              SetTab (MarginLeft, pjLeft, 35, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);

            end;
        3,4
         :  Begin
              SetTab (MarginLeft, pjLeft, 45, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 23, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);

            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;






Procedure TBIN1Report.RepPrintPageHeader;


Var
  ThisRMode  :  Integer;
  LocStr     :  Str10;
  GenStr     :  Str255;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    LocStr:='';  

    {$IFDEF SOP}
      If (Syss.UseMLoc) then
        LocStr:='Loc ';

      GenStr:='Serial/Batch';
    {$ELSE}

      GenStr:='';

    {$ENDIF}

    DefFont(0,[fsBold]);

    Case ReportMode of


      1,2
          :  Begin
               Case ReportMode of
                 1  :  SendText(ConCat(#9,'Stock Code'));
                 2  :  SendText(ConCat(#9,'Bin Code'));
               end; {Case..}

               SendLine(ConCat(#9,#9,'Qty Available',#9,'Orig. Qty',#9,'UoM',#9,'Capacity',#9,'Date In',#9,'In Document',#9,'Use By',#9,'Pick/Hold'));
             end;
      3,4
          :  Begin
               Case ReportMode of
                 3  :  SendText(ConCat(#9,'Stock Code'));
                 4  :  SendText(ConCat(#9,'Bin Code'));
               end; {Case..}

               SendLine(ConCat(#9,#9,'Qty In',#9,'Qty Out',#9,'In Document',#9,'Date In',#9,'Out Document',#9,'Date Out',#9,GenStr));
             end;

    end; {case..}

    DefFont(0,[]);


  end; {With..}
end; {Proc..}





Procedure TBIN1Report.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With RepFiler1 do
  Case ReportMode of
    1,2
       :  If (CurrentPage>1) then
          Begin
            PrintBinLine(0,(CurrentPage>1));
            PrintBinLine(3-ReportMode,(CurrentPage>1));
          end;
    3,4
       :  If (CurrentPage>1) then
          Begin
            PrintBinLine(0,(CurrentPage>1));
            PrintBinLine(5-ReportMode,(CurrentPage>1));
          end;
  end; {Case..}

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TBIN1Report.CalcStkTotals(StkVal,QtyVal     :  Double);


Begin


  With CRepParam^ do
    Case ReportMode of

        1..4
           :  Begin

                BSTot:=BSTot+StkVal;

                RepTot:=RepTot+StkVal;

                RepTotC:=RepTotC+QtyVal;

              end;

    end; {Case..With..}
end;




Procedure TBIN1Report.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case DDMode of
      0  :  Case ReportMode of
              1..4    :  With LMLocCtrl^.brBinRec do
                         Begin
                           SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

                           If (ReportMode In [1,2]) then
                             SendRepDrillDown(6,7,2,brInDoc,InvF,InvOurRefK,0)
                           else
                           Begin
                             SendRepDrillDown(4,5,2,brInDoc,InvF,InvOurRefK,0);
                             SendRepDrillDown(6,7,2,brOutDoc,InvF,InvOurRefK,0);
                           end;

                         end;
            end;
      {$IFDEF SOP}
        1  :  Case ReportMode of
                1..4    :  With LMiscRecs^.SerialRec do
                           Begin
                             SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

                             If (ReportMode In [1,2]) then
                               SendRepDrillDown(6,7,2,InDoc,InvF,InvOurRefK,0)
                             else
                             Begin
                               SendRepDrillDown(4,5,2,InDoc,InvF,InvOurRefK,0);
                               SendRepDrillDown(6,7,2,OutDoc,InvF,InvOurRefK,0);
                             end;

                           end;
              end;

      {$ENDIF}
    end; {Case..}
  end; {With..}
end;

Procedure TBIN1Report.PrintBinLine(GMode    :  Byte;
                                   ContMode :  Boolean);

Var
  FoundOk   :  Boolean;

  NoSpc     :  Byte;

  KeyI,
  KeyChkI   :  Str255;

  LocalStk  :  StockRec;
  LocalMLoc :  MlocRec;

  LevelStr,
  SubHead   :  String;


Begin
  With MTExLocal^,RepFiler1, CRepParam^ do
  Begin
    LocalStk:=LStock;
    LocalMLoc:=LMLocCtrl^;

    NoSpc:=0; LevelStr:='';

    DefFont(0,[fsUnderline,fsBold]);

    Case GMode of
      0  :  Begin
              SubHead:=LastLoc;

              {$IFDEF SOP}
                LGetMainRec(MLocF,Quick_MLKey(LastLoc));

                With LMLocCtrl^.MLocLoc do
                  SubHead:='Locn : '+dbFormatName(loCode,loName);
              {$ENDIF}

            end;
      1  :  Begin
              Begin
                DefFont(0,[fsUnderline]);

                LGetMainRec(StockF,LastStk);

                With LStock do
                  SubHead:=dbFormatName(StockCode,Desc[1]);

                SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,LastStk,StockF,StkCodeK,0);

              end;
            end;
      2  :  Begin
              DefFont(0,[fsUnderline]);

              SubHead:='Bin Code : '+LastBin;
            end;


    end; {Case..}

    If (ContMode) then
      SubHead:=SubHead+'./Cont...';

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
    LStock:=LocalStk;
    LMlocCtrl^:=LocalMLoc;
  end; {With..}
end;



{ ======================= Due Sub / Grand Total ================ }

Procedure TBIN1Report.PrintBINTot(GMode     :  Byte);

Var
  n          :  Byte;
  Dnum       :  Double;
  GenStr     :  Str255;


Begin
  With RepFiler1, CRepParam^ do
  Case ReportMode of
    1,2
       :  Begin
            DefFont(0,[fsBold]);

            Case GMode of
              0,2  :  If (BreakCounter>0) or (ReportMode=2) then
                        DefLine(-2,TabStart(2),TabEnd(2),0);

            end; {Case..}


            Case GMode of
              0  :  BSTot:=RepTot;

            end; {Case..}

            If (BreakCounter>0) or (ReportMode=2)  then
              SendLine(ConCat(ConstStr(#9,1),'Total :'+LastStk,#9,FormatFloat(GenQtyMask,BSTot)));

            BSTot:=0.0;

            DefFont(0,[]);

          end; {Case..}

    3,4
       :  Begin
            DefFont(0,[fsBold]);

            Case GMode of
              0..2  :  If (BreakCounter>0) or (ReportMode=4) then
                         DefLine(-2,TabStart(2),TabEnd(4),0);

            end; {Case..}

            Case GMode of
              0  :  Begin
                      BSTot:=RepTotC;

                      GenStr:='Totals';

                      DefFont(1,[fsBold]);

                    end;

              1  :  With MTExLocal^ do
                    Begin
                      BSTot:=RepTot;

                      GenStr:='Totals';

                      DefFont(0,[fsBold]);

                      {SendRepDrillDown(1,TotTabs,1,FullNOmKey(NomCode),NomF,NomCodeK,0);}

                    end;


            end; {Case..}


            If (BreakCounter>0) or (ReportMode=4) then
              SendLine(ConCat(ConstStr(#9,1),'Totals '+LastStk,#9,FormatFloat(GenQtyMask,BSTot),#9,FormatFloat(GenQtyMask,RepTotC),#9,FormatFloat(GenQtyMask,BSTot-RepTotC)));



            Case GMode of
              0  :  ;  
              1  :  RepTot:=0;

            end; {Case..}

            BSTot:=0.0; RepTotC:=0.0;

            DefFont(0,[]);

          end; {Case..}


  end; {Case..}

end;





{ ======================= Customer End ======================= }


Procedure TBIN1Report.PrintEndPage;
Var

  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  With RepFiler1 do
  Begin

    If (ReportMode In [1..4]) then
    Begin
      PrintBinTot(2);

      {PrintBinTot(0);}
    end;

  end;

  Inherited PrintEndPage;


end;



{ ======================= BIN Line ======================= }


Procedure TBIN1Report.PrintReportLine;

Var
  Rnum,
  Rnum2,
  RnumC,
  OldQty     :  Real;

  Dnum       :  Double;

  UOR,
  n          :  Byte;

  LineTot    :  AgedTyp;

  TBo,
  ForceChange
             :  Boolean;

  BMFlg      :  Char;


  LKitFolio  :  LongInt;
  LKitQty    :  Real;

  GenStr2,
  GenStr     :  Str255;

  DelDate    :  LongDate;

  LocalInv   :  InvRec;


Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0;

    Rnum2:=0;

    RnumC:=0;  Dnum:=0.0;

    OldQty:=0;

    GenStr:=''; GenStr2:='';

    BMFlg:=#32;

    Blank(LineTot,Sizeof(LineTot));

    LKitFolio:=1;

    DelDate:=''; Forcechange:=BOff;

    Case LRepScr^.FileNo of
      MLocF  :  Begin

                  Case ReportMode of
                    1,3
                          :  With LMLocCtrl^.brBinRec  do
                             If (brBinCode1<>LastBin) or (brInMLoc<>LastLoc) or ((LastStk<>LStock.StockCode) and (ReportMode=3) and (BreakCounter>0)) then
                             Begin
                               ForceChange:=(brInMLoc<>LastLoc);

                               If (brBinCode1<>LastBin) or (ForceChange) or ((LastStk<>LStock.StockCode) and (ReportMode=3)) then
                               Begin
                                 If (LastBin<>'') then
                                   PrintBinTot(2);
                               end;

                               If (brInMLoc<>LastLoc) then
                               Begin
                                 LastLoc:=brInMLoc;
                                 // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                                 Self.CRLF;
                                 PrintBinLine(0,BOff);
                               end;

                               If (brBinCode1<>LastBin) or (ForceChange) then
                               Begin
                                 LastBin:=brBinCode1;
                                 PrintBinLine(2,BOff);

                               end;

                               LastStk:=LStock.StockCode;

                               BreakCounter:=0;
                             end
                             else
                               Inc(BreakCounter);
                    2,4
                          :  With LMLocCtrl^.brBinRec  do
                             If (LStock.StockCode<>LastStk) or (brInMLoc<>LastLoc) then
                             Begin
                               ForceChange:=(brInMLoc<>LastLoc);

                               If (LStock.StockCode<>LastStk) or (ForceChange) then
                               Begin
                                 If (LastStk<>'') then
                                   PrintBinTot(2);
                               end;

                               If (brInMLoc<>LastLoc) then
                               Begin
                                 // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                                 Self.CRLF;
                                 LastLoc:=brInMLoc;
                                 PrintBinLine(0,BOff);
                               end;

                               If (LStock.StockCode<>LastStk) or (ForceChange) then
                               Begin
                                 LastStk:=LStock.StockCode;

                                 PrintBinLine(1,BOff);

                               end;
                             end;


                  end; {Case..}


                  SetReportDrillDown(0);

                  Case ReportMode of

                    1,2
                       : Begin

                            With LMLocCtrl^.brBinRec, LStock do
                            Begin
                              Linetot[1]:=brBuyQty-brQtyUsed;

                              LineTot[2]:=brBuyQty;

                              Case ReportMode of
                                1  :  GenStr:=dbFormatName(StockCode,Desc[1]);
                                2  :  GenStr:=brBinCode1;
                              end; {Case..}

                              
                              SendLine(ConCat(#9,GenStr,#9,FormatFloat(GenQtyMask,LineTot[1]),
                                      #9,FormatFloat(GenQtyMask,LineTot[2]),
                                      #9,brUoM,
                                      #9,FormatFloat(GenQtyMask,brBinCap),
                                      #9,POutDate(brDateIn),
                                      #9,brInDoc,
                                      #9,POutDateB(brDateUseX),
                                      #9,Str_BinHoldStatus(brHoldFlg,brTagNo)));




                            end;
                          end;

                    3,4
                        : Begin

                            With LMLocCtrl^.brBinRec, LStock do
                            Begin
                              If (Not brBatchChild) then
                                Linetot[1]:=brBuyQty
                              else
                                LineTot[2]:=brQtyUsed;

                              Case ReportMode of
                                3  :  GenStr:=dbFormatName(StockCode,Desc[1]);
                                4  :  GenStr:=brBinCode1;
                              end; {Case..}

                              
                              SendLine(ConCat(#9,GenStr,#9,FormatBFloat(GenQtyMask,LineTot[1],(brBatchChild)),
                                      #9,FormatBFloat(GenQtyMask,LineTot[2],(Not brBatchChild)),
                                      #9,brInDoc,
                                      #9,POutDate(brDateIn),
                                      #9,brOutDoc,
                                      #9,POutDateB(brDateOut)));


                            end;
                          end;

                  end; {Case..}
                end; {MLocF}
      {$IFDEF SOP}
        MiscF  :  Begin

                    Case ReportMode of
                      1,3
                            :  With LMiscRecs^.SerialRec  do
                               If (InBinCode<>LastBin) or (InMLoc<>LastLoc) or ((LastStk<>LStock.StockCode) and (ReportMode=3) and (BreakCounter>0)) then
                               Begin
                                 ForceChange:=(InMLoc<>LastLoc);

                                 If (InBinCode<>LastBin) or (ForceChange) or ((LastStk<>LStock.StockCode) and (ReportMode=3)) then
                                 Begin
                                   If (LastBin<>'') then
                                     PrintBinTot(2);
                                 end;

                                 If (InMLoc<>LastLoc) then
                                 Begin
                                   LastLoc:=InMLoc;
                                   // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                                   Self.CRLF;
                                   PrintBinLine(0,BOff);
                                 end;

                                 If (InBinCode<>LastBin) or (ForceChange) then
                                 Begin
                                   LastBin:=InBinCode;
                                   PrintBinLine(2,BOff);

                                 end;

                                 LastStk:=LStock.StockCode;

                                 BreakCounter:=0;
                               end
                               else
                                 Inc(BreakCounter);
                      2,4
                            :  With LMiscRecs^.SerialRec  do
                               If (LStock.StockCode<>LastStk) or (InMLoc<>LastLoc) then
                               Begin
                                 ForceChange:=(InMLoc<>LastLoc);

                                 If (LStock.StockCode<>LastStk) or (ForceChange) then
                                 Begin
                                   If (LastStk<>'') then
                                     PrintBinTot(2);
                                 end;

                                 If (InMLoc<>LastLoc) then
                                 Begin
                                   // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                                   Self.CRLF;
                                   LastLoc:=InMLoc;
                                   PrintBinLine(0,BOff);
                                 end;

                                 If (LStock.StockCode<>LastStk) or (ForceChange) then
                                 Begin
                                   LastStk:=LStock.StockCode;

                                   PrintBinLine(1,BOff);

                                 end;
                               end;


                    end; {Case..}


                    SetReportDrillDown(1);

                    Case ReportMode of

                      1,2
                         : Begin

                              With LMiscRecs^.SerialRec, LStock do
                              Begin
                                If (BatchRec) then
                                Begin
                                  Linetot[1]:=BuyQty-QtyUsed;

                                  LineTot[2]:=BuyQty;
                                end
                                else
                                Begin
                                  Linetot[1]:=1.0;

                                  LineTot[2]:=1.0;

                                end;

                                Case ReportMode of
                                  1  :  GenStr:=dbFormatName(StockCode,Desc[1]);
                                  2  :  GenStr:=InBinCode;
                                end; {Case..}

                                If (Not BatchRec) then
                                  GenStr2:=SerialNo
                                else
                                  GenStr2:=SerialNo+'/'+BatchNo;

                                SendLine(ConCat(#9,GenStr,#9,FormatFloat(GenQtyMask,LineTot[1]),
                                        #9,FormatFloat(GenQtyMask,LineTot[2]),
                                        #9,GenStr2,
                                        #9,'Serial/Batch',
                                        #9,POutDate(DateIn),
                                        #9,InDoc,
                                        #9,POutDateB(DateUseX)));




                              end;
                            end;

                      3,4
                          : Begin

                              With LMiscRecs^.SerialRec, LStock do
                              Begin
                                If (Sold) and ((Not BatchRec) or (BatchChild))  then
                                Begin
                                  If (BatchChild) then
                                  Begin
                                    LineTot[2]:=QtyUsed;
                                  end
                                  else
                                  Begin
                                    If (Not BatchRec) then
                                      Linetot[1]:=1.0;

                                    LineTot[2]:=1.0;
                                  end;
                                end
                                else
                                Begin
                                  If (BatchRec) then
                                      Linetot[1]:=BuyQty
                                    else
                                      LineTot[1]:=1.0;
                                end;

                                Case ReportMode of
                                  3  :  GenStr:=dbFormatName(StockCode,Desc[1]);
                                  4  :  GenStr:=InBinCode;
                                end; {Case..}

                                If (Not BatchRec) then
                                  GenStr2:=SerialNo
                                else
                                  GenStr2:=SerialNo+'/'+BatchNo;


                                SendLine(ConCat(#9,GenStr,#9,FormatBFloat(GenQtyMask,LineTot[1],(LineTot[1]=0.0)),
                                        #9,FormatBFloat(GenQtyMask,LineTot[2],(LineTot[2]=0.0)),
                                        #9,InDoc,
                                        #9,POutDate(DateIn),
                                        #9,OutDoc,
                                        #9,POutDateB(DateOut),
                                        #9,GenStr2));


                              end;
                            end;

                    end; {Case..}
                  end; {MiscF}
                {$ENDIF}
    end; {Case..}

    CalcStkTotals(LineTot[1],LineTot[2]);

  end;
end;






{ ======================= Customer Include ======================= }


Function TBIN1Report.IncludeRecord  :  Boolean;


Const
  Fnum2   =  StockF;
  Keypath2=  StkFolioK;

Var
  TmpInclude,
  TBo        :  Boolean;
  KeyInv,
  KeyCS      :  Str255;


Begin
  TmpInclude:=BOff;

  TBo:=BOff;


  {$B-}

  With MTExLocal^, CRepParam^ do
  Case ReportMode of
        1..4
           :  Begin
                If (Assigned(ThisScrt)) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);

                With LRepScr^ do
                Begin
                  Case FileNo of
                    MLocF  :  KeyCS:=FullNOMKey(LMLocCtrl^.brBinRec.brStkFolio);

                    {$IFDEF SOP}
                      MiscF  :  Begin
                                  KeyCS:=FullNOMKey(LMiscRecs^.SerialRec.StkFolio);

                                  With LMiscRecs^.SerialRec do
                                  Begin
                                    If (DateIn='') then
                                    Begin
                                      KeyInv:=InDoc;

                                      LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyInv);

                                      If (LStatusOk) then
                                        DateIn:=LInv.TransDate;
                                    end;
                                  end;{With..}  
                                end;
                    {$ENDIF}
                  end;


                  LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyCS);
                end;

                TmpInclude:=LStatusOk;
              end;

      end; {Case..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TBIN1Report.GetReportInput  :  Boolean;

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

    Case ReportMode of

       1..4
            :   Begin
                  ThTitle:='Bin Report';

                  ROrient:=RPDefine.PoPortrait;
                  Case ReportMode of
                    1
                       :  Begin
                            RepTitle:='Stock Availability by Bin Code Report';

                          end;
                    2  :  Begin
                            RepTitle:='Bin Stock Availability by Stock Code Report';
                          end;
                    3
                       :  Begin
                            RepTitle:='Stock by Bin Code History Report';

                          end;
                    4  :  Begin
                            RepTitle:='Bin by Stock Code History Report';
                          end;
                  end; {Case..}

                  
                  If (ReportMode in [3,4]) then
                  Begin
                    RepTitle:=RepTitle+'. '+POutDate(SDate)+' - '+POutDate(EDate);
                  end;

                  PageTitle:=RepTitle;

                  RFont.Size:=8;

                  RFnum:=ReportF;

                  RKeyPath:=RpK;

                  RepTitle2:='';

                  If (Not EmptyKey(StockFilt,StkKeyLen)) then
                  Begin
                    GetStock(Application.MainForm,FullStockCode(StockFilt),FoundCode,-1);
                    SStock:=Stock;
                  end;

                  {$IFDEF SOP}
                     If (Not EmptyKey(LocFilt,LocKeyLen)) then
                     Begin
                       SLocTit:=MLocRepTitle(LocFilt);
                     end;

                     If (OrdRef<>'') then
                       SLocTit:=SLocTit+'. For Order '+Trim(OrdRef);
                  {$ENDIF}

                  If (Not EmptyKey(StockFilt,StkKeyLen)) then
                    RepTitle2:=RepTitle2+' Stock Filter: '+Strip('B',[#32],SStock.Desc[1])+'.';

                  If (SLocTit<>'') then
                    RepTitle2:=RepTitle2+' '+SLocTit+'.';

                  If (BinFilt<>'') then
                    RepTitle2:=RepTitle2+' Bin Filter : '+BinFilt+'.';

                  If (TagFilt<>0) then
                    RepTitle2:=RepTitle2+' Tag Filter : '+IntToStr(TagFilt)+'.';
                end;


    end; {Case..}




  end; {With..}

  Result:=BOn;
end;


{$IFDEF SOP}

  { =========== Proc to Scan and Build Serial No. elements ========= }

  Procedure TBIN1Report.Build_SNORecord(Mode     :  Byte;
                                        BinFilt,
                                        rLocFilt :  Str10;
                                        StkFilt  :  Str20;
                                        StkFolio :  LongInt;
                                    Var FoundOk  :  Boolean);

  Const
    Fnum    =  MiscF;


    Fnum2   =  StockF;
    Keypath2=  StkFolioK;



  Var
    KeyCS,
    KeyChk,
    KeyInv   :  Str255;

    Keypath  :  Integer;

    RecAddr  :  LongInt;

    SortStr,
    MatchStr :  Str255;

    TmpInclude,
    TBo      :  Boolean;



  Begin

    With MTExLocal^,CRepParam^ do
    Begin

      KeyChk:=MFIFOCode+MSernSub;


      If (StkFolio<>0) then
      Begin
        Keypath:=MIK;
        KeyChk:=KeyChk+FullNomKey(StkFolio);;

        If (ReportMode In [1,2]) then {* We can exclude sold lines *}
          KeyChk:=KeyChk+Chr(0);
      end
      else
        Keypath:=MiscNDXK;

      KeyCS:=KeyChk;

      RecAddr:=0;  TBo:=Boff;

      {FoundOk:=BOff;}
      TmpInclude:=BOff;

      ShowStatus(2,'Please Wait, Building Serial Report');

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
      With LMiscRecs^.SerialRec  do
      Begin
        KeyInv:=FullNOMKey(StkFolio);

        LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

        {$B-}

          TmpInclude:=(LStatusOk) and (CheckKey(StkFilt,LStock.StockCode,Length(StkFilt),BOff) or Stk_InGroup(StkFilt,LStock))
          and (CheckKey(rLocFilt,InMLoc,Length(rLocFilt),BOff)) and (CheckKey(BinFilt,InBinCode,Length(BinFilt),BOff)) and (Not EmptyKey(InBinCode,BinKeyLen));


          If (TmpInclude) then
          Begin

            Case ReportMode of
              1,2  :  TmpInclude:=TmpInclude and (Not BatchChild) and (Not Sold);
              3,4  :  Begin
                        If (DateIn='') then
                        Begin
                          KeyInv:=InDoc;

                          LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyInv);

                          If (LStatusOk) then
                            DateIn:=LInv.TransDate;
                        end;

                        TmpInclude:=TmpInclude and (((DateOut>=SDate) and (DateOut<=EDate)) or ((DateIn>=SDate) and (DateIn<=EDate) and (Not BatchChild)));
                      end;
            end; {case..}
          end;
        {$B+}


        If (TmpInclude) then
        Begin
          LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

          MatchStr:='';

          Case ReportMode of
            1,3  :  SortStr:=Full_MLocKey(InMLoc)+FullBinCode(InBinCode)+LStock.StockCode;
            2,4  :  SortStr:=Full_MLocKey(InMLoc)+LStock.StockCode+FullBinCode(InBinCode);
          end; {Case..}

          If (BatchChild) or (Sold) then
            SortStr:=SortStr+DateOut
          else
            SortStr:=SortStr+DateIn;

          ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,SortStr,MatchStr);

          FoundOk:=BOn;
        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

      end; {While..}


    end; {With..}


  end; {Proc..}


  { =========== Proc to Scan and Build POR Elements ========= }

  Procedure TBIN1Report.Build_PORRecord(Mode      :  Byte;
                                        rLocFilt  :  Str10;
                                    Var FoundOk   :  Boolean);

  Const
    Fnum    =  IdetailF;
    Keypath =  IdFolioK;


    Fnum2   =  InvF;
    Keypath2=  InvOurRefK;



  Var
    KeyCS,
    KeyChk,
    KeyInv   :  Str255;

    TmpInclude,
    TBo      :  Boolean;



  Begin

    With MTExLocal^,CRepParam^ do
    Begin

      KeyInv:=OrdRef;

      LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

      If (LStatusOk) then
      Begin

        KeyChk:=FullNomKey(LInv.FolioNum);

        KeyCS:=KeyChk;

        TBo:=Boff; FoundOk:=BOff;

        TmpInclude:=BOff;

        ShowStatus(2,'Please Wait, Building Order Report');

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
        With LId  do
        Begin
          If (Is_FullStkCode(StockCode)) then
          Begin
            KeyInv:=FullStockCode(StockCode);



          {$B-}

            TmpInclude:=(LGetMainRec(StockF,KeyInv)) and (CheckKey(rLocFilt,MLocStk,Length(rLocFilt),BOff));


            If (TmpInclude) then
            Begin
              Build_BinRecord(Mode,'',MLocStk,'',LStock.StockFolio,FoundOK);

            end;
          {$B+}
         end;


          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

        end; {While..}

      end; {If found ok...}
    end; {With..}


  end; {Proc..}
{$ENDIF}



{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TBIN1Report.Build_BinRecord(Mode     :  Byte;
                                      BinFilt,
                                      rLocFilt :  Str10;
                                      StkFilt  :  Str20;
                                      StkFolio :  LongInt;
                                  Var FoundOk  :  Boolean);

Const
  Fnum    =  MLocF;

  Fnum2   =  StockF;
  Keypath2=  StkFolioK;



Var
  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  Keypath  :  Integer;

  RecAddr  :  LongInt;

  SortStr,
  MatchStr :  Str255;

  TmpInclude,
  TBo      :  Boolean;



Begin
  KeyPath := 0;
  With MTExLocal^,CRepParam^ do
  Begin

    KeyChk:=brRecCode+MSernSub;

    If (Not EmptyKey(BinFilt,BinKeyLen)) then
    Begin
      Keypath:=MLK;
      KeyChk:=KeyChk+BinFilt;
    end
    else
      If (Not EmptyKey(rLocFilt,MlocKeyLen)) then
      Begin

        If (StkFolio<>0) then
        Begin
          Keypath:=MLSecK;
          KeyChk:=KeyChk+FullNomKey(StkFolio)+rLocFilt;

          If (ReportMode In [1,2]) then {* We can exclude sold lines *}
            KeyChk:=KeyChk+Chr(0);
        end
        else
        Begin
          Keypath:=MLSuppK;
          KeyChk:=KeyChk+rLocFilt;
        end;
      end
      else
        If (StkFolio<>0) then
        Begin
          Keypath:=MLSecK;
          KeyChk:=KeyChk+FullNomKey(StkFolio);;

        end;

    KeyCS:=KeyChk;

    RecAddr:=0;  TBo:=Boff;

    FoundOk:=BOff;
    TmpInclude:=BOff;

    ShowStatus(2,'Please Wait, Building Report');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LMLocCtrl^.brBinRec  do
    Begin
      KeyInv:=FullNOMKey(brStkFolio);

      LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

      {$B-}

        TmpInclude:=(LStatusOk) and (CheckKey(StkFilt,LStock.StockCode,Length(StkFilt),BOff) or Stk_InGroup(StkFilt,LStock))
        and (CheckKey(rLocFilt,brInMLoc,Length(rLocFilt),BOff))
        and ((AnalOrd=0) or ((Not (brHoldFlg In [1,2])) and (AnalOrd=1)) or ((brHoldFlg In [1,2]) and (AnalOrd=2)))
        and ((TagFilt=0) or (TagFilt=brTagNo))
        and ((brBinCap=0) or (OrdRef='') or ((brBinCap-(brBuyQty-brQtyUsed)>0))); {If driven by order only show bins with some capacity}

        Case ReportMode of
          1,2  :  TmpInclude:=TmpInclude and (Not brBatchChild);
          3,4  :  TmpInclude:=TmpInclude and (((brDateOut>=SDate) and (brDateOut<=EDate) and (brBatchChild)) or ((brDateIn>=SDate) and (brDateIn<=EDate) and (Not brBatchChild)));
        end; {case..}

      {$B+}


      If (TmpInclude) then
      Begin
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        MatchStr:='';

        Case ReportMode of
          1,3  :  SortStr:=Full_MLocKey(brInMLoc)+FullBinCode(brBinCode1)+LStock.StockCode;
          2,4  :  SortStr:=Full_MLocKey(brInMLoc)+LStock.StockCode+FullBinCode(brBinCode1);
        end; {Case..}

        If (brBatchChild) then
          SortStr:=SortStr+brDateOut
        else
          SortStr:=SortStr+brDateIn;

        ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,SortStr,MatchStr);

        FoundOk:=BOn;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    {$IFDEF SOP}
      If (AnalOrd<>2) then
        Build_SNORecord(Mode,BinFilt,rLocFilt,StkFilt,StkFolio,FoundOk);
    {$ENDIF}

  end; {With..}
end; {Proc..}




Procedure TBIN1Report.Process;

Var
  FoundOk  :  Boolean;

Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}
  InitStatusMemo(4);

  ShowStatus(0,RepTitle);

  New(ThisScrt,Init(23,MTExLocal,BOff));

  RepKey:=FullNomKey(ThisScrt^.Process);

  With CRepParam^ do
  {$IFDEF SOP}
    If (OrdRef<>'') then
      Build_PORRecord(0,LocFilt,FoundOk)
    else
      Build_BinRecord(0,BinFilt,LocFilt,StockFilt,StkFolioFilt,FoundOK);

  {$ELSE}
    Build_BinRecord(0,BinFilt,LocFilt,StockFilt,StkFolioFilt,FoundOK);

  {$ENDIF}

  Inherited Process;

end;


Procedure TBIN1Report.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddBIN1Rep2Thread(LMode    :  Byte;
                            IRepParam:  BINRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TBIN1Report;

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

{Test BIN Report, Mode 1}

Procedure TESTBIN1Rep(LMode    :  Byte;
                      AOwner   :  TObject);


Var
  IRepParam:  BINRepPtr;

Begin
  New(IRepParam);

  FillChar(IRepParam^,Sizeof(IRepParam^),#0);

  With IRepParam^ do
  Begin
    SDate:='20030101'; EDate:='20031231';  FiltOrd:=0;
    RPr:=01; RYr:=99; RPr2:=12; RYr2:=109;

    AddBIN1Rep2Thread(LMode,IRepParam,AOwner);
  end;

  Dispose(IRepParam);
end;


Initialization



Finalization

end.