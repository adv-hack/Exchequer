{ ============== TJLMList Methods =============== }

constructor TJLMList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SortView := TJobLedgerSortView.Create;
end;

destructor TJLMList.Destroy;
begin
  FreeAndNil(FSortView);
  inherited Destroy;
end;

function TJLMList.GetSortView: TJobLedgerSortView;
begin
  Result := FSortView as TJobLedgerSortView;
end;

procedure TJLMList.SetSortView(const Value: TJobLedgerSortView);
begin
  inherited SetSortView(Value);
end;

Function TJLMList.CheckRowEmph :  Byte;


Begin
  Case DisplayMode of
    31,32  :  Result:=Ord(JobDetl^.JobActual.Posted);

    40..42 :  Result:=0; {*EN560 finish with o/s status *}

    51,52  :  Result:=Ord(JobDetl^.JobReten.RetDate<=Today);

    else      Result:=0;
  end;
end;


procedure TJLMList.ExtObjCreate;

Begin
  Inherited;

  StkExtRecPtr:=nil;
  StkExtObjPtr:=nil;

  If (LNHCtrl.NHNeedGExt) then
  Begin
    New(StkExtRecPtr);

    FillChar(StkExtRecPtr^,Sizeof(StkExtRecPtr^),0);

    New(StkExtObjPtr,Init);

    ExtRecPtr:=StkExtRecPtr;
    ExtObjPtr:=StkExtObjPtr;
  end;
end;

procedure TJLMList.ExtObjDestroy;

Begin
  If (StkExtRecPtr<>nil) then
    Dispose(StkExtRecPtr);

  If (StkExtObjPtr<>nil) then
    Dispose(StkExtObjPtr,Done);

  Inherited;

  StkExtRecPtr:=nil;
  StkExtObjPtr:=nil;

end;



{ ========== Function to Evaluate Filter ========== }


Function TJLMList.ExtFilter  :  Boolean;

Var
  TmpBo      :  Boolean;

Begin

  TmpBo:=BOff;


  With StkExtRecPtr^ do
  With JobDetl^.JobActual do
  Begin
    TmpBo:=((((FYr=ActYr) or (FYr=YTD)) and ((FPr=ActPr) or (FPr In [YTD,YTDNCF]))
           and ((ActCurr=FCr) or (FCr=YTD) or (Fmode=32))
           and ((((JDDT In PsopSet+QuotesSet +JAPOrdSplit  {$IFDEF STK}  -StkExcSet {$ENDIF} ) or (PostedRun=OrdPPRunNo)) and (FPSOP))
           or   ((Not (JDDT In PsopSet+QuotesSet +JAPOrdSplit  {$IFDEF STK} -StkExcSet {$ENDIF})) and (Not FPSOP) and (PostedRun<>OrdPPRunNo))))
           or (Fmode In [25..29]));

    {$IFDEF STK}

      If (TmpBo) then  {* Exclude any actual lines which had no budget stock
                          record when posting took place, otherwise DD would show all *}
      Begin

        TmpBo:=(((Fmode<>14) or (Post2Stk)));

      end;

    {$ENDIF}

    If (TmpBo) then
      Case FMode of

      16,18  :  TmpBo:=((HFolio_Txlate(JAType)<=HFolio_Txlate(SysAnlsEnd)) or (JAType=SysAnlsProfit));
      17,19  :  TmpBo:=(((HFolio_Txlate(JAType)<HFolio_Txlate(SysAnlsEnd)) and (JAType<>SysAnlsRev)) or (JAType=SysAnlsWIP));
      25..29 :  TmpBo:=((HFolio_Txlate(JAType)<=HFolio_Txlate(SysAnlsEnd)) and (JAType>SysAnlsRev) and (Posted) and (Not Invoiced))
                        and (Not (JDDT In PsopSet+QuotesSet + JAPSplit {$IFDEF STK} -StkExcSet {$ENDIF}) and (PostedRun<>OrdPPRunNo));

      32     :  TmpBo:=Posted;



      end; {Case..}

  end;

  Result:=TmpBo;

end;






Function  TJLMList.GetExtList(B_End      :  Integer;
                          Var KeyS       :  Str255)  :  Integer;

Var
  TmpStat   :  Integer;


