unit RepBSupU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, Scrtch2U;


type



  TISVATReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private
                       ThisScrt   :  Scratch2Ptr;


                       Procedure CVATHed;

                       Procedure CalcIntraTotals(StkVal    :  AgedTyp;
                                                 IncCnt    :  Boolean);


                       Procedure PrintIntraTot;

                       Function IntraInvInclude(InvR  :  InvRec;
                                                Sdate,
                                                Edate :  LongDate)  :  Boolean;

                       Function Scan_4Items(CMode  :  Byte;
                                            Sdate,
                                            Edate  :  LongDate;
                                            VATChk :  Char;
                                            Summary:  Boolean)  :  LongInt;


                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                     public

                       CRepParam  :  ISVATRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddISVATRep3Thread(LMode    :  Byte;
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

  {$IFDEF EXSQL}
   SQLUtils,
  {$ENDIF}

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

  If (CurrentCountry=IECCode) then
    ROrient:=RPDefine.poLandscape;

end;


Destructor TISVATReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TISVATReport.Process;

Begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}

  New(ThisScrt,Init(14,MTExLocal,BOff));
  InitStatusMemo(4);

  Try
    RFnum:=ReportF;
    RKeyPath:=RpK;
    RepKey:=FullNomKey(ThisScrt^.Process);

    With CRepParam^ do
    Begin
      LastCommod:=NdxWeight;

      TotItem:=Scan_4Items(ReportMode,SDate,Edate,VATChk,Summary);

    end;

    Inherited Process;

  finally

    Dispose(ThisScrt,Done);
    ThisScrt:=nil;
  end; {try..}
end;



