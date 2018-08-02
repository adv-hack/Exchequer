unit ReportRV;


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,VarRec2U,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,
  RpDevice,ReportU,
  SCRTCH2U;


type
   tRevalueRec  =  Class(TObject)
                    Public
                      OrigOS,
                      BaseOS,
                      OrigXRate,
                      NewXRate,
                      PrevRVA,
                      NewBase  :  Double;

                      RecCurr,
                      RecType  :  Byte;

                      MatchRef :  Str10;

                      NomRef   :  Str10;

                      PrintRec :  Boolean;

                      RepNomCode
                               :  LongInt;
                      destructor Destroy; override;
                  end;


    TRevalueLog  =  Class(TList)

                   Constructor Create;

                   Destructor Destroy; override;

                   private
                     fGot2Print  :  Boolean;

                   public
                      ScratchFileN
                                 :  Str255;
                      MTExLocal  :  tdPostExLocalPtr;
                      ThisScrt   :  Scratch2Ptr;

                      OldOrigOS,
                      OldBaseOS,
                      OldXRate,
                      ThisXRate,
                      RVAdjust,
                      ThisBase   :  Double;

                      RVFnum,
                      RVKeypath  :  Integer;

                      RVCurr,
                      RVMode     :  Byte;

                      SortStr    :  Str255;

                      PrintItem  :  Boolean;

                      PreSyssCurr:  CurrRec;
                      PreSyssGCR :  GCurRec;

                     Procedure InitScratchfile;

                     Function Set_MDCCC(InvR     :  InvRec;
                                        CtrlNom  :  LongInt)  :  LongInt;

                     Procedure AddRevalueRec(SCurr  :  Byte);

                     Procedure CalcRVStr(SCurr  :  Byte);

                     Procedure ResetLine;

                     Procedure SetPrintStatus(MStr  :  Str10;
                                              PStat :  Boolean;
                                              limit,
                                              MMode :  SmallInt);

                     Procedure SetNomRef(MStr  :  Str10;
                                         CurM,
                                         limit :  LongInt );

                     Property Got2Print  :  Boolean read fGot2Print write fGot2Print;

                 end; {Class}

  TRVReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private
                       WasRT5    :  Boolean;

                       LastRT,
                       LastCurr  :  Byte;

                       EqGLCode,
                       LastGLCode:  LongInt;

                       RepTot,AggTot,Currtot
                                   :  AgedTyp;


                       //PR: 07/10/2009 - Moved to protected section below to allow access by descendant
                      { RevalueRec  :  tRevalueRec;
                       RevalueLog  :  tReValueLog;}
                       Procedure RVXRateHed;

                       Procedure CalcIntraTotals(StkVal    :  AgedTyp);


                       Procedure PrintReportTot(GMode  :  Byte);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;
                     protected
                       RevalueRec  :  tRevalueRec;
                       RevalueLog  :  tReValueLog;
                       FDestroyLog : Boolean;
                     public

                       CRepParam   :  TPrintParamPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddRVRep2Thread(LMode    :  Byte;
                          IRepParam:  TPrintParamPtr;
                          const RVLog    :  tReValueLog;
                          AOwner   :  TObject);