Begin

  TmpStat:=0;

  Begin

    With StkExtRecPtr^ do
    Begin

      If (B_End In [B_GetPrev,B_GetNext]) and (StkExtObjPtr<>nil) then
      Begin

        DispExtMsg(BOn);

        {If (FMode In [3,4]) then
          TmpStat:=FindExtCuStk(B_End,KeyS)
        else}
          TmpStat:=StkExtObjPtr^.GetSearchRec(B_End+30,ScanFileNum,KeyPath,KeyS,KeyRef[1],KeyRef[2],FDesc,
                                         JAnl1,JAnl2,JAnl3,FCr,FYr,FPr,FMode);


        DispExtMsg(BOff);

      end
      else

        TmpStat:=Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

    end;{With..}

  end; {With..}

  Result:=TmpStat;

end; {Func..}


{ ================== Procedure to Setup Job Actual Constants =============== }

Procedure TJLMList.SetJADefaults(Const MainStr   :  Str255;
                                 Var  LKeyLen    :  Integer;
                                      NomKey     :  Str255);



Begin


  With LNHCtrl do
  Begin
    NHNeedGExt:=BOff;



    Case DisplayMode of


       13..19
           :   Begin

                 NHNeedGExt:=(DisplayMode>=13);

                 LKeyLen:=Length(MainStr)-3;

                 {$IFDEF MC_On}

                   If (NHCr<>0) and (DisplayMode<16) then
                   Begin

                     LKeyLen:=LKeyLen+3; {* Include currency +Yr+Pr *}

                     If (NHPr In [YTD,YTDNCF]) then   {* Searching by year only *}
                     Begin

                       Dec(LKeyLen);

                     end;

                     NHNeedGExt:=BOff;
                   end;

                 {$ELSE}

                   If (DisplayMode<16) then
                   Begin

                     LKeyLen:=LKeyLen+3; {Include Currency, Period & Year}

                     If (NHPr In [YTD,YTDNCF]) then   {* Searching by year only *}
                     Begin
                       Dec(LKeyLen);

                     end;

                     NHNeedGExt:=BOff;

                   end;

                 {$ENDIF}

                 If (DisplayMode In [16..19]) then {* We can only really match job code *}
                   LKeyLen:=JobCodeLen+2;


                 {MainStr:=Copy(MainStr,1,LKeyLen);}

                 If (NHNeedGExt) then
                 Begin

                   With StkExtRecPtr^ do
                   Begin


                     {$IFDEF MC_On}

                       FCr:=NHCr;

                       If (FCr=0) then
                         FCr:=YTD;

                     {$ELSE}

                       FCr:=YTD;

                     {$ENDIF}


                     If (Not (DisplayMode In [16..17])) then
                     Begin
                       FPr:=NHPr;
                       FYr:=NHYr;
                     end
                     else
                     Begin

                       FPr:=YTD;
                       FYr:=YTD;

                     end;

                     FDesc:=NomKey;

                     FMode:=DisplayMode;

                     FPSOP:=GlobCMode;

                     Case DisplayMode of

                       16,18  :  Begin  {* Looking at Profit *}

                                   JAnl1:=Succ(SysOH2);

                                   JAnl2:=SysAnlsProfit;

                                   JAnl3:=SysAnlsProfit;

                                 end;

                       17,19  :  Begin  {* Looking at WIP *}

                                   JAnl1:=Succ(SysOH2);
                                   
                                   JAnl2:=SysAnlsRev;

                                   JAnl3:=SysAnlsWIP;

                                 end;

                     end; {Case..}


                   end;

                 end;
               end;



    end; {Case..}


  end; {With..}
end; {Proc..}




Function TJLMList.SetCheckKey  :  Str255;


