{ ============== TSLMList Methods =============== }

constructor TSLMList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SortView := TStockLedgerSortView.Create;
  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
  UseDefaultSortView := True;
end;

destructor TSLMList.Destroy;
begin
  FreeAndNil(FSortView);
  inherited Destroy;
end;

function TSLMList.GetSortView: TStockLedgerSortView;
begin
  Result := FSortView as TStockLedgerSortView;
end;

procedure TSLMList.SetSortView(const Value: TStockLedgerSortView);
begin
  inherited SetSortView(Value);
end;

procedure TSLMList.ExtObjCreate;

Begin
  Inherited;


  StkExtRecPtr:=nil;
  StkExtObjPtr:=nil;

  Blank(CCNomFilt,Sizeof(CCNomFilt));
  CCNomMode:=BOff;

  If (LNHCtrl.NHNeedGExt) then
  Begin
    New(StkExtRecPtr);

    FillChar(StkExtRecPtr^,Sizeof(StkExtRecPtr^),0);

    New(StkExtObjPtr,Init);

    ExtRecPtr:=StkExtRecPtr;
    ExtObjPtr:=StkExtObjPtr;
  end;
end;

procedure TSLMList.ExtObjDestroy;

Begin
  If (StkExtRecPtr<>nil) then
    Dispose(StkExtRecPtr);

  If (StkExtObjPtr<>nil) then
    Dispose(StkExtObjPtr,Done);

  Inherited;

  StkExtRecPtr:=nil;
  StkExtObjPtr:=nil;

end;


Function TSLMList.ExtFilter  :  Boolean;

Var
  TmpBo      :  Boolean;

Begin
  With StkExtRecPtr^ do
  Begin
    TmpBo:=((FYr=Id.PYr) and ((FPr=Id.PPr) or (FPr In [YTD,YTDNCF])) and (Id.PostedRun>FPostedRun));

    If (FMode In [2,4]) then
      TmpBo:=((TmpBo) and (FCr=Id.Currency));

  end;

  Result:=TmpBo;

end;


Function TSLMList.FindExtCuStk(B_End      :  Integer;
                           Var KeyS       :  Str255)  :  Integer;

    Var
      TmpStat   :  Integer;

      KeyChk    :  Str255;

      Fail,
      FoundOk   :  Boolean;


    Begin
      {$IFNDEF OC2_On}

        With StkExtRecPtr^ do
        Begin

          If (FIsaC) then
            KeyChk:=StkLineType[SIN]
          else
            KeyChk:=StkLineType[PIN];


          KeyChk:=KeyChk+Full_CuStkIKey(FCustCode,FStkCode);

          Repeat

            TmpStat:=Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

            FoundOk:=(TmpStat=0) and (ExtFilter);

            Fail:=(TmpStat<>0) or (Not CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

          Until (FoundOk) or (Fail);

          If (Fail) and (TmpStat=0) then
            TmpStat:=4;


        end; {with..}
      {$ELSE}
        TmpStat:=0;

      {$ENDIF}
      FindExtCuStk:=TmpStat;
    end;


Function  TSLMList.GetExtList(B_End      :  Integer;
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

        If (FMode In [3,4]) then
          TmpStat:=FindExtCuStk(B_End,KeyS)
        else
          TmpStat:=StkExtObjPtr^.GetSearchRec2(B_End+30,ScanFileNum,KeyPath,KeyS,FStkCode,FCustCode,FIsaC,FPostedRun,FCr,FYr,FPr,FMode);

        DispExtMsg(BOff);

      end
      else

        TmpStat:=Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

    end;{With..}

  end; {With..}

  Result:=TmpStat;

end; {Func..}




Function TSLMList.SetCheckKey  :  Str255;


Var

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Id do
  Case Keypath of
    {$IFDEF PF_On}

      IdCAnalK  :  DumStr:=LineType+Full_CuStkIKey(CustCode,StockCode)+PDate;

      IdAnalK   :  DumStr:=LineType+StockCode;

    {$ELSE}

      IdCAnalK  :  DumStr:=FullStockCode(StockCode);

    {$ENDIF}

    else            DumStr:=FullStockCode(StockCode);
  end; {Case..}


  SetCheckKey:=DumStr;
end;


Function TSLMList.GetStkLBFilt(RStr  :  Str255;
                               IdR   :  Idetail)  :  Str255;

Begin
  Result:=RStr;

  With IdR do
  Case FilterMode of {Live Orders}
                 {Live Sales Orders}
    1  :  If (Not (IdDocHed In StkAllSet+StkOrdSet-PurchSplit)) or (Qty_OS(IdR)=0.0) then
            Result:=NdxWeight;

             {Live Purch Orders}
    2,17
       :  If (Not (IdDocHed In WOPSPlit+StkAllSet+StkOrdSet-SalesSplit)) or ((Qty_OS(IdR)=0.0) and (FilteRMode<>17)) then
            Result:=NdxWeight;

             {Live Orders}
    3  :  If (Not (IdDocHed In StkAllSet+StkOrdSet)) or (Qty_OS(IdR)=0.0) then
            Result:=NdxWeight;

            {Picked Orders}
    4  :  If (Not (IdDocHed In StkAllSet+StkOrdSet)) or (QtyPick=0.0) then
            Result:=NdxWeight;
            {Sales Orders}
    5  :  If (Not (IdDocHed In StkAllSet+StkOrdSet-PurchSplit)) then
            Result:=NdxWeight;

            {Purch Orders}
    6  :  If (Not (IdDocHed In StkAllSet+StkOrdSet-SalesSplit)) then
            Result:=NdxWeight;

            {Orders}
    7  :  If (Not (IdDocHed In StkAllSet+StkOrdSet+WOPSplit)) then
            Result:=NdxWeight;

            {Sales Delivey Notes}
    8  :  If (Not (IdDocHed In DeliverSet-PurchSplit)) then
            Result:=NdxWeight;

            {Purch Delivey Notes}
    9  :  If (Not (IdDocHed In DeliverSet-SalesSplit)) then
            Result:=NdxWeight;

            {Delivey Notes}
    10 :  If (Not (IdDocHed In DeliverSet)) then
            Result:=NdxWeight;

            {All other Sales transactions}
    11 :  If (IdDocHed In PSOPSet+StkAllSet+StkOrdSet+PurchSplit+StkADJSplit) then
            Result:=NdxWeight;
            {All other Purch transactions}
    12 :  If (IdDocHed In PSOPSet+StkAllSet+StkOrdSet+SalesSplit+StkAdjSplit) then
            Result:=NdxWeight;
            {All other Adj transactions}
    13 :  If (IdDocHed In PSOPSet+StkAllSet+StkOrdSet+SalesSplit+PurchSplit) then
            Result:=NdxWeight;

            {All other transactions}
    14 :  If (IdDocHed In PSOPSet+StkAllSet+StkOrdSet) then
            Result:=NdxWeight;

    15 :  Begin
            FilterMode:=0;
            FillChar(Filter[1,1],Sizeof(Filter[1,1]),0);
          end;

    19..21
       :  If (Not (IdDocHed In StkRetSplit)) or ((IdDocHed<>SRN) and (FilterMode=19)) or ((IdDocHed<>PRN) and (FilteRMode=20)) then
            Result:=NdxWeight;

    46 :  {* Special Cust anal Filter to allow SDN's to be included in Drill down as they do affect stock sales *}
          If (IdDocHed In PSOPSet+StkAllSet+StkOrdSet+PurchSplit+StkADJSplit-DeliverSet) then
            Result:=NdxWeight;


  end; {Case..}
end;


Function TSLMList.CStkCCDFiltSet  :  Boolean;

Begin
  CStkCCDFiltSet:=(Syss.UseCCDep and (Syss.PostCCNom) and
                  (Not EmptyKeyS(CCNomFilt,ccKeyLen,BOff)));

end;


Function TSLMList.ChkCCDFilter(ICCDP     :  CCDepType)  :  Boolean;
Begin

  ChkCCDFilter:=CheckKey(CCNomFilt,ICCDP[CCNomMode],Length(CCNomFilt),BOff);

end;



Function TSLMList.SetFilter  :  Str255;

Begin
  If (LNHCtrl.NHCr<>0) then
  {$IFDEF SOP}
    Begin
      If (GlobLocFiltSet) then
        Result:=Chr(Id.Currency)+Id.MLocStk+FullCustCode(Id.CustCode)
      else
        Result:=Chr(Id.Currency)+FullCustCode(Id.CustCode);
    end
    else
    Begin
      If (GlobLocFiltSet) then
        Result:=Id.MLocStk+FullCustCode(Id.CustCode)
      else
        Result:=FullCustCode(Id.CustCode);
    end;
  {$ELSE}
    Result:=Chr(Id.Currency)+FullCustCode(Id.CustCode)
  else
    Result:=FullCustCode(Id.CustCode);
  {$ENDIF}

  If (FilterMode<>0) then
    Result:=GetStkLBFilt(Result,Id);

  {$IFDEF PF_On}
    {$B-}

      If (CStkCCDFiltSet) and (Not ChkCCDFilter(Id.CCDep)) then
        Result:=NdxWeight;

    {$B+}

  {$ENDIF}

end;


Function TSLMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;


Procedure TSLMList.Link2Inv;

Const
  Fnum     =  InvF;
  KeyPath2 =  InvFolioK;




Var
  TmpKPath,
  TmpStat:  Integer;

  TmpRecAddr
         :  LongInt;

  KeyS   :  Str255;

  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  If (ExLocal^.LInv.FolioNum<>Id.FolioRef) then
  Begin
    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    ResetRec(Fnum);

    KeyS:=FullNomKey(Id.FolioRef);

    If (Id.FolioRef<>0) then
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);

    ExLocal^.AssignFromGlobal(Fnum);

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
  end;
end; {Proc..}





{ ========== Generic Function to Return Formatted Display for List ======= }


Function TSLMList.OutLine(Col  :  Byte)  :  Str255;


Const
  Fnum     =  InvF;
  KeyPath2 =  InvFolioK;




Var
  TxCr   :  Integer;


  UPCost :  Double;

  KeyS   :  Str255;

  StockPos
         :  StockPosType;

  TmpQtyMul,
  TmpQty,
  Rnum   :  Real;

  GenStr :  Str255;

  UOR,
  TCr    :  Byte;

  ExLocal: ^TdExLocal;

Begin

  With Id do
  Begin

    Rnum:=0; UPCost:=0.0;

    TmpQty:=0;

    TmpQtyMul:=0; UOR:=0;

    {$IFDEF Inv}

      Stock_Effect(StockPos,Id,DeductQty,BOn);

      {$IFDEF SOP}
        If (Syss.UsePick4All) then {* Subst Picked for allocated *}
          StockPos[3]:=StockPos[5];
      {$ENDIF}
    {$ELSE}

      Blank(StockPos,Sizeof(StockPos));

      StockPos[2]:=DeductQty;

    {$ENDIF}

    {* Adjust display for Purch docs with a jobcode present, although
       they have no effect on stock, show as if thet went in, and came
       out *}

    {$IFDEF PF_On}

      {$IFDEF Inv}

        Job_StockEffect(StockPos,Id);

      {$ENDIF}

    {$ENDIF}

    ExLocal:=ListLocal;

    Link2Inv;

     With ExLocal^,LNHCtrl,LInv do
     Begin
       Case Col of

         0  :  Result:=OurRef;
         1  :  Result:=POutDate(PDate);
         2  :  Result:=CustCode;

         3..6
            :  Result:=FormatBFloat(GenQtyMask,CaseQty(Stock,StockPos[Col-2]),(StockPos[Col-2]=0.0));

         7,8:  Result:=FormatBFloat(GenQtyMask,CaseQty(Stock,StockPos[Col-1]),(StockPos[Col-1]=0.0));

         9,10
             :  Result:=FormatBFloat(GenQtyMask,CaseQty(Stock,StockPos[Col]),(StockPos[Col]=0.0));

         11  :  Begin
                 If (IdDocHed In StkAdjSplit) then
                 Begin
                   If (Qty<0) then
                     TmpQty:=-1
                   else
                     TmpQty:=1;

                   Rnum:=CostPrice*TmpQty;
                 end
                 else
                 Begin

                   TmpQty:=Qty;

                   TmpQtyMul:=QtyMul;

                   If (Stock.CalcPack) then
                     QtyMul:=1;

                   Qty:=1;

                   //PR: 06/01/2009 20070115103431 For PCRs uplift was being deducted from the line total rather than added. Changed
                   //to multiply by the correct sign

                   {If (IdDocHed In PurchSplit) then
                     UPCost:=CostPrice;}
                   If (IdDocHed In PurchSplit) then
                     UPCost:=CostPrice * DocCnst[IdDocHed];


                   Rnum:=(DetLTotalND(Id,BOn,BOff,BOn,LInv.DiscSetl)+UPCost)*DocNotCnst;

                   Qty:=TmpQty;

                   QtyMul:=TmpQtyMul;

                 end;

                 TxCr:=NHCr;

                 If (NHCr=0) then
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                   Rnum:=Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                 end;

                 If (NHTxCr<>0) then
                 Begin
                   Rnum:=Currency_Txlate(Rnum,NHCr,NHTxCr);
                   TxCr:=NHTxCr;
                 end;

                 If (Not PChkAllowed_In(143)) and (Not (IdDocHed In SalesSplit)) then {* Hide Unit Cost *}
                   Rnum:=0.0;

                 Result:=FormatCurFloat(GenUnitMask[BOn],Rnum,BOff,TxCr);
               end;

         else
               Result:='';
       end; {Case..}
     end; {With..}
   end; {With..}
end;



Procedure TSLMList.Set_CurrencyFilt;

Var
  ThisLine  :  Integer;

Begin
  With LNHCtrl do
  Begin
    If (NHCr=0) then
    {$IFDEF SOP}
      Filter[1,0]:=MStkLocFilt^+CListFilt
    {$ELSE}
      Filter[1,0]:=CListFilt
    {$ENDIF}
    else
      {$IFDEF SOP}
        Filter[1,0]:=Chr(NHCr)+MStkLocFilt^+CListFilt;
      {$ELSE}
        Filter[1,0]:=Chr(NHCr)+CListFilt;
      {$ENDIF}

  end;
end;


{ === Proc to set Stock Ledger Key === }

Procedure TSLMList.SetNewLIndex;

Var
  LTKey       :  Char;
  CSMode      :  Boolean;
  ReDMode     :  Byte;
  KeyStart    :  Str255;
  ESKey,
  LKeyLen,
  LKeyPath    :  Integer;



Begin
  ReDMode:=0;
  LKeyPath:=KeyPath;
  KeyStart:=KeyRef;

  If (Debug) then
    ESKey:=IdStkK
  else
    ESKey:=IdStkLedgK;


  Begin
    If (FilterMode In [0,15]) or ((EmptyKey(CListFilt,CustKeyLen))
                                 and (Not (FilterMode In [1,2,5,6,8,9,11..13,17,46])))  then
    Begin
      If (LKeyPath<>{$IFDEF DBD} IdStkK {$ELSE}  ESKey {$ENDIF}) then
      Begin
        KeyStart:=OrigKey;
        LKeyPath:={$IFDEF DBD} IdStkK {$ELSE}  ESKey {$ENDIF};
        ReDMode:=0;
      end
      else
        ReDMode:=4;

    end
    else
    Begin
      CSMode:=EmptyKey(CListFilt,CustKeyLen);
      If (CSMode) then
        StkLIsaC:=(FilterMode In [1,4,5,8,11,46]);

      Case FilterMode of

        1..4
             :  If (StkLIsaC) then
                   LTKey:=StkLineType[SOR]
                 else
                 Begin
                   LTKey:=StkLineType[POR];
                 end;

        5..7  :  If (StkLIsaC) then
                   LTKey:=StkLineType[SDG]
                 else
                   LTKey:=StkLineType[SDT];

        8..10 :  If (StkLIsaC) then
                     LTKey:=StkLineType[SDN]
                 else
                   LTKey:=StkLineType[PDN];

        13    :  LTKey:=StkLineType[ADJ];

        17    :  LTKey:=StkLineType[WOR];

        {11,46}
        else     If (StkLIsaC) then
                   LTKey:=StkLineType[SIN]
                 else
                   LTKey:=StkLineType[PIN];
      end; {Case..}


      If (Not CSMode) then
      Begin
        KeyStart:=LTKey+Full_CuStkKey(CListFilt,OrigKey);

        LKeyPath:=IdCAnalK;
      end
      else
      Begin
        KeyStart:=LTKey+OrigKey;

        LKeyPath:=IdAnalK;
      end;

      ReDMode:=0;

      {ResetRec(ScanFileNum);

      FillChar(PageKeys,Sizeof(PageKeys),0);
      FillChar(KeyAry,Sizeof(KeyAry),0);

      ClrW(ScanW);}
    end;

    LKeyLen:=Length(KeyStart);

    Set_CurrencyFilt;

    if UseDefaultSortView then
      UseDefaultSortView := SortView.LoadDefaultSortView;

    if SortViewEnabled or UseDefaultSortView then
    begin
      SortView.HostListSearchKey := KeyStart;
      SortView.HostListIndexNo   := LKeyPath;
      SortView.NHCtrl            := LNHCtrl;
      SortView.Apply;
      SortView.Enabled := True;
      StartList(SortTempF, STFieldK, FullNomKey(SortView.ListID), '', '', 0, BOff);
    end
    else
      StartList(IdetailF,LKeypath,KeyStart,'','',LKeyLen,BOff);

  end; {With..}
end;


{ =================================================================================== }