{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  RpDefine,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  SysU1,
  SysU2,
  Saltxl1U,
  BTSupU1,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U,
  RevalueArchive;




{ ========== TMemoReport methods =========== }

  Constructor TRevalueLog.Create;

  Begin
    Inherited Create;

    fGot2Print:=BOff;

    ThisScrt:=nil;
  end;



  Destructor TRevalueLog.Destroy;

  Begin
    If (Assigned(ThisScrt)) then
    Begin
      Try
        Dispose(ThisScrt,Done);

      Finally
        ThisScrt:=nil;
      end;

    end;

    Inherited Destroy;
  end;


Procedure TRevalueLog.InitScratchfile;

Begin
  New(ThisScrt,Init(22,MTExLocal,BOff));

  ScratchFileN:=Filenames[ReportF];
end;

{ == Proc to check if MDC Ctrl code is in fact one of the nominated codes == }

Function TRevalueLog.Set_MDCCC(InvR     :  InvRec;
                               CtrlNom  :  LongInt)  :  LongInt;

Begin
  Result:=CtrlNom;

  If (CtrlNom=0) then
  Begin
    If (InvR.InvDocHed In SalesSplit) then
      Result:=Syss.NomCtrlCodes[Debtors]
    else
      Result:=Syss.NomCtrlCodes[Creditors];
  end;
end;


Procedure TRevalueLog.AddRevalueRec(SCurr  :  Byte);
Var
  RecAddr  :  LongInt;
  DPtr     :  tRevalueRec;

Begin
  With MTExLocal^ do
  Begin
    DPtr:=tRevalueRec.Create;

    Blank(DPtr.MatchRef,Sizeof(DPtr.MatchRef));

    With DPtr do
    Begin
      OrigOS:=OldOrigOS;
      BaseOS:=OldBaseOS;

      OrigXRate:=OldXRate;
      NewXRate:=ThisXRate;

      NewBase:=ThisBase;
      PrevRVA:=RVAdjust;

      RecType:=RVMode;
      RecCurr:=RVCurr;

      PrintRec:=PrintItem;

      Case RVFnum of
        NomF  :  Begin
                   MatchRef:=Form_Int(LNom.NomCode,0);
                   RepNomCode:=LNom.NomCode;

                   If (Copy(LInv.OurRef,1,3)=DocCodes[NMT]) then {Store the journal number created }
                     NomRef:=LInv.OurRef;
                 end;
        InvF  :  Begin
                   MatchRef:=LInv.OurRef;
                   RepNomCode:=Set_MDCCC(LInv,LInv.CtrlNom);
                 end;
      end; {case..}
    end;

    CalcRVStr(SCurr);

    Add(DPtr);

    LStatus:=LGetPos(RVFnum,RecAddr);  {* Get Preserve IdPosn *}

    ThisScrt^.Add_Scratch(RVFnum,RVKeypath,RecAddr,SortStr,IntToStr(Pred(Count)));

    Got2Print:=BOn;
  end; {With..}
end;

Procedure TRevalueLog.CalcRVStr(SCurr  :  Byte);
Begin
  With MTExLocal^ do
  Case RVFnum of
    InvF  :  With LInv do
               SortStr:=Form_Int(Set_MDCCC(LInv,CtrlNom),9)+OurRef[1]+Chr(Currency)+OurRef;

    NomF  :  With LNom do
               SortStr:=Form_Int(NomCode,9)+Chr(SCurr);

  end; {Case..}

  SortStr:=Chr(RVMode)+SortStr;
end;

Procedure TRevalueLog.ResetLine;
Begin
  OldOrigOS:=0.0;
  OldBaseOS:=0.0;
  ThisXRate:=0.0;
  ThisBase:=0.0;
  OldXRate:=0.0;
  RVCurr:=0;
  RVAdjust:=0.0;
  PrintItem:=BOn;
end;


Procedure TRevalueLog.SetPrintStatus(MStr  :  Str10;
                                     PStat :  Boolean;
                                     limit,
                                     MMode :  SmallInt );

Var
  FoundCount,
  n        :  Integer;

  DPtr     :  tRevalueRec;
Begin
  FoundCount:=0;

  For n:=Pred(Count) Downto 0 do
  Begin
    DPtr:=tRevalueRec(Items[n]);

    If (Assigned(DPtr)) then
    With DPtr do
      If (MStr=MatchRef) and (RecType=MMode) then
      Begin
        PrintRec:=PStat;

        If (Not PrintRec) then
        Begin
          DPtr.Free;
          Items[n]:=nil;
        end;
        
        Inc(FoundCount)
      end;

    If (FoundCount>=Limit) and (Limit<>0) then
      Break;
  end; {Loop..}
end;

Procedure TRevalueLog.SetNomRef(MStr  :  Str10;
                                CurM,
                                limit :  LongInt );

Var
  FoundCount,
  n        :  Integer;

  DPtr     :  tRevalueRec;
Begin
  FoundCount:=0;

  For n:=Pred(Count) Downto 0 do
  Begin
    DPtr:=tRevalueRec(Items[n]);

    If (Assigned(DPtr)) then
    With DPtr do
      If (((RecType=0) and (NomRef='')) or ((NomRef='') and (CurM=0))) and ((RecCurr=CurM) or (CurM=0)) then
      Begin
        NomRef:=MStr;

        Inc(FoundCount)
      end;

    If (FoundCount>=Limit) and (Limit<>0) then
      Break;
  end; {Loop..}
end;



{ ========== TRVReport methods =========== }

Constructor TRVReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  Blank(RepTot,Sizeof(RepTot));

  Blank(AggTot,Sizeof(Aggtot));

  Blank(CurrTot,Sizeof(Currtot));

  LastCurr:=255; LastRT:=255;
  LastGLCode:=-1;

  WasRT5:=BOff;
  FDestroyLog := True;
end;


Destructor TRVReport.Destroy;

Begin
  If (Assigned(CRepParam)) then
  Begin
    {If (Assigned(CRepParam^.UFont)) then // This font already destroyed as it mapes onto font from revalue routine
      CRepParam^.UFont.Free;}

    Dispose(CRepParam);
  end;


  Inherited Destroy;
end;




Procedure TRVReport.Process;

Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}
  InitStatusMemo(4);

  Try
    RFnum:=ReportF;
    RKeyPath:=RpK;
    RepKey:=FullNomKey(ReValueLog.ThisScrt^.Process);

    {Reopen previous scratch file}
    FileNames[RFnum]:=RevalueLog.ScratchFileN;

    ReValueLog.ThisScrt^.MTExLocal:=MTExLocal;

    With MTExLocal^ do
      LStatus:=Open_FileCId(LocalF^[RFnum],SetDrive+FileNames[RFnum],0,ExClientId);

    Inherited Process;

  finally
    if FDestroyLog then
      ReValueLog.Destroy;
  end; {try..}