Var

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With JobDetl^,JobActual do
  Case DisplayMode of
    2  :  DumStr:=PartCCKey(RecPfix,SubType)+LedgerCode;

    3,13
       :  DumStr:=PartCCKey(RecPfix,SubType)+FullJADDKey(AnalKey,ActCurr,ActYr,ActPr);

    4,14
       :  DumStr:=PartCCKey(RecPfix,SubType)+FullJADDKey(StockKey,ActCurr,ActYr,ActPr);

    5,15
       :  DumStr:=PartCCKey(RecPfix,SubType)+FullJADDKey(HedKey,ActCurr,ActYr,ActPr);

    16..19
       :  DumStr:=PartCCKey(RecPfix,SubType)+JobCode;

    29 :  DumStr:=PartCCKey(RecPfix,SubType)+LedgerCode;

    31,32
       :  DumStr:=PartCCKey(RecPfix,SubType)+EmplKey;

    40..42
       :  DumStr:=Inv.TransDesc;
    51,52
       :  DumStr:=PartCCKey(RecPfix,SubType)+JobReten.RetenCode;


    else  DumStr:=PartCCKey(RecPfix,SubType)+RunKey;
  end; {Case..}


  SetCheckKey:=DumStr;
end;




Function TJLMList.SetFilter  :  Str255;

Var
  IncRec :  Boolean;
  InDocumentSet: Boolean;
  IsPostedPurchaseOrder: Boolean;
Begin
  IncRec := False;
  If (Not (DisplayMode In [29,31,32,51,52])) then
  With JobDetl^.JobActual do
  Begin
    {
      Code re-factored for clarity.

      PSOPSet = Orders & Deliveries (SOR, POR, SDN, PDN)
      QuotesSet = Quotes (SQU, PQU)
      JAPOrdSplit = Contract & Sales Terms (JCT, JST)
      GlobCMode: if True, view commitment lines
    }
    InDocumentSet := JDDT in PSOPSet + QuotesSet + JAPOrdSplit{$IFDEF STK} - StkExcSet{$ENDIF};
    IsPostedPurchaseOrder := (PostedRun = OrdPPRunNo);
    if GlobCMode then
      IncRec := InDocumentSet or IsPostedPurchaseOrder
    else if not GlobCMode then
      IncRec := not(InDocumentSet or IsPostedPurchaseOrder);

//    IncRec:=((((JDDT In PSOPSet+QuotesSet +JAPOrdSplit  {$IFDEF STK} -StkExcSet  {$ENDIF}) or (PostedRun=OrdPPRunNo)) and (GlobCMode))
//           or ((Not (JDDT In PSOPSet+QuotesSet +JAPOrdSplit  {$IFDEF STK} -StkExcSet {$ENDIF})) and (PostedRun<>OrdPPRunNo) and (Not GlobCMode)));

  end
  else
    IncRec:=BOff;


  Case DisplayMode of

     4,14  : With JobDetl^.JobActual do
               Result:=Chr(Ord((Post2Stk and IncRec)));

     29    : With JobDetl^.JobActual do
                 Result:=Chr(JAType);

     40..42
           :  Result:=#1;

     31,32,
     51,52
           :  Result:=JobDetl^.RecPFix;

     else    Result:=Chr(Ord(IncRec));

   end; {Case..}


end;


Function TJLMList.Ok2Del :  Boolean;

Begin
  Case DisplayMode of
    29,32,33
           :  Result:=BOff;
    51,52  :  Result:=BOn;
    else      Result:=Ok2DelJob(0,JobRec^);
  end; {case...}
end;


Function TJLMList.Link2Inv  :  Boolean;

Var
  KeyI  :  Str255;

Begin
  Result:=BOff;

  With JobDetl^,JobActual, JobReten do
  Begin
    Case DisplayMode of
      51,52  :  KeyI:=RetDoc;

      else      KeyI:=LineORef;

    end; {case..}

    If (Inv.OurRef<>KeyI) then
      Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI)
    else
      Status:=0;

    LinePosted:=((StatusOk) and (Inv.RunNo<>0) and (Inv.RunNo<>BatchRunNo));

    Result:=StatusOk;
  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJLMList.OutALGLine(Col  :  Byte)  :  Str255;



Var
  GenStr :  Str255;

  UOR,
  TCr    :  Byte;

  Dnum   :  Double;

  ExLocal: ^TdExLocal;

