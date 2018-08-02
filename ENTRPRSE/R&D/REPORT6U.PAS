unit Report6U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU,

  //PR: 09/02/2012 ABSEXCH-9795
     QtyBreakVar;


type

  TStkReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepPrint(Sender  :  TObject); Virtual;


                     private


                       
                       Procedure PrintAllStkTots;

                       

                       Procedure PrintStkPList;

                       Procedure GetPR_YTD_Hist(PrMode,
                                                Base     :  Byte);

                       
                       Procedure StkDetail(Bot        :  Boolean); Virtual;

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  StkRepRecPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Control_YTDHist; Virtual;

                       {$IFDEF PF_On}

                         Function Calc_AccDMatch(TStock  :  StockRec;
                                                 TCust   :  CustRec;
                                                 TCurr   :  Byte;
                                                 TDate   :  LongDate;
                                                 Fnum,
                                                 Keypath :  Integer)  :  Boolean;


                         Function Get_DiscTree(Scode  :  Str20)  :  Boolean;


                         Function Calc_QtyBreak(TStock  :  StockRec;
                                                TCust   :  CustRec;
                                                TCurr   :  Byte;
                                                TQty    :  Real;
                                                TDate   :  LongDate;

                                                Fnum,
                                                Keypath :  Integer;
                                                Mode    :  Byte)  :  Boolean;

                         //PR: 09/02/2012 Amended function to use new Qty Breaks file ABSEXCH-9795
                         Procedure Calc_UPriceDisc(TStock  :  StockRec;
                                                   DiscRec :  MiscRec;
                                                   TCurr   :  Byte;
                                                   TQty    :  Real;
                                               Var UPrice,
                                                   DiscR   :  Real;
                                               Var DiscCh  :  Char;
                                             Const LCode   :  Str10;
                                                   Mode    :  Byte;
                                                   QBRec   :  TQtyBreakRec);

                         Procedure Calc_StockPrice(TStock  :  StockRec;
                                                   TCust   :  CustRec;
                                                   TCurr   :  Byte;
                                                   TQty    :  Real;
                                                   TDate   :  LongDate;
                                               Var UPrice,
                                                   DiscR   :  Real;
                                               Var DiscCh  :  Char;
                                             Const LCode   :  Str10;
                                               Var FoundOk :  Boolean);
                       {$ENDIF}
                       Procedure GrandStkTotals(Var GTot   :  StkRepAry;
                                                    NTot   :  StkRepAry;
                                                    Ns,Ne  :  Byte;
                                                    Deduct :  Boolean);

                       Function IsOktoNom(NCode      :  Str20)  :  Boolean; Virtual;

                       Procedure PrintStkTotals(Ntotals  :  StkRepAry;
                                                TCr,TxCr,
                                                GMode    :  Byte); Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte);  Virtual;

                       Procedure PrintStkDet(Bot        :  Boolean);

                       Procedure Check4Range(NCode      :  Str20); Virtual;

                       Procedure FollowChain(LevelKey  :  Str20); Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}



  Var
    QtyTOfSet,
    TOOfset,
    COOfset   :  Integer;



