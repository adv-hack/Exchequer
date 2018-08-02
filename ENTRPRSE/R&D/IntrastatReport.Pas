unit IntrastatReport;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses Dialogs, Windows, DB, Graphics, SysUtils, Contnrs, StrUtils, RpDevice,
     GlobVar, VarConst, BTSupU3, SQLCallerU, SQLRep_BaseReport, ReportU, BtrvU2,
     Scrtch2U, IntrastatDataSearch;

type
  // Main report class
  TIntrastatReport = object(TGenReport)
     procedure RepSetTabs; virtual;
     procedure RepPrintPageHeader; virtual;
     Procedure RepPrintHeader(Sender  :  TObject); Virtual;
  private
     ThisScrt  : Scratch2Ptr;

     // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
     fDataSearch: TIntrastatDataSearch;

     Procedure CVATHed;
     Procedure CalcIntraTotals(StkVal    :  AgedTyp;
                               IncCnt    :  Boolean);
     Procedure PrintIntraTot;
     Function GetReportInput  :  Boolean; Virtual;
     Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;
  public
     MaxProgress         : LongInt;
     ReportParameters    : PostRepParam;

     // Cached SQL Emulator info to reduce overhead
     CompanyCode         : AnsiString;
     ConnectionString    : WideString;   //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

     CRepParam           :  ISVATRepPtr;

     Constructor Create(AOwner  :  TObject);
     Destructor  Destroy; Virtual;

     Procedure PrintReportLine; Virtual;
     Procedure PrintEndPage; Virtual;
     function IncludeRecord  : Boolean; Virtual;

     function ActivateCRepParam : Boolean;

     Procedure Process; Virtual;
     Procedure Finish;  Virtual;
  End;

// This is the main procedure which is called to get the appropriate data
Procedure AddISVATRep3Thread(LMode     :  Byte;
                             IRepParam :  ISVATRepPtr;
                             AOwner    :  TObject);

implementation

uses
    SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
    SysU1, ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, ComnUnit,
    SQLRep_Config, EntLoggerClass;


// =============================================================================

// This is the process called from RepInpEU

Procedure AddISVATRep3Thread(LMode     :  Byte;
                             IRepParam :  ISVATRepPtr;
                             AOwner    :  TObject);
Var
  EntTest       : ^TIntrastatReport;
  oReportLogger : TEntSQLReportLogger;
Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

       // ABSEXCH-13459 An Error I/O 103 was coming up because the following if then clause was missing
       // 25/09/2012
       {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
             GetConnectionString(CompanyCode, False, ConnectionString);
       {$ENDIF}

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

function TIntrastatReport.ActivateCRepParam : Boolean;
Begin
 result := ChkRepAbort;
End;

Procedure TIntrastatReport.Process;
Begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}

  New(ThisScrt,Init(14,MTExLocal,BOff));
  InitStatusMemo(4);

  Try
    RFnum       := ReportF;
    RKeyPath    := RpK;
    RepKey      := FullNomKey(ThisScrt^.Process);

    With CRepParam^ do
    Begin
      LastCommod := NdxWeight;
      // This function is called from IntraDataSearch which is generic searching code
      // for the Intrastat reports
      // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
      TotItem := fDataSearch.Scan_4Items(ReportMode, SDate, Edate, VATChk,
                                         Summary, ThisScrt, MTExLocal,
                                         ActivateCRepParam, RepAbort);
    end;

    Inherited Process;

  finally

    Dispose(ThisScrt,Done);
    ThisScrt:=nil;
  end; {try..}
end;

Procedure TIntrastatReport.Finish;
Begin
  Inherited Finish;
end;

Constructor TIntrastatReport.Create(AOwner  :  TObject);
Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  If (CurrentCountry=IECCode) then
    ROrient:=RPDefine.poLandscape;

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  fDatasearch := TIntrastatDataSearch.Create;
end;


Destructor TIntrastatReport.Destroy;
Begin
  Dispose(CRepParam);

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  if Assigned(fDataSearch) then
    FreeAndNil(fDataSearch);

  Inherited Destroy;
end;

function TIntrastatReport.GetReportInput: Boolean;
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

{ ======================= VAT Include ======================= }


Function TIntrastatReport.IncludeRecord :  Boolean;
Var
  TmpInclude :  Boolean;
  KeyCS      :  Str255;
Begin
  TmpInclude := False;
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
    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}


{ ======================= Due Header ======================= }

Procedure TIntrastatReport.CVATHed;
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

{ ======================= Calculate Due Totals ==================== }

Procedure TIntrastatReport.CalcIntraTotals(StkVal    :  AgedTyp;
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

Procedure TIntrastatReport.PrintIntraTot;
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

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              SendLine(ConCat(#9,#9,'.................................'));
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

Procedure TIntrastatReport.RepPrintHeader(Sender  :  TObject);
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

// -----------------------------------------------------------------------------

procedure TIntrastatReport.RepPrintPageHeader;
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


// -----------------------------------------------------------------------------

procedure TIntrastatReport.RepSetTabs;
begin
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

Procedure TIntrastatReport.SetReportDrillDown(DDMode  :  Byte);

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

Procedure TIntrastatReport.PrintReportLine;
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
  TmpLineAgg :  TAggSSD;
Begin
  Rnum     :=0;
  Rnum2    :=0;
  Lnum     :=0;
  Cntry    :='';  TriInd:='';
  RepCnst  :=1;
  TmpDecs  :=0;
  TmpDecs2 :=0;
  UWeight  :=0.0;

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

                // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
                // CJS 2014-05-13 - ABSEXCH-15337 - removed 'dispatches only' restriction
                if ReportMode in [1, 2] then
                  Rnum := Rnum + fDataSearch.CalculateDeliveryCharge(LId);

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

                          {v5.52. On UK Intrastat round up to nearest 1}
                          LineTot[2]:=ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*UWeight,2);

                            LineTot[4]:=LineTot[1]-(LineTot[1]*Pcnt(StatUpLift));
                        end;

                  2  :  Begin
                          If (UWeight=0.0) then {* EL: Subs stock record weight if line weight zero Exv6.01*}
                            UWeight:=PWeight;

                          LineTot[2]:=ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*UWeight,2);


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
                  DelivTerms    := LInv.DelTerms;
                  TransNat      := LInv.TransNat;
                  TransMode     := LInv.TransMode;
                  ConsCount     := Lnum;
                  UnitSupp      := LStock.UnitSupp;
                end;

                If (Summary) then
                Begin

                  If (LastCommod<>ThisCommod) then
                  Begin
                    Ok2Print:=(LastCommod<>NdxWeight);
                    LastCommod:=ThisCommod;

                    TmpLineAgg  := LineAgg;
                    LineAgg     := AggCommod;
                    AggCommod   := TmpLineAgg;
                    TmpTot      := LineTot;
                    LineTot     := AggTot;

                    Blank(AggTot,Sizeof(AggTot));

                    AggCommod.ConsCount:=Ord(Ok2Print);

                    CalcIntraTotals(TmpTot,Ok2Print);

                    If (CurrentCountry=IECCode) then
                      GenStr := FormatBFloat(GenRNDMask,LineTot[3],BOn)+' '+
                                LineAgg.UnitSupp
                    else
                      GenStr :=#32;

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

Procedure TIntrastatReport.PrintEndPage;
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


End.