Begin
  UOR:=0;

  ExLocal:=ListLocal;

  With ExLocal^,LNHCtrl,JobDetl^,JobActual do
  Begin
    Case Col of

         0  :  Result:=LineORef;
         1  :  Result:=POutDate(JDate);
         2  :  Result:=AnalCode;

         3  :  Begin
                 Dnum:=Qty*DocCnst[JDDT];
                 If (JDDT In SalesSplit) then
                   Dnum:=Dnum*DocNotCnst;


                 Result:=FormatBFloat(GenQtyMask,Dnum,(Qty=0.0));
               end;

         4  :  Begin

                 TCr:=ActCurr;

                   If (JDDT In JAPSplit) then
                     Dnum:=(Round_Up(Cost,2)*DocCnst[JDDT])
                   else
                     Dnum:=(Round_Up(Qty*Cost,2)*DocCnst[JDDT]);

                 {$IFDEF MC_On}

                   If (NHCr=0) then
                   Begin
                     UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                     Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);

                     TCr:=0;
                   end;

                   If (NHTxCr<>0) then
                   Begin
                     Dnum:=Currency_Txlate(Dnum,NHCr,NHTxCr);
                     TCr:=NHTxCr;
                   end;
                 {$ENDIF}

                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;
         5  :  Begin

                 If (JDDT=TSH) then
                   TCr:=CurrCharge
                 else
                   TCr:=LJobRec^.CurrPrice;

                 Dnum:=Currency_ConvFT(Charge,CurrCharge,TCr,UseCoDayRate);


                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;

         6  :  Begin

                 TCr:=ActCurr;

                 Dnum:=(Round_Up(Qty*UpliftTotal,2)*DocCnst[JDDT]);
                 

                 {$IFDEF MC_On}

                   If (NHCr=0) then
                   Begin
                     UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                     Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);

                     TCr:=0;
                   end;

                   If (NHTxCr<>0) then
                   Begin
                     Dnum:=Currency_Txlate(Dnum,NHCr,NHTxCr);
                     TCr:=NHTxCr;
                   end;
                 {$ENDIF}

                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;

         7  :  Result:=ActCCode;

         else
               Result:='';
    end; {Case..}
  end; {With..}
end;



Function TJLMList.OutJRTLine(Col  :  Byte)  :  Str255;

Const
  RetStatus :  Array[BOff..BOn] of Str20 = ('O/S','Invoiced');


Var
  GenStr :  Str255;

  TCr    :  Byte;

  Dnum   :  Double;

  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  With ExLocal^,LNHCtrl,JobDetl^,JobReten do
  Begin
    Case Col of

         0  :  Result:=RetCustCode;
         1  :  Result:=RetCrDoc;
         2  :  Result:=POutDate(OrigDate);
         3  :  Result:=POutDate(RetDate);

         4  :  Begin

                 TCr:=RetCurr;

                 Dnum:=RetValue;

                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;
         5  :  Begin
                 Result:=RetStatus[Invoiced];
               end;

         else
               Result:='';
    end; {Case..}
  end; {With..}
end;


  Function TJLMList.OutJALine(Col  :  Byte)  :  Str255;


  Var
    Foundcode
           :  Str20;
    GenStr :  Str255;

    TCr    :  Byte;

    Dnum   :  Double;

    ExLocal: ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    With ExLocal^,Inv do
    Begin
      Case Col of

           0  :  If (InvDocHed In JAPSalesSplit) then
                   Result:=CustCode
                 else
                   Result:=CISEmpl;

           1  :  Result:=OurRef;
           2  :  Result:=POutDate(TransDate);

           3  :  Begin
                   If (JobRec^.JobCode<>DJobCode) then
                     GetJob(Self.Owner,DJobCode,FoundCode,-1);

                   With JobRec^ do
                     Result:=dbFormatName(JobCode,JobDesc);
                 end;

           4  :  Begin

                   TCr:=Currency;

                   If (InvDocHed In [JSA,JPA]) then
                     Dnum:=GetJAParentTotal(Inv,0)
                   else
                     Dnum:=TotalCost;

                   Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
                 end;
           5  :  Begin
                   Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,PDiscTaken,BOff);
                 end;


           else
                 Result:='';
      end; {Case..}
    end; {With..}
  end;

Function TJLMList.OutLine(Col  :  Byte)  :  Str255;


Begin
  Case DisplayMode of
    40..42  :  Result:=OutJALine(Col);

    51..52  :  Result:=OutJRTLine(Col);
    else       Result:=OutALGLine(Col);

  end; {Case..}
end;



{ =================================================================================== }