Procedure AddStkRep2Thread(LMode    :  Byte;
                           IRepParam:  StkRepRecPtr;
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
  SalTxl1U,
  InvListU,
  RpDefine,
  {$IFDEF PF_On}

    InvCt2SU,

  {$ENDIF}

  Report4U,

  ExThrd2U;



{ ========== TStkReport methods =========== }

Constructor TStkReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

end;


Destructor TStkReport.Destroy;

Begin

  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TStkReport.Process;

Begin
  Inherited Process;
end;



Procedure TStkReport.RepSetTabs;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    ClearTabs;

    Case ReportMode of
        1,2  :  Begin
                  SetTab (MarginLeft, pjLeft, 16, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,14, 4, 0, 0);
                  SetTab (NA, pjRight,22, 4, 0, 0);
                  SetTab (NA, pjRight,29, 4, 0, 0);
                  SetTab (NA, pjRight,29, 4, 0, 0);
                  SetTab (NA, pjRight,19, 4, 0, 0);

                end;

        8..10
            :   Begin
                  Case SubMode of
                     1  :  Begin
                             SetTab (MarginLeft, pjLeft, 60, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjRight,20, 4, 0, 0);
                             SetTab (NA, pjLeft,16, 4, 0, 0);
                           end;
                     2,3
                        :  Begin
                             SetTab (MarginLeft, pjLeft, 43, 4, 0, 0);
                             SetTab (NA, pjLeft,60, 4, 0, 0);
                             SetTab (NA, pjRight,30, 4, 0, 0);
                             SetTab (NA, pjLeft,15, 4, 0, 0);
                           end;
                  end;
                end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TStkReport.RepPrintPageHeader;

Var
  n,m     :  SmallInt;
  GenStr,
  GenStr2 :  Str255;

Begin

  With RepFiler1,CRepParam^ do
  Begin


    DefFont(0,[fsBold]);

    GenStr:='';


    Case ReportMode of

      1,2
         :  Begin
              SendText(ConCat(#9,'Periods.:'));


              m:=PrS;

              For n:=1 to 12 do
              Begin
                          {* Note Use of PPr *}

                If (m>0) then
                  GenStr2:=PPr_Pr(m)
                else
                  GenStr2:='***';

                SendText(Concat(ConstStr(#9,n+1),GenStr2));

                If (m>0) then
                  Inc(m);

                If (m>PrE) or (m>Syss.PrInYr) then
                  m:=0;


              end;

              SendLine(ConCat(ConstStr(#9,14),'Total',#9,'Sales',#9,'Margin',#9,'GP%'));

            end;


      8..10
           :   Begin


                 Case SubMode of
                   1  :  Begin

                           SendLine(ConCat(#9,'Stock Code/Desc',#9,'Band A',
                                           #9,'Band B',#9,'Band C',#9,'Band D',
                                           #9,'Band E',#9,'Band F',#9,'Band G',
                                           #9,'Band H'));



                         end;

                   2,3
                      :  Begin

                           SendLine(ConCat(#9,'Stock Code',#9,'Description',#9,'Price',#9,'Unit'));


                         end;

                 end; {Case..}

               end;

    end; {Case..}


    DefFont(0,[]);
  end; {With..}
end; {Proc..}




Procedure TStkReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

end;



{ ============= Print Remaining Common Totals Line ============ }

Procedure TStkReport.PrintStkTotals(Ntotals  :  StkRepAry;
                                    TCr,TxCr,
                                    GMode    :  Byte);

Const
  TotTit  :  Array[1..4] of Str30 = ('Actual','Forecast','Differnce','Totals');


Var
  CSymb  :  Str5;

  GenStr :  Str255;

  Profit,
  GP     :  Real;

  n      :  Byte;

Begin

  GP:=0;
  Profit:=0;

  CSymb:=PSymb(TCr);

  With RepFiler1 do
  Case GMode of
    1..4
       :  Begin


            GenStr:=TotTit[GMode]+ConstStr('.',15-Length(TotTit[GMode]))+':';

            SetReportDrillDown(1);

            SendText(ConCat(#9,GenStr));

            For n:=1 to (MaxNoStkTots-3) do
              SendText(ConCat(ConstStr(#9,n+1),FormatFloat(GenRealMask,NTotals[n])));

            NTotals[TOOfSet]:=Currency_Txlate(NTotals[TOOFset],TCr,TxCr);

            NTotals[COOfSet]:=Currency_Txlate(NTotals[COOFset],TCr,TxCr);


            Profit:=NTotals[TOOfset]-NTotals[COOfset];

            GP:=Calc_Pcnt(NTotals[TOOfset],Profit);


            SendLine(Concat(ConstStr(#9,15),FormatFloat(GenRealMask,NTotals[TOOfset]),
                            #9,FormatFloat(GenRealMask,Profit),
                            #9,FormatFloat(GenPcntMask,Gp)));
          end;


  end; {Case..}

end;


{ ===== Procedure to Add one total to another ====== }

Procedure TStkReport.GrandStkTotals(Var GTot   :  StkRepAry;
                                        NTot   :  StkRepAry;
                                        Ns,Ne  :  Byte;
                                    Deduct     :  Boolean);



Var
  n      :  Byte;

  Dcnst  :  Integer;



Begin

  If (Deduct) then
    Dcnst:=-1
  else
    Dcnst:=1;


  For n:=Ns to Ne do
    Gtot[n]:=Gtot[n]+(Ntot[n]*Dcnst);

end; {Proc..}



{ ============= Procedure to Print all stock details ======== }


Procedure TStkReport.PrintAllStkTots;

Var
  n  :  Byte;

  TmpTot
     :  StkRepAry;

  IncTot
     :  Boolean;


Begin

  n:=1;

  For n:=1 to 3 do
  With CRepParam^ do
  Begin

    IncTot:=BOff;

    Case n of

      1  :  Begin
              TmpTot:=NTotals;
              IncTot:=BOn;
            end;

      2  :  Begin
              TmpTot:=BTotals;

              IncTot:=ShowBudg;
            end;

      3  :  Begin

              TmpTot:=NTotals;

              TmpTot[TOOfset]:=0;

              TmpTot[COOfset]:=0;

              GrandStkTotals(TmpTot,BTotals,1,QtyTOfset,BOn);

              IncTot:=ShowBudg;

            end;

    end; {Case..}

    If (IncTot) then
      PrintStkTotals(TmpTot,FCr,FTxCr,n);
  end; {Loop..}
end; {Proc..}




{$IFDEF PF_On}

  { ========= Function to find Account Discount match ========== }

  { Note: Duplicated in SalePric.Pas for OLE Server }
  Function TStkReport.Calc_AccDMatch(TStock  :  StockRec;
                                     TCust   :  CustRec;
                                     TCurr   :  Byte;
                                     TDate   :  LongDate;
                                     Fnum,
                                     Keypath :  Integer)  :  Boolean;




  Var
    KeyMS,
    KeyChk    :  Str255;

    DefFound,
    FoundOk   :  Boolean;

    TmpMisc   :  MiscRec;



  Begin
    FoundOk:=BOff; DefFound:=BOff;

    KeyChk:=FullQDKey(CDDiscCode,TCust.CustSupp,MakeCDKey(TCust.CustCode,TStock.StockCode,TCurr));

    KeyMS:=KeyChk;

    With MTExLocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyMS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyMS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With LMiscRecs^.CustDiscRec do
      Begin
        FoundOk:=(Not CUseDates) or ((TDate>=CStartD) and (TDate<=CEndD));

        If (FoundOk) and (Not CUseDates) and (Not DefFound) then {* See if there are others *}
        Begin
          DefFound:=BOn;
          FoundOk:=BOff;
          TmpMisc:=LMiscRecs^;
        end;

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyMS);

      end;
      If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
      Begin
        LMiscRecs^:=TmpMisc;
        FoundOk:=Bon;
      end;

    end; {With..}


    Result:=FoundOk;

    
  end;



  { ======= Function to Return next item up the tree ====== }


  { Note: Duplicated in SalePric.Pas for OLE Server }
  Function TStkReport.Get_DiscTree(Scode  :  Str20)  :  Boolean;

  Begin

    If (Not EmptyKey(Scode,StkKeyLen)) then
    With MTExLocal^ do
      Get_DiscTree:=LCheckRecExsists(Strip('R',[#0],Scode),StockF,StkCodeK)
    else
      Get_DiscTree:=BOff;

  end; {Func..}


  { ======= Function to Match Qty Break ======== }

  { Note: Duplicated in SalePric.Pas for OLE Server }
  Function TStkReport.Calc_QtyBreak(TStock  :  StockRec;
                                    TCust   :  CustRec;
                                    TCurr   :  Byte;
                                    TQty    :  Real;
                                    TDate   :  LongDate;
                                    Fnum,
                                    Keypath :  Integer;
                                    Mode    :  Byte)  :  Boolean;




  Var
    KeyS2,
    KeyChk  :  Str255;

    DefFound,
    FoundOk :  Boolean;

    TmpMisc :  MiscRec;

  Begin

    FoundOk:=BOff; DefFound:=BOff;

    Case Mode of

      1  :  KeyChk:=FullQDKey(QBDiscCode,QBDiscSub,FullNomKey(TStock.StockFolio)+Chr(TCurr));
      2  :  KeyChk:=FullQDKey(QBDiscCode,TCust.CustSupp,FullCDKey(TCust.CustCode,TStock.StockFolio)+Chr(TCurr));

    end; {Case..}

    KeyS2:=KeyChk;

    With MTExlocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS2);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (Not FoundOk) do
      With LMiscRecs^ do
      With QtyDiscRec do
      Begin

        FoundOk:=((TQty>=FQB) and (TQty<=TQB)) and ((Mode=2) or (Not QUseDates) or ((TDate>=QStartD) and (TDate<=QEndD)));

        If (FoundOk) and (Not QUseDates) and (Not DefFound) and (Mode<>2) then {* See if there are others *}
        Begin
          DefFound:=BOn;
          FoundOk:=BOff;
          TmpMisc:=LMiscRecs^;
        end;

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS2);

      end; {While.}

      If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
      Begin
        LMiscRecs^:=TmpMisc;
        FoundOk:=Bon;
      end;

    end; {With..}


    Calc_QtyBreak:=FoundOk;

  end; {Func..}



  { ======== Function to Convert Discount Record in to unit price and discount ======= }

  { Note: Duplicated in SalePric.Pas for OLE Server }
  //PR: 09/02/2012 Amended function to use new Qty Breaks file ABSEXCH-9795
  Procedure TStkReport.Calc_UPriceDisc(TStock  :  StockRec;
                                       DiscRec :  MiscRec;
                                       TCurr   :  Byte;
                                       TQty    :  Real;
                                   Var UPrice,
                                       DiscR   :  Real;
                                   Var DiscCh  :  Char;
                                 Const LCode   :  Str10;
                                       Mode    :  Byte;
                                       QBRec   :  TQtyBreakRec);



  Var
    DiscTyp,
    DiscBand :  Char;
    DiscCurr :  Byte;

    SPrice,
    CPrice,
    DiscPC,
    DiscAM,
    DiscMU,
    Rnum    :  Real;


  Begin                                                                     

    DiscR:=0;
    DiscCh:=C0;
    UPrice:=0;

    Rnum:=0;

    With DiscRec do
    Case Mode of

      1  :  With QBRec do
            Begin
              //PR: 09/02/2012 ABSEXCH-9795
              DiscTyp := DiscountCharFromBreakType(qbBreakType);
              DiscBand:= qbPriceBand;

              SPrice:= qbSpecialPrice;
              DiscPC:= qbDiscountPercent;
              DiscAM:= qbDiscountAmount;
              DiscMU:= qbMarginOrMarkup;

              DiscCurr := qbCurrency;
            end;

      2  :  With CustDiscRec do
            Begin

              DiscTyp:=QBType;
              DiscBand:=QBand;                               

              SPrice:=QSPrice;
              DiscPC:=QDiscP;
              DiscAM:=QDiscA;
              DiscMU:=QMUMG;
              DiscCurr:=QBCurr;

            end;
         else  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390
           raise Exception.Create('Invalid Mode in TStkReport.Calc_UPriceDisc: ' + IntToStr(Mode));

    end; {Case..}

    Case DiscTyp of

      QBPriceCode  :  Begin
                        UPrice:=Currency_ConvFT(SPrice,DiscCurr,TCurr,UseCoDayRate);
                      end;

      QBBandCode   :  Begin
                        {$IFDEF SOP}
                          MTExLocal^.LStock_LocPSubst(TStock,LCode);
                        {$ENDIF}

                        UPrice:=Get_StkPrice(TStock.SaleBands,0,DiscBand,TCurr,1,1,TStock.CalcPack);

                        If (DiscPC<>0) or (DiscAm<>0) then
                        Begin
                          If (DiscPC<>0) then
                          Begin
                            DiscCh:=PcntChr;
                            DiscR:=Pcnt(DiscPC);
                          end
                          else
                            DiscR:=DiscAM;
                        end
                        else
                          DiscCh:=DiscBand;

                      end;

      QBMarkUpCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          MTExLocal^.LStock_LocCSubst(TStock,LCode);
                        {$ENDIF}

                        {CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1); Cannot use this here, as would effect main thread}

                        CPrice:=Calc_StkCP(TStock.CostPrice,TStock.BuyUnit,TStock.CalcPack);

                        CPrice:=Currency_ConvFT(Calc_IdQty(CPrice,1,Not TStock.CalcPack),TStock.PCurrency,TCurr,UseCoDayRate);

                        {* To be replaced by FIFO *}

                        UPrice:=Round_Up(Calc_IdQty(CPrice*(1+Pcnt(DiscMU)),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

      QBMarginCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          MTExLocal^.LStock_LocCSubst(TStock,LCode);
                        {$ENDIF}

                        Rnum:=DiscMU;

                        If (Rnum>=100) then
                          Rnum:=99.99;

                        {CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1);}

                        CPrice:=Calc_StkCP(TStock.CostPrice,TStock.BuyUnit,TStock.CalcPack);

                        CPrice:=Currency_ConvFT(Calc_IdQty(CPrice,1,Not TStock.CalcPack),TStock.PCurrency,TCurr,UseCoDayRate);

                        UPrice:=Round_Up(Calc_IdQty(DivWChk(CPrice,(1-Pcnt(Rnum))),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

    end; {Case..}

  end; {Proc..}



  { ============ Function to search for a matching discount ============= }

  { Note: Duplicated in SalePric.Pas for OLE Server }
  Procedure TStkReport.Calc_StockPrice(TStock  :  StockRec;
                                       TCust   :  CustRec;
                                       TCurr   :  Byte;
                                       TQty    :  Real;
                                       TDate   :  LongDate;
                                   Var UPrice,
                                       DiscR   :  Real;
                                   Var DiscCh  :  Char;
                                 Const LCode   :  Str10;
                                   Var FoundOk :  Boolean);



  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;


  Var
    Loop,
    TreeLoop,
    SetAny    :  Boolean;

    LCurr,
    Mode      :  Byte;

    FoundCode :  Str20;
    KeyS2      :  Str255;

  Begin

    SetAny:=FoundOk;

    FoundOk:=BOff;

    TreeLoop:=BOn;

    LCurr:=TCurr;

    Blank(KeyS2,Sizeof(KeyS2));

    Mode:=2;


    {$IFDEF MC_On}

      Loop:=BOff;

    {$ELSE}

      Loop:=BOn;

      LCurr:=0;

    {$ENDIF}

    With MTExLocal^ do
    Begin


      Repeat

          {* Search for an exact match *}

        FoundOk:=Calc_AccDMatch(TStock,TCust,LCurr,TDate,Fnum,Keypath);

        LStock:=TStock;

        If (Not FoundOk) then {* Search for a match via the tree *}
        Repeat

          TreeLoop:=Get_DiscTree(LStock.StockCat);

          If (TreeLoop) then
          Begin

            FoundOk:=Calc_AccDMatch(LStock,TCust,LCurr,TDate,Fnum,Keypath);

          end;

        Until (Not TreeLoop) or (FoundOk);

        LCurr:=0;

        Loop:=Not Loop;  {* Repeat for Currecncy 0 *}


        LStock:=TStock;

      Until (FoundOk) or (Not Loop);

      If (Not FoundOk) then {* Search for product QB match *}
      Begin


        If (TCust.CustSupp=TradeCode[BOn]) then
        Begin

          Mode:=1;

          LCurr:=TCurr;


          {$IFDEF MC_On}

            Loop:=BOff;

          {$ELSE}

            Loop:=BOn;

          {$ENDIF}


          Repeat

            FoundOk:=Calc_QtyBreak(TStock,TCust,LCurr,TQty,TDate,Fnum,Keypath,Mode);

            LCurr:=0;

            Loop:=Not Loop;

          Until (Not Loop) or (FoundOk);

        end; {If Supplier..}

      end {If not found..}
      else
      Begin


        If (LMiscRecs^.CustDiscRec.QBType=QBQtyBCode) then {* Search for subsequent qty break *}
        Begin

          Mode:=1;

          LCurr:=TCurr;

          KeyS2:=LMiscRecs^.CustDiscRec.QStkCode;

          LGetMainRec(StockF,KeyS2);

          {$IFDEF MC_On}

            Loop:=BOff;

          {$ELSE}

            Loop:=BOn;

          {$ENDIF}

          Repeat

            FoundOk:=Calc_QtyBreak(LStock,TCust,LCurr,TQty,TDate,Fnum,Keypath,2);

            LCurr:=0;

            Loop:=Not Loop;

          Until (Not Loop) or (FoundOk);

        end; {Acc Qty break}

      end; {FoundOk..}

      If (FoundOk) then  //PR: 09/02/2012 Amended to use new Qty Breaks file ABSEXCH-9795
        Calc_UPriceDisc(TStock,LMiscRecs^,TCurr,TQty,UPrice,DiscR,DiscCh,LCode,Mode, QtyBreakRec)
      else
      Begin

        If (SetAny) then  {* Only set values if allowed *}
        Begin
          If (TCust.CustSupp<>TradeCode[BOff]) then
          Begin
            {$IFDEF SOP}
              MTExLocal^.LStock_LocPSubst(TStock,LCode);
            {$ENDIF}



            With TCust do
            Begin
              If (DiscR<>Discount) then
                DiscR:=Discount;

              If (DiscCh<>CDiscCh) then
                DiscCh:=CDiscCh;
            end;

            UPrice:=Get_StkPrice(TStock.SaleBands,DiscR,DiscCh,TCurr,1,1,TStock.CalcPack);

          end
          else
          Begin
            {$IFDEF SOP}
              MTExLocal^.LStock_LocROCPSubst(TStock,LCode);
            {$ENDIF}

            UPrice:=Currency_ConvFT(TStock.ROCPrice,TStock.ROCurrency,TCurr,UseCoDayRate);
          end;  
        end;

      end;


      LStock:=TStock;
    end; {With..}
  end; {Proc..}

{$ENDIF}


Procedure TStkReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin

    SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,DDMode);
  end; {With..}
end;


{ ============= Procedure to Print one line of price list ========== }


Procedure TStkReport.PrintStkPList;

Var
  N,TmpCr     :  Byte;

  Band        :  Integer;

  GenStr      :  Str255;

  TBo         :  Boolean;

  DiscCh      :  Char;

  Disc,
  CurrEquiv   :  Real;

Begin

  GenStr:='';

  TBo:=BOn;

  Disc:=0; DiscCh:=#0;

  SetReportDrillDown(0);


  With MTExLocal^,LStock do
    With CRepParam^,RepFiler1 do
    Begin
      {$IFDEF SOP}

        LStock_LocPSubst(LStock,LocFilt);

      {$ENDIF}

      Case SubMode of
        1  :  Begin

                SendText(ConCat(#9,StockCode));


                {$IFDEF MC_On}

                  ClearTabs;
                  SetTab (MarginLeft, pjLeft, 60, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);
                  SetTab (NA, pjCenter,20, 4, 0, 0);

                  For n:=1 to MaxStkPBands do
                    With SaleBands[n] do
                    Begin
                      If (FCr=0) then
                        TmpCr:=Currency
                      else
                        TmpCr:=FCr;

                      GenStr:=PSymb(TmpCr);

                      SendText(Concat(ConstStr(#9,n+1),GenStr));
                    end;

                  RepSetTabs;

                 {$ELSE}


                 {$ENDIF}

                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;

                SetReportDrillDown(0);

                SendText(ConCat(#9,Desc[1]));


                For n:=1 to MaxStkPBands do
                  With SaleBands[n] do
                  Begin

                    If (FCr=0) then
                      CurrEquiv:=SalesPrice
                    else
                      CurrEquiv:=Currency_ConvFT(SalesPrice,Currency,FCr,UseCoDayRate);


                    SendText(Concat(ConstStr(#9,n+1),FormatFloat(GenUnitMask[BOn],CurrEquiv)));
                  end;

                SendLine(Concat(ConstStr(#9,10),LStock.UnitS));

                For n:=2 to MaxStkDescs do
                  If (Desc[n]<>'') then
                  Begin
                    SetReportDrillDown(0);

                    SendLine(Concat(#9,Desc[n]));
                  end;

                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;

              end;

        2,3
           :  Begin

                Case SubMode of

                  2  :  Begin
                          Band:=(Ord(BandCh)-64);

                          With SaleBands[Band] do
                          Begin

                            If (FCr=0) then
                              CurrEquiv:=SalesPrice
                            else
                              CurrEquiv:=Currency_ConvFT(SalesPrice,Currency,FCr,UseCoDayRate);


                            {$IFDEF MC_On}

                              GenStr:=PSymb(Currency);

                            {$ENDIF}

                          end; {With..}
                        end;

                  3  :  Begin
                          If (LCust.CustCode<>CustFilt) then
                            LGetMainRec(CustF,CustFilt);

                          DiscCh:=#0;

                          Disc:=LCust.Discount;

                          If (LCust.CDiscCh In StkBandSet) or (Disc<>0) then
                            DiscCh:=LCust.CDiscCh;

                          {$IFDEF PF_On}

                            TBo:=BOn;

                            Calc_StockPrice(LStock,LCust,Fcr,1,Today,CurrEquiv,Disc,DiscCh,'',TBo);

                          {$ELSE}

                            CurrEquiv:=Get_StkPrice(LStock.SaleBands,Disc,DiscCh,FCr,1,1,CalcPack)

                          {$ENDIF}

                          {$IFDEF MC_On}

                            GenStr:=PSymb(FCr);

                          {$ENDIF}
                        end;
                end; {Case..}


                SendLine(ConCat(#9,StockCode,
                        #9,Desc[1],
                        #9,GenStr,FormatFloat(GenUnitMask[BOn],CurrEquiv),
                        #9,LStock.UnitS));




                For n:=2 to MaxStkDescs do
                  If (Desc[n]<>'') then
                  Begin
                    SetReportDrillDown(0);

                    SendLine(Concat(#9,#9,Desc[n]));

                  end;

                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;

              end;

      end; {Case..}

    end; {With..}

end; {Proc..}




{ ============= Print one line of nominal detail ============== }


Procedure TStkReport.PrintStkDet(Bot        :  Boolean);



Var
  SpcC   :  Byte;

  GenStr,
  GenStr2:  Str255;



Begin
  With MTExLocal^,LStock do
  With CRepParam^,RepFiler1 do
  Begin

    If (ReportMode <8) or (StockType=StkGrpCode) then
      SetReportDrillDown(1);

    ClearTabs;

    SetTab (MarginLeft, pjLeft, 30, 4, 0, 0);
    SetTab (NA, pjLeft,60, 4, 0, 0);

    SetTabCount;

    SpcC:=(Succ(Level)*HedSpace);



    Case StockType of
      StkGrpCode
               :  Begin


                    If (Not Bot) then
                    Begin

                      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                      Self.CRLF;

                      GenStr:=Spc(SpcC)+Desc[1];                                              { ** Nte UsrDef Var SpcC ** }

                      DefFont(1,[]);

                      SetReportDrillDown(1);

                      SendLine(ConCat(#9,StockCode,#9,GenStr));

                      DefLine(-1,MarginLeft,90,0);

                      DefFont(0,[]);

                      RepSetTabs;

                    end
                    else
                    Begin

                      If (Not NoBotD) then
                        GenStr:='('+Strip('B',[#32],Desc[1])+')'
                      else
                        GenStr:='';


                      GenStr:=Spc(SpcC)+GenStr+ConstStr('.',(StkDesKLen-Length(GenStr)))+':';


                      DefFont(0,[fsbold]);

                      DefLine(-1,MarginLeft,PageWidth-MarginRight-1,-0.5);

                      DefFont(0,[fsbold]);

                      SendLine(ConCat(#9,'Total :',#9,GenStr));

                      DefFont(0,[]);

                      RepSetTabs;

                      PrintAllStkTots;

                      If (Level<=0) then
                        DefLine(-2,MarginLeft,PageWidth-MarginRight-1,-0.5);

                    end;
                  end;
      else
                  Begin


                    Case ReportMode of
                      1..4  :  Begin
                                 GenStr:=Spc(SpcC)+Desc[1];

                                 If (StockCode<>'') then
                                   GenStr2:=StockCode
                                 else
                                   GenStr2:='';

                                 DefFont(0,[fsbold]);

                                 SendLine(ConCat(#9,GenStr2,#9,GenStr));

                                 DefFont(0,[]);

                                 RepSetTabs;


                                 PrintAllStkTots;

                                 // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                                 Self.CRLF;
                               end;

                      8..10 :  Begin
                                 RepSetTabs;
                                 PrintStkPList;
                               end;  


                    end; {Case..}

                  end;

    end; {case..}

  end; {With..}
end; {Proc..}




 { =============== Procedure to Return a given periods Totals, + the YTD =============== }

Procedure TStkReport.GetPR_YTD_Hist(PrMode,Base     :  Byte);



Const
  NFnum =  NHistF;
  NPath =  NHK;



Var
  NHKey        :  Str255;

  n,CYTD       :  Byte;


Begin


  With CRepParam^, MTExLocal^,LStock do
  Begin

    Case PrMode of

      2  :  CYTD:=AdjYr(RYr,BOff);

      else  CYTD:=RYr;

    end;


    For n:=PrS to PrE do
    With LNHist do
    Begin

      NHKey:=FullNHistKey(StockType,CalcKeyHist(StockFolio,LocFilt),FCr,CYTD,n);

      LStatus:=LFind_Rec(B_GetEq,NFnum,NPath,NHKey);

      If (LStatusOk) then
      Begin

        Case PrMode of

          2      :  ;

          else      Begin

                      NTotals[(n-Pred(PrS))]:=CaseQty(LStock,Cleared);

                      If (RevisedBudget1<>0.0) then
                        BTotals[(n-Pred(PrS))]:=CaseQty(LStock,RevisedBudget1)
                      else
                        BTotals[(n-Pred(PrS))]:=CaseQty(LStock,Budget);

                      NTotals[QtyTOfSet]:=NTotals[QtyTOfSet]+CaseQty(LStock,Cleared);

                      If (RevisedBudget1<>0.0) then
                        BTotals[QtyTOfSet]:=BTotals[QtyTOfSet]+CaseQty(LStock,RevisedBudget1)
                      else
                        BTotals[QtyTOfSet]:=BTotals[QtyTOfSet]+CaseQty(LStock,Budget);

                      NTotals[TOOfSet]:=NTotals[TOOfSet]+Sales;
                      NTotals[COOfSet]:=NTotals[COOfSet]+Purchases;

                    end;


        end; {Case..}

      end; {If FoundOk..}

    end; {Loop..}

  end; {With..}

end; {Proc..}




{ =================== Procedure to Control Corrolation of Yr to Date ============== }

Procedure TStkReport.Control_YTDHist;

Var
  Fini  :  Boolean;
  Base  :  Byte;


Begin
  Base:=1; Fini:=BOn;


  With MTExLocal^,LStock do
  With CRepParam^ do
  Begin

    Blank(NTotals,Sizeof(NTotals));
    Blank(BTotals,Sizeof(BTotals));

    Repeat

      GetPr_YTD_Hist(1,Base);

      Fini:=Not Fini;

    Until (Fini) or (ReportMode<>4);


    If (StockType<>StkGrpCode) or (Level=RepLimit) then
      GrandStkTotals(BSTotals,NTotals,TOOfset,COOfset,BOff);

  end; {With..}
end; {Proc..}



{ =================== Function to Check if Ok to Print ================ }

Function TStkReport.IsOktoNom(NCode      :  Str20)  :  Boolean;



Var
  TBo,
  TmpInclude
       :  Boolean;

  n    :  Byte;

  LNRR :  StkRepRec;


Begin

  TmpInclude:=BOff;

  LNRR:=CRepParam^;

  With MTExLocal^,CRepParam^ do
  Begin

    Case ReportMode of
      1..4  :  Begin
                 Control_YTDHist;

                 n:=1;

                 TBo:=BOff;


                 While (n<=MaxNoStkTots) and (Not TBo) and (Not IncludeAll) do
                 Begin

                   TBo:=(NTotals[n]<>0) or (BTotals[n]<>0);

                   Inc(n);

                 end;

                 TmpInclude:=(((TBo) or (IncludeAll)) and ((LStock.StockType<>StkDescCode) or (Syss.AnalStkDesc)));

               end;

      8..10
             : With LStock do
               Begin
                 TmpInclude:=((((StockType<>StkDescCode)  or (Syss.AnalStkDesc)) and (StockType<>StkDListCode))
                            and ((CheckKey(PaLS,StockCat,Length(PaLS),BOff))
                            or  (Level>0)
                            or  (CheckKey(PaLS,StockCode,Length(PaLS),BOff))));

                 If (TmpInclude) then
                   Case ReportMode of

                     8  :  TmpInclude:=(CheckKey(Parnt,StockCat,Length(Parnt),BOff));

                     9,10
                        :  TmpInclude:=(StockType<>StkGrpCode);

                   end; {Case..}

               end;

    end; {Case..}

  end; {With..}

  IsOktoNom:=TmpInclude;

  CRepParam^:=LNRR;
end;



 { ================== Procedure to control the printing of one line nominal ============= }

 Procedure TStkReport.StkDetail(Bot        :  Boolean);


 Begin
   With MTExLocal^ do
   If (Not Bot) or ((Bot) and (LStock.StockType=StkGrpCode)) then
   With RepFiler1,CRepParam^,LStock do
   Begin

     Case ReportMode of
       1..4
          :  Begin

               If (StockType<>StkGrpCode) or (Bot) then
                 Control_YTDHist;


             end;


     end; {case..}


     If (LinesLeft<=5) then
       ThrowNewPage(5);


     If (Ok2Print) then
       PrintStkDet(Bot);



   end; {with..}
 end;



{ ============== Procedure to check if Range encountered ================== }

Procedure TStkReport.Check4Range(NCode      :  Str20);

Begin
  With CRepParam^ do
    If (CheckKey(PaLS,NCode,Length(PALS),BOn)) or (CheckKey(PaLE,NCode,Length(PALE),BOn)) then
      Ok2Print:=Not Ok2Print;

end; {PRoc..}


{ ============== Recursive routine to follow nominal structure & Print it ================= }


Procedure TStkReport.FollowChain(LevelKey  :  Str20);


Var
  TmpKPath,
  TmpStat
       :  Integer;

  TmpRecAddr
       :  LongInt;

  LStk :  StockRec;
  LKey :  Str255;


Begin
  With MTExLocal^,CRepParam^ do
  Begin
    Inc(Level);

    LKey:=LevelKey;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPth,LKey);


    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (Not RepAbort) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn)) and (Level<=RepLimit) do
    With LStock do
    Begin

      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);

      TmpKPath:=KeyPth;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      Case ReportMode of

        1..4  :  Check4Range(StockCode);

      end; {Case..}


      {$B-}


      If (IsOktoNom(StockCode)) then
      Begin

      {$B+}

        Inc(ICount);

        LStk:=LStock;


        StkDetail(BOff);  { =========== Print Detail =========== }



        If (StockType=StkGrpCode) then
        Begin
          Parnt:=LStk.StockCode;  {* Set Last Parent *}


          FollowChain(StockCode);

          Parnt:=LStk.StockCat;  {* Set Last Parent *}
        end;

        LStock:=LStk;

        Case ReportMode of

          1..4  :  StkDetail(BOn);   { ============ Print Bottom =========== }

        end; {Case..}

      end; {Profit..}

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPth,LKey);

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;

    end; {While..}

    Dec(Level);

  end; {with..}
end; {Proc..}






Procedure TStkReport.RepPrint(Sender  :  TObject);

Var
  LevelKey  :  Str10;

Begin
  ShowStatus(2,'Processing Report.');


  With CRepParam^ do
  Begin
    LevelKey:=LevKey;

    Case ReportMode of
      1..10
           :  Begin

                FollowChain(LevelKey);


                If ((BSTotals[QtyTOfSet]+BSTotals[TOOfset]+BSTotals[COOfset]<>0) and (ReportMode In [1..4])) then
                Begin

                  { === Print Grand Stock Totals ==== }

                  PrintStkTotals(BSTotals,FCr,FTxCr,4);


                end;


              end;
    end; {Case..}

  end; {With..}

  PrintEndPage;
end;


Function TStkReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin

    NoAnals    :=  12;
    QtyTOfSet  :=  NoAnals+1;
    TOOfset    :=  NoAnals+2;
    COOfset    :=  NoAnals+3;

    RFnum:=StockF;
    RKeypath:=0;

    Level:=-1;

    Mode:=ReportMode;


    Fnum:=RFnum; KeyPth:=StkCatK;

    Ok2Print:=BOn;


    If (RepLimit=0) then
      RepLimit:=YTD;

    Case ReportMode of
      1      :  Begin
                  ThTitle:='Sales Analysis';

                 {AbortPrint:=Inp_SalesAnal(PaLS,PaLE,RepLimit,PrS,PrE,RYr,RYr,FCr,FTxCr,TmpCCDep,
                             CFilt,ShowBudg,CCTag,1,RepTit);}

                  RepTitle:=ThTitle;

                  If (ShowBudg) then
                   RepTitle:=RepTitle+' and Forecast';

                  {$IFDEF SOP}
                      RepTitle2:=MLocRepTitle(LocFilt)+'. ';
                  {$ENDIF}
                end;

      4     :  Begin

                 ThTitle:='Comparative Sales Analysis';

               end;

      8     :  Begin

                 ThTitle:='Price List';


                 If (Not EmptyKey(CustFilt,CustKeyLen)) then
                 Begin
                   GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);

                   RepTitle2:='For '+Strip('B',[#32],Cust.Company)+'. ';
                 end;

                 {$IFDEF SOP}
                   If (Not EmptyKey(LocFilt,LocKeyLen)) then
                   Begin
                     If (RepTitle2<>'') then
                       RepTitle2:=RepTitle2+', ';

                     RepTitle2:=RepTitle2+MLocRepTitle(LocFilt);
                   end;
                 {$ENDIF}
               end;




    end; {Case..}


    If (ReportMode<>1) then
      RepTitle:=ThTitle;

    PageTitle:=RepTitle;


      {$IFDEF MC_On}

        If (FTxCr<>0) and (FTxCr<>FCr) then
          PageTitle:=CurrDesc(FCr)+'to '+CurrDesc(FTxCr)+PageTitle
        else
          Pagetitle:=CurrDesc(FCr)+PageTitle;

      {$ENDIF}


      Case ReportMode of
        1..3
           :  Begin

                Ok2Print:=(EmptyKey(PaLS,StkKeyLen));


                RepTitle2:=RepTitle2+'For Period '+PPR_OutPr(PrS,RYr)+'-'+PPR_OutPr(PrE,RYr);

                LevKey:=FullStockCode('');


              end;

        8  :  Begin

                Case RepOrd of
                  'D'  :  Begin
                            Keypth:=StkDescK;

                            ReportMode:=9;

                            LevKey:='';

                          end;

                  'C'  :  Begin

                            Keypth:=StkCodeK;

                            ReportMode:=10;

                            LevKey:='';

                          end;

                  'T'  :  Begin
                            If (Not EmptyKey(PaLS,StkKeyLen)) then
                            Begin
                              GetStock(Application.MainForm,PalS,FoundCode,-1);

                              LevKey:=Stock.StockCat;

                            end;

                          end;

                end; {Case..}

                Mode:=ReportMode;

                If (Not EmptyKey(CustFilt,CustKeyLen)) then
                  SubMode:=3
                else
                  SubMode:=1+Ord((Bandch<>C0));

              end;


      end; {case..}




    If (Not (ReportMode In [8..10])) or (SubMode=1) then
      ROrient:=RPDefine.PoLandscape;


  end; {With..}

  Result:=BOn;
end;





Procedure TStkReport.Finish;


Begin
  Inherited Finish;
end;


{ ======== }



Procedure AddStkRep2Thread(LMode    :  Byte;
                           IRepParam:  StkRepRecPtr;
                           AOwner   :  TObject);


Var
  EntTest  :  ^TStkReport;

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

        If (Assigned(BackThread)) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
          Dispose(EntTest,Destroy);
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;





Initialization

  QtyTOfSet:=0;
  TOOfset:=0;
  COOfset:=0;

Finalization

end.