end;



Procedure TRVReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,2:
           Begin
             SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
             SetTab (NA, pjLeft, 30, 4, 0, 0);
             SetTab (NA, pjLeft, 20, 4, 0, 0);
             SetTab (NA, pjRight, 29, 4, 0, 0);
             SetTab (NA, pjRight, 15, 4, 0, 0);
             SetTab (NA, pjRight, 29, 4, 0, 0);
             SetTab (NA, pjRight, 29, 4, 0, 0);
             SetTab (NA, pjRight, 15, 4, 0, 0);
             SetTab (NA, pjRight, 29, 4, 0, 0);
             SetTab (NA, pjRight, 29, 4, 0, 0);
             SetTab (NA, pjLeft, 25, 4, 0, 0);

            end;

    end; {Case..}
  end; {With..}

  SetTabCount;

end;




{ ======================= Due Header ======================= }



Procedure TRVReport.RVXrateHed;



Var
  n  :  Byte;

  PC1,PC2  :  Double;


Begin

  With CRepParam^, RepFiler1 do
  With {SyssCurr.Currencies[n],} RevalueLog do     
  Begin
    ClearTabs;

    SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 20, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 20, 4, 0, 0);

    //PR: 05/09/2016 ABSEXCH-17702
    SendTabsToXLSX(True);


    DefFont (3,[fsBold]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    SendLine(ConCat(#9,'Currency',#9,'Prev Daily Rate',#9,'New Daily Rate',#9,'% Change',#9,'Prev Company Rate',#9,'New Company Rate',#9,'% Change'));

    DefLine(-1,TabStart(1),TabEnd(7),0);

    DefFont (3,[]);

    For n:=Succ(CurStart) to CurrencyType do
    With SyssCurr.Currencies[n] do
    Begin
      If (PreSyssCurr.Currencies[n].CRates[BOn]<>CRates[BOn]) or (PreSyssCurr.Currencies[n].CRates[BOff]<>CRates[BOff]) then
      Begin
        PC1:=DivWChk(CRates[BOn]-PreSyssCurr.Currencies[n].CRates[BOn],PreSyssCurr.Currencies[n].CRates[BOn])*100;
        PC2:=DivWChk(CRates[BOff]-PreSyssCurr.Currencies[n].CRates[BOff],PreSyssCurr.Currencies[n].CRates[BOff])*100;

        SendLine(ConCat(#9,Ssymb+','+Desc,
               #9,FormatFloat(FormatDecStrSD(6,GenRealMask,BOff),PreSyssCurr.Currencies[n].CRates[BOn]),
               #9,FormatFloat(FormatDecStrSD(6,GenRealMask,BOff),CRates[BOn]),
               #9,FormatFloat(GenPcntMask,PC1),
               #9,FormatFloat(FormatDecStrSD(6,GenRealMask,BOff),PreSyssCurr.Currencies[n].CRates[BOff]),
               #9,FormatFloat(FormatDecStrSD(6,GenRealMask,BOff),CRates[BOff]),
               #9,FormatFloat(GenPcntMask,PC2))); //AP 09/03/2018 ABSEXCH-19866:Currency Revaluation Report > "% Change" for Company Rate is not displayed in the report even if changes are made in Company Rate
      end;



      If (LinesLeft<5) then
        ThrowNewPage(5);

    end;

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    RepSetTabs;

    //PR: 05/09/2016 ABSEXCH-17702
    SendTabsToXLSX(True);

    DefLine(-2,TabStart(1),TabEnd(TotTabs),0);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;
  end;

end;



Procedure TRVReport.RepPrintPageHeader;

Var
  GenStr  :  Str255;
  n       :  VATType;

Begin

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of

      1  :  Begin
              SendLine(ConCat(#9,'Ref',#9,#9,'Currency',#9,'Original Value',#9,'Orig. Rate',#9,'Orig. Base Equiv.',
                              #9,'Revalue Adjustment',#9,'New Rate',
                              #9,'New Base Equiv.',#9,'Difference',#9,'Journal Ref'));
            end;


    end; {case..}

    DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

    If (CurrentPage>1) then
      PrintNomLine(FullNomKey(EQGLCode),BOn);

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


Procedure TRVReport.RepPrintHeader(Sender  :  TObject);
Begin

  With RepFiler1 do
  Begin
    //PR: 05/09/2016 ABSEXCH-17702 If printing to xl, only print header if set in options.
    If (RepFiler1.CurrentPage = 1) Or (RDevRec.fePrintMethod <> 5) Or ((RDevRec.fePrintMethod = 5) And RDevRec.feMiscOptions[2]) Then
    Begin
      With RepFiler1 do
      Begin

        If (CurrentPage=1) then
        Begin
          RepSetTabs;

          SendTabsToXLSX(False);

          PrintHedTit;

          PrintStdPage;


          DefLine(-2,TabStart(1),TabEnd(TotTabs),0);


          RVXRateHed;
        end;

        RepPrintPageHeader;
      end;
    end;

  end; {With..}
end;


{ ======================= Calculate Due Totals ==================== }

Procedure TRVReport.CalcIntraTotals(StkVal    :  AgedTyp);




Begin

  With CRepParam^ do
  Case ReportMode of

    1,2    :  Begin

                GrandAgedTotal(RepTot,StkVal);
                GrandAgedTotal(AggTot,StkVal);
                GrandAgedTotal(CurrTot,StkVal);


              end;

  end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TRVReport.PrintReportTot(GMode  :  Byte);

Var
  n          :  Byte;

  GenStr     :  Str255;



Begin

  With CRepParam^,RepFiler1  do
  Case ReportMode of
    1,2  :  Begin
              DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

              GenStr:='Currency Total';

              Case GMode of
                1  :  Begin
                        CurrTot:=AggTot;

                        GenStr:='G/L Code '+Form_Int(EQGLCode,0)+' Total';
                      end;
                2  :  Begin
                        CurrTot:=RepTot;

                        GenStr:='Report Total';
                      end;

              end; {Case..}


              DefFont(0,[fsBold]);

              SendText(ConCat(ConstStr(#9,2),GenStr));

              For n:=1 to 7 do
              Begin
                If (n In [1,2,5]) then
                    CurrTot[n]:=0.0;

                SendText(ConCat(ConstStr(#9,n+3),FormatBFloat(GenRealMask,CurrTot[n],(n In [1,2,5]) or ((GMode=1) and (n=4) and (LastRT<>0)))));

              end;

              SendLine('');

              DefFont(0,[]);

              Blank(CurrTot,Sizeof(CurrTot));

              Case GMode of
                1  :  Blank(AggTot,Sizeof(AggTot))
              end; {Case..}


          end; {Case..}

  end; {Case..}

end;


Procedure TRVReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^, CRepParam^ do
  Begin
    Case ReportMode of
      1,2  :  Begin
                Case LRepScr^.FileNo of
                  InvF  :  Begin
                             SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
                             SendRepDrillDown(TotTabs,TotTabs,2,ReValueRec.NomRef,InvF,InvOurRefK,0);
                           end;  
                  NomF  :  Begin
                             SendRepDrillDown(1,TotTabs,1,FullNomKey(LNom.NomCode),NomF,NomCodeK,0);
                             SendRepDrillDown(TotTabs,TotTabs,2,ReValueRec.NomRef,InvF,InvOurRefK,0);
                           end;
                end;

              end;

    end; {Case..}
  end; {With..}
end;


Procedure TRVReport.PrintReportLine;


Var
  n          :  Byte;
  LineTot,
  TmpTot     :  AgedTyp;

  LGLCode    :  LongInt;

  tFmtStr,
  GenStr     :  Str255;


Begin


  Blank(LineTot,Sizeof(LineTot));
  Blank(TmpTot,Sizeof(TmpTot));


  With RepFiler1,MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      1,2  :  With ReValueRec do
              Begin
                If (LastCurr<>RecCurr) or (LastGLCode<>RepNomCode) then
                Begin
                  If (Not WasRT5) then {If we had an RT5 and RT11 before a change of G/L code seperate out the totals}
                    WasRT5:=(LastRT=5);

                  If (LastCurr<>255) and ((LastRT In [0])
                                     or ((LastRT=11) and (LastGLCode<>RepNomcode) and (WasRT5)))
                                     or ((LastRT=5) and (RecType=11) and (LastGLCode=RepNomCode)) then
                    PrintReportTot(0);

                  LastCurr:=RecCurr;

                  If (LastGLCode<>-1) and (LastGLCode<>RepNomcode) then
                  Begin
                    If (LastRT<>5) then
                      PrintReportTot(1)
                    else
                      Blank(AggTot,Sizeof(AggTot));
                  end;    


                  If (LastGLCode<>RepNomcode) then
                  Begin
                    wasRT5:=BOff;

                    LastGLCode:=RepNomCode;

                    If (LastGLCode=0) and (RecType=0) then
                    Begin
                      If (LInv.InvDocHed In SalesSplit) then
                        EQGLCode:=Syss.NomCtrlCodes[Debtors]
                      else
                        EQGLCode:=Syss.NomCtrlCodes[Creditors];

                    end
                    else
                      EQGlCode:=LastGLCode;

                    PrintNomLine(FullNomKey(EQGLCode),BOff);
                  end;


                  LastRT:=RecType;
                end;

              end;

    end; {Case..}

    SetReportDrillDown(0);

    Case ReportMode of
      1,2
         :  Begin
              With ReValueRec do
              Begin
                LineTot[1]:=OrigOS;
                LineTot[2]:=OrigXRate;
                LineTot[3]:=BaseOS;
                LineTot[4]:=PrevRVA;
                LineTot[5]:=NewXRate;
                LineTot[6]:=NewBase;
                LineTot[7]:=NewBase-BaseOS;

                With RevalueLog.ThisScrt^ do
                Case LRepScr^.FileNo of
                  InvF  :  Genstr:=MTExlocal^.LInv.OurRef+#9;
                  NomF  :  GenStr:=Form_Int(MTExlocal^.LNom.NomCode,0)+#9+MTExlocal^.LNom.Desc;
                end; {Case..}

                If (LastRT=11) then {Its an additional auto fix adjustment}
                  GenStr:=GenStr+', correction';
                  
                SendText(ConCat(#9,GenStr,#9,CurrDesc(RecCurr)));

                SendText(ConCat(ConstStr(#9,4),FormatCurFloat(GenRealMask,LineTot[1],BOn,RecCurr)));

                For n:=2 to 7 do
                Begin
                  If (Not (n In [2,5])) then
                    tFmtStr:=GenRealMask
                  else
                    tFmtStr:=FormatDecStrSD(6,GenRealMask,BOff);

                  SendText(ConCat(ConstStr(#9,n+3),FormatBFloat(tFmtStr,LineTot[n],(n In [1,2,4,5]) or ((RecType In [10,11]) and (n In [3,6])))));

                end;

                SendLine(ConCat(ConstStr(#9,11),NomRef));

                //PR: 03/02/2010 This was freeing the revalue records before the second pass used them - added check
                if FDestroyLog then
                  ReValueRec.Free;

                CalcIntraTotals(LineTot);

              end; {With..}

          end;


    end; {Case..}

  end; {With(s)..}
end;



{ ======================= VAT End ======================= }


Procedure TRVReport.PrintEndPage;

Var
  TmpRepMode  :  Integer;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    If (LastCurr<>255) then
      For TmpRepMode:=0 to 2 do
        If (TmpRepMode<>0) or (LastRT=0) then
          PrintReportTot(TmpRepMode);
  end; {With..}
end;







{ ======================= VAT Include ======================= }


Function TRVReport.IncludeRecord :  Boolean;

Var
  TmpInclude :  Boolean;
  KeyCS      :  Str255;
  LinkL      :  Integer;


Begin

  {$B-}

  With MTExLocal^,CRepParam^ do
  Begin
    Case ReportMode of
      1,2
           :  With RevalueLog do
              Begin
                ThisScrt^.Get_Scratch(LRepScr^);

                LInv:=ThisScrt^.MTExLocal.LInv;
                
                LNom:=ThisScrt^.MTExLocal.LNom;

                LinkL:=StrToInt(LRepScr^.KeyStr);

                If (Assigned(Items[LinkL])) then
                Begin
                  ReValueRec:=tRevalueRec(Items[LinkL]);

		  TmpInclude:=RevalueRec.PrintRec;
                end
                else
                  TmpInclude:=BOff;

              end;
           else  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390
             raise Exception.Create('Invalid ReportMode in TRVReport.IncludeRecord: ' + IntToStr(ReportMode));


    end; {Case..}
  end; {With..}

    {$B+}

  Result:=TmpInclude;
end; {Func..}









Function TRVReport.GetReportInput  :  Boolean;

Var
  NYear,
  VSYr,VSPr  :  Integer;


Begin
  With CRepParam^ do
  Begin


    ThTitle:='Revalue Report';

    RepTitle:=' Rate Currency Revaluation Report';

{    if not FDestroyLog then
      RepTitle := RepTitle + ' Archive';}

    If (UseCODayRate) then
      RepTitle:='Daily'+RepTitle
    else
      RepTitle:='Company'+RepTitle;
      
    If (Debug) then
    Begin

    end;

    PageTitle:=Reptitle;

    RFont.Size:=7;


  end; {With..}

  Result:=BOn;
end;





Procedure TRVReport.Finish;


Begin
  SleepEx(2000, True);
  Inherited Finish;

end;


{ ======== }




Procedure AddRVRep2Thread(LMode    :  Byte;
                          IRepParam:  TPrintParamPtr;
                          const RVLog    :  tReValueLog;
                          AOwner   :  TObject);


Var
  EntTest  :  ^TRVReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin

        If (Assigned(IRepParam)) then
          CRepParam^:=IRepParam^;

        With CRepParam^ do
        Begin
          RDevRec:=PDevRec;
          RFont.Assign(UFont);
          ROrient:=Orient;
        end;

        ReValueLog:=RVLog;

        NoDeviceP:=BOn;

        ReportMode:=LMode;

        If (Create_BackThread) and (Start) then
        Begin
          {$IFDEF EXSQL}
           if not SQLUtils.UsingSQL or not Assigned(ReValueLog.MTExLocal) then
          {$ENDIF}
            ReValueLog.MTExLocal:=EntTest.MTExLocal;

          //PR: 08/10/2009 Print report to archive file  
          AddRVArchRep2Thread(LMode, IRepParam, ReValueLog, AOwner);

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





{ tRevalueRec }

destructor tRevalueRec.Destroy;
begin
  inherited;
end;

Initialization



Finalization

end.