Procedure TISVATReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,2:
           Begin
              If (CurrentCountry<>IECCode) then
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
                SetTab (NA, pjLeft, 25, 4, 0, 0);
                SetTab (NA, pjLeft, 15, 4, 0, 0);
              end
              else
              Begin
                SetTab (MarginLeft, pjRight, 11, 4, 0, 0);
                SetTab (NA, pjLeft, 20, 4, 0, 0);
                SetTab (NA, pjLeft, 20, 4, 0, 0);
                SetTab (NA, pjLeft, 20, 4, 0, 0);
                SetTab (NA, pjRight, 20, 4, 0, 0);
                SetTab (NA, pjRight, 20, 4, 0, 0);
                SetTab (NA, pjRight, 20, 4, 0, 0);
                SetTab (NA, pjLeft, 18, 4, 0, 0);
                SetTab (NA, pjRight, 20, 4, 0, 0);
                SetTab (NA, pjRight, 20, 4, 0, 0);
                SetTab (NA, pjRight, 25, 4, 0, 0);
                SetTab (NA, pjLeft, 10, 4, 0, 0);
              end;
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
                    #9,'Period:',' ',SetN(VPr),'/',Form_Int(TxLateYrVal(VYr,BOff),0),
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
              If (CurrentCountry<>IECCode) then
              Begin
                SendLine(ConCat(#9,#9,'1.',' ','Commod.',#9,'2.',' ','Value',#9,'3.',' ','Deliv.',
                        #9,'4.',' ','Nature',#9,'5.',' ','Net',#9,'6.',' ','Supplem-',#9,'7.',' ','Ctry',
                        #9,'8.',' ','Mode',' ','of',#9,'9.',' ','Ctry',' ','of',#9,'10.',' ','No. of',
                        #9,'11.Traders'));

                SendLine(ConCat(#9,#9,'code',#9,'Sterling',#9,'terms',#9,'of',' ','trans.',
                                #9,'Mass(kg)',#9,'entary',' ','units',#9,'of',' ','dest.',#9,'transport',
                                #9,'origin',#9,'consignmts',#9,'reference'));

              end
              else
              Begin
                SendLine(ConCat(#9,'8.ITEM',#9,'9.',' ','COMMOD.',#9,'10.',' ','CTRY',#9,'11.',' ','CTRY',' ',
                        'OF',#9,'12.',' ','MODE',' ','OF',#9,'13.',' ','NATURE',#9,'14.',' ','INVOICE',#9,'15.',' ',
                        'DELIV.',#9,'16.',' ','STATS',#9,'17.',' ','NETT',#9,'18. SUPPLEM-'));

                SendLine(ConCat(#9,'NO.',#9,'CODE',#9,'OF',' ','DEST.',#9,'ORIGIN',#9,
                        'TRANSPORT',#9,'OF',' ','TRANS',#9,'VALUE',#9,'TERMS',#9,'VALUE',#9,
                        'MASS(KG)',#9,'ENTARY',' ','UNITS'));



              end;

            end;


      2  :  Begin
              If (CurrentCountry<>IECCode) then
              Begin
                SendLine(ConCat(#9,#9,'1.',' ','Commod.',#9,'2.',' ','Value',#9,'3.',' ','Deliv.',
                      #9,'4.',' ','Nature',#9,'5.',' ','Net',#9,'6.',' ','Supplem-',#9,'7.',' ','Ctry',
                      #9,'8.',' ','Mode',' ','of',#9,'9.',' ','Ctry',' ','of',#9,'10.',' ','No. of',
                      #9,'11.Traders'));

                SendLine(ConCat(#9,#9,'code',#9,'Sterling',#9,'terms',#9,'of',' ','trans.',
                      #9,'Mass(kg)',#9,'entary',' ','units',#9,'of',' ','consg',#9,'transport',
                      #9,'origin',#9,'consignmts',#9,'reference'));
              end
              else
              Begin
                SendLine(ConCat(#9,'8.ITEM',#9,'9.',' ','COMMOD.',#9,'10.',' ','CTRY',#9,'11.',' ','CTRY',' ',
                        'OF',#9,'12.',' ','MODE',' ','OF',#9,'13.',' ','NATURE',#9,'14.',' ','INVOICE',#9,'15.',' ',
                        'DELIV.',#9,'16.',' ','STATS',#9,'17.',' ','NETT',#9,'18. SUPPLEM-'));

                SendLine(ConCat(#9,'NO.',#9,'CODE',#9,'OF',' ','CONSG',#9,'ORIGIN',#9,
                        'TRANSPORT',#9,'OF',' ','TRANS',#9,'VALUE',#9,'TERMS',#9,'VALUE',#9,
                        'MASS(KG)',#9,'ENTARY',' ','UNITS'));

              end;


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

Procedure TISVATReport.CalcIntraTotals(StkVal    :  AgedTyp;
                                       IncCnt    :  Boolean);




Begin

  With CRepParam^ do
  Case ReportMode of

    1,2    :  Begin

                If (IncCnt) then
                  Inc(ItemRun)
                else
                  Inc(AggCommod.ConsCount);

                GrandAgedTotal(RepTot,StkVal);
                GrandAgedTotal(AggTot,StkVal);


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
  If (Not Summary) then
  Begin
    Case ReportMode of
      1,2  :  Begin
                SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);

                If (CurrentCountry<>IECCode) then
                Begin
                  SendRepDrillDown(2,2,2,LStock.StockCode,StockF,StkCodeK,0);
                  SendRepDrillDown(8,8,2,LStock.StockCode,StockF,StkCodeK,0);
                  SendRepDrillDown(7,7,2,LStock.StockCode,StockF,StkCodeK,0);
                  SendRepDrillDown(10,10,2,LStock.StockCode,StockF,StkCodeK,0);
                end
                else
                Begin
                  SendRepDrillDown(2,4,2,LStock.StockCode,StockF,StkCodeK,0);
                end;
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

  LineTot,
  TmpTot     :  AgedTyp;

  GenStr     :  Str80;

  TriInd,
  Cntry      :  Str10;

  TBo,
  Ok2Print   :  Boolean;

  UWeight,
  StatUplift :  Double;

  LineAgg,
  TmpLineAgg
             :  TAggSSD;





Begin


  Rnum:=0;

  Rnum2:=0;

  Lnum:=0;

  Cntry:='';  TriInd:='';

  RepCnst:=1;

  TmpDecs:=0;

  TmpDecs2:=0;

  UWeight:=0.0;

  Blank(LineTot,Sizeof(LineTot));
  Blank(LineAgg,Sizeof(LineAgg));

  Blank(TmpTot,Sizeof(TmpTot));

  Blank(LineAgg,Sizeof(LineAgg));
  Blank(TmpLineAgg,Sizeof(TmpLineAgg));
  StatUpLift:=0.0;


  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin
    Ok2Print:=Not Summary;

    SetReportDrillDown(0);

    Case ReportMode of
      1,2
         :  Begin
              With LCust do
              With LInv do
              With LStock do
              With LId do
              Begin


                If (ReportMode=1) then
                  RepCnst:=-1;

                Rnum:=DetLTotal(LId,BOn,BOff,0.0)*LineCnst(Payment);  {* -ves not allowed, must use +ve only! *}
                                                          {* v2.30 Inv.OrigRates used so it is expressed in orig Co Rate *}
                                                          {v5.52. On UK Intrastat round up to nearest 1}
                LineTot[1]:=ForceNearestWhole(Conv_VATCurr(Rnum,VATCRate[UseCoDayRate],
                                     XRate(LInv.OrigRates,BOff,Currency),Currency,UseORate),2);

               UWeight:=LWeight;

                If (SSDUseLine) then
                  StatUplift:=LId.SSDUplift
                else
                Begin
                  Case ReportMode of
                    1  :  Begin
                            StatUpLift:=LStock.SSDDUpLift;
                          end;
                    2  :  Begin
                            StatUpLift:=LStock.SSDAUpLift;
                          end;
                  end; {Case..}

                end;


                Case ReportMode of
                  1  :  Begin
                          If (UWeight=0.0) then {* EL: Subs stock record weight if line weight zero Exv6.01*}
                            UWeight:=SWeight;

                          {LineTot[2]:=Round_Up(Qty*Stock.SWeight,0);}

                          {v5.52. On UK Intrastat round up to nearest 1}
                          LineTot[2]:=ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*UWeight,2);

                          { CJS 2012-06-13: ABSEXCH-13052 - Stats value should always be calculated }
//                        If (StatUpLift<>0.0) then
                            LineTot[4]:=LineTot[1]-(LineTot[1]*Pcnt(StatUpLift));
                        end;

                  2  :  Begin
                          If (UWeight=0.0) then {* EL: Subs stock record weight if line weight zero Exv6.01*}
                            UWeight:=PWeight;

                          {LineTot[2]:=Round_Up(Qty*Stock.PWeight,0);}

                          {* Use weight at the time of the transaction *}

                          {v5.52. On UK Intrastat round up to nearest 1}

                          LineTot[2]:=ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*UWeight,2);


                          { CJS 2012-06-13: ABSEXCH-13052 - Stats value should always be calculated }
//                        If (StatUpLift<>0.0) then
                            LineTot[4]:=LineTot[1]+(LineTot[1]*Pcnt(StatUpLift));
                        end;

                end; {Case..}

                If (UnitSupp<>'') then
                  LineTot[3]:=DivWChk((Qty*QtyMul),LStock.SuppSUnit)
                else
                  LineTot[3]:=0;

                Lnum:=1;

                Cntry:=Copy(VATRegNo,1,2);

                GenStr:=LInv.OurRef;

                If (SSDProcess<>#0) then
                  TriInd:=SSDProcess;

                With LineAgg do
                Begin
                  If (SSDUseLine) then
                  Begin
                    // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                    CommodCode:=Copy(LId.SSDCommod, 1, 8);
                    COrig:=LId.SSDCountry;

                  end
                  else
                  Begin
                    // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                    CommodCode:=Copy(LStock.CommodCode, 1, 8);

                    COrig:=LStock.SSDCountry;
                  end;

                  CC:=Cntry;
                  DelivTerms:=LInv.DelTerms;
                  TransNat:=LInv.TransNat;
                  TransMode:=LInv.TransMode;
                  ConsCount:=Lnum;
                  UnitSupp:=LStock.UnitSupp;
                end;

                If (Summary) then
                Begin

                  If (LastCommod<>ThisCommod) then
                  Begin
                    Ok2Print:=(LastCommod<>NdxWeight);
                    LastCommod:=ThisCommod;

                    TmpLineAgg:=LineAgg;
                    LineAgg:=AggCommod;
                    AggCommod:=TmpLineAgg;
                    TmpTot:=LineTot;
                    LineTot:=AggTot;

                    Blank(AggTot,Sizeof(AggTot));

                    AggCommod.ConsCount:=Ord(Ok2Print);

                    CalcIntraTotals(TmpTot,Ok2Print);

                    If (CurrentCountry=IECCode) then
                      GenStr:=FormatBFloat(GenRNDMask,LineTot[3],BOn)+' '+
                              LineAgg.UnitSupp
                    else
                      GenStr:=#32;

                  end
                  else
                    CalcIntraTotals(LineTot,BOff);


                end
                else
                  CalcIntraTotals(LineTot,BOn);



              end;

              With LineAgg do
              If (Ok2Print) then
              Begin

                If (CurrentCountry<>IECCode) then
                Begin

                  SendLine(ConCat(#9,Form_Int(ItemRun,0),
                          #9,CommodCode,
                          #9,FormatFloat(GenRNDMask,LineTot[1]),
                          #9,DelivTerms,
                          #9,Form_Int(TransNat,0),
                          #9,FormatFloat(GenRNDMask,LineTot[2]),
                          #9,FormatBFloat(GenRNDMask,LineTot[3],BOn),' ',
                             UnitSupp,
                          #9,CC,
                          #9,Form_Int(TransMode,0),
                          #9,COrig,
                          #9,Form_Int(ConsCount,0),
                          #9,GenStr,
                          #9,TriInd));
                end
                else
                Begin
                  SendLine(ConCat(#9,Form_Int(ItemRun,0),
                           #9,CommodCode,
                           #9,CC,
                           #9,COrig,
                           #9,Form_Int(TransMode,0),
                           #9,Form_Int(TransNat,0),
                           #9,FormatFloat(GenRNDMask,LineTot[1]),
                           #9,DelivTerms,
                           #9,FormatFloat(GenRNDMask,LineTot[4]),
                           #9,FormatFloat(GenRNDMask,LineTot[2]),
                           #9,GenStr,
                           #9,TriInd));
                end;



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
    If (Summary) then
    Begin
      ThisCommod:=NdxWeight; {* Force release of last summary *}

      PrintReportLine;
    end;


    PrintIntraTot;
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
      and ((RunNo>=0) or (RunNo=BatchRunNo)) {Debug mode only }
      and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet));

  {$IFDEF USEONEDAY}
    Result:= ((PostDate>=SDate) and (PostDate<=EDate)) and (RunNo>0)
              and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet))
      and ((Not (InvDocHed In CreditSet)) or (CurrentCountry<>IECCode));

    {$ENDIF}

  end; {With..}
end; {Func..}





{ ======================= VAT Include ======================= }


Function TISVATReport.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;
  KeyCS      :  Str255;


Begin

  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      1,2
           :  With LId do
              Begin
                ThisScrt^.Get_Scratch(LRepScr^);

		TmpInclude:=BOn;

                ThisCommod:=LRepScr^.KeyStr;

                {* Link to all other records which should be around *}

                If (LStock.StockCode<>StockCode) then
                  LGetMainRec(StockF,LId.StockCode);

                KeyCS:=FullNomKey(FolioRef);

                LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,KeyCS);

                If (LInv.CustCode<>LCust.CustCode) then
                  LGetMainRec(CustF,LInv.CustCode);

              end;
         else  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390
           raise Exception.Create('Invalid ReportMode in TISVATReport.IncludeRecord: ' + IntToStr(ReportMode));

    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}





{ ==== Function to Scan all given customer/suppliers and check the No. of Items between any given dates ==== }


Function TISVATReport.Scan_4Items(CMode  :  Byte;
                                  Sdate,
                                  Edate  :  LongDate;
                                  VATChk :  Char;
                                  Summary:  Boolean)  :  LongInt;

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
  KeyCF,
  CommodKey   :  Str255;


  Lnum,
  RecAddr     :  LongInt;


  TmpInclude  :  Boolean;



Begin

  Lnum:=0; RecAddr:=0;


  With MTExLocal^ do
  Begin

    KeyCF:=TradeCode[(Cmode=1)];

    TmpInclude:=BOff;

    CommodKey:='';

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
              // MH 10/09/2009: Modified to exclude service lines (FRv6.2.003)
              If ((VATCode=VATChk) and (LineNo>0) And (Not ECService)) then
              Begin

                If (Assigned(ThisScrt)) then
                Begin
                  LStatus:=LGetPos(Fnum2,RecAddr);  {* Get Preserve IdPosn *}

                  With ThisScrt^ do
                  Begin
                    If (LStock.StockCode<>StockCode) then
                      LGetMainRec(StockF,LId.StockCode);


                    If (SSDUseLine) then
                    Begin
                      // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                      CommodKey := Copy(LId.SSDCommod, 1, 8) +
                                   Copy(VATRegNo,1,2) +
                                   LId.SSDCountry +
                                   Form_Int(TransNat,2) +
                                   Form_Int(TransMode,1) +
                                   DelTerms;
                    end
                    else
                    Begin
                      // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                      CommodKey := Copy(LStock.CommodCode, 1, 8) +
                                   Copy(VATRegNo,1,2) +
                                   LStock.SSDCountry +
                                   Form_Int(TransNat,2) +
                                   Form_Int(TransMode,1) +
                                   DelTerms;
                    end;

                    {$B-}

                    {* Only count unique keys *}
                    If (Not Summary) or (Not Find_ScratchK(CommodKey)) then
                      Inc(Lnum);

                    {$B+}
                    Add_Scratch(Fnum2,Keypath2,RecAddr,CommodKey,CommodKey);
                  end;
                end;
              end;


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

    If (Debug) then
    Begin

    end;

    {RepCtrl^.AbortPrint:=Inp_ECSalesReport(VATStartD,VATEndD,HedTit);}

    PageTitle:=Reptitle+' - Supplementary Declaration';

    NYear:=ConvTxYrVal(VYr,BOff);

    Sdate:=StrDate(NYear,VPr,01);

    Edate:=StrDate(NYear,VPr,MonthDays[VPr]);

    Case ReportMode of
      1  :  VATChk:=VATECDCode;
      2  :  VATChk:=VATEECCode;
    end;

    {RFnum:=CustF;  These settings replaced by process rountine.}

    RFont.Size:=7;

    {RKeyPath:=CustCntyK;

    RepKey:=Tradecode[(ReportMode=1)];}

  end; {With..}

  Result:=BOn;
end;





Procedure TISVATReport.Finish;


Begin

  Inherited Finish;

end;


{ ======== }




Procedure AddISVATRep3Thread(LMode    :  Byte;
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