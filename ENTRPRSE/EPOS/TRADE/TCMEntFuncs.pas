unit TCMEntFuncs;

interface
uses
  SysU2, EPOSProc, CurrncyU, SysUtils, DLLInc, ComnU2, VarConst, ETMiscU, ETStrU;

  Function InvLTotalND(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double;
                     FullDec    :  SmallInt)  :  Double;

  Function InvLTotal(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double)  :  Double;

  Function Calc_IdQty(Q, QM : Double; UP : Boolean) : Double;

  Procedure Set_UpId(IdR    :  IDetail;
                 Var TmpId  :  IDetail);

  Function TBatchTLRecToId(TKTLRec : TBatchTLRec; TKTHRec : TBatchTHRec) : IDetail;

implementation

Function InvLTotalND(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double;
                     FullDec    :  SmallInt)  :  Double;
Var
  Rnum,
  WithDisc  :  Double;

  LineQty,
  CalcNetValue,
  DiscBasis,
  NewDiscBasis,
  LDiscValue,
  PriceEach :  Double;

  DVal1,DVal2,
  DVal3     :  Extended;

  UseDecs,
  LTDecs,
  UseQDecs  :  Byte;


Begin
  LTDecs:=2;

  With IdR do
  Begin
    If (FullDec=-1) then
    Begin
      UseDecs:=12;
      LTDecs:=12;
    end
    else
    Begin
      If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
        UseDecs:=Syss.NoNetDec
      else
        UseDecs:=Syss.NoCosDec;
    end;



    UseQDecs:=Syss.NoQtyDec;

    CalcNetValue:=0.0;  DiscBasis:=0.0;  LDiscValue:=0.0;

    If (IdDocHed In JAPSPlit) then
    Begin
      LineQty:=1.0;
      CalcNetValue:=NetValue;
      PriceEach:=NetValue;
    end
    else
      Begin
        LDiscValue:=Discount;

        LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);

        {* Ability to affect unit price factor *}

        If (Round_Up(PriceMulX,UseDecs)<>0.0) then
          CalcNetValue:=(NetValue*PriceMulX)
        else
          CalcNetValue:=NetValue;



        If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
        Begin
          If (ShowCase) then
          Begin
            PriceEach:=CalcNetValue;
            LineQty:=DivWChk(Qty,QtyPack);
            UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
          end
          else
            PriceEach:=(DivWChk(QtyMul,QtyPack)*CalcNetValue);
          {PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);}
        end
        else
          PriceEach:=CalcNetValue;
      end;

    If (IncNetValue<>0.0) and ((VATCode=VATMCode) or (DLLUpdate=99)) then  {* v5.00.003 Discount is based on original inclusive VAT value *}
      DiscBasis:=IncNetValue
    else
      DiscBasis:=PriceEach;

    // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
    //Rnum:=Calc_PAmount(Round_Up(DiscBasis,UseDecs),LDiscValue,DiscountChr);

    Rnum:=Calc_PAmountAD(Round_Up(DiscBasis,UseDecs),
                         LDiscValue, DiscountChr,
                         Discount2, Discount2Chr,
                         Discount3, Discount3Chr);

    {$IFDEF DBD}
       DVal1:=Round_Up(LineQty,UseQDecs);
       DVal2:=Round_Up(PriceEach,UseDecs);

       DVal3:=DVal2-Rnum;

       WithDisc:=Round_Up(DVal1*DVal3,LTDecs);

    {$ELSE}
      WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),LTDecs);
    {$ENDIF}

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,SetlDisc,PcntChr),LTDecs);

    If (UseDisc) then
      InvLTotalND:=WithDisc
    else
      InvLTotalND:=Round_Up(Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs),LTDecs);
  end;{With..}
end;


{ *Evalu ==================== Calculate One Line of Invoice ================= }


Function InvLTotal(IdR        :  IDetail;
                   UseDisc    :  Boolean;
                   SetlDisc   :  Double)  :  Double;

Begin
  Result:=InvLTotalND(IdR,UseDisc,SetlDisc,0);
end;


Function Calc_IdQty(Q, QM : Double; UP : Boolean) : Double;
Begin
  If (UP) then Calc_IdQty := Q * QM
  else Calc_IdQty := Q;
end; {Func..}


Procedure Set_UpId(IdR    :  IDetail;
               Var TmpId  :  IDetail);
Begin

  Blank(TmpId,Sizeof(TmpId));

  With TmpId do
  Begin

    FolioRef:=IdR.FolioRef;

    DocPRef:=IdR.DocPRef;

    IDDocHed:=IdR.IDDocHed;

    LineNo:=Succ(IdR.LineNo);

    Currency:=IdR.Currency;

    CXRate:=IdR.CXRate;

    CurrTriR:=IdR.CurrTriR;

    {$IFDEF STK}
      LineType:=StkLineType[IdDocHed];
    {$ENDIF}

    ABSLineNo:=0;

    PYr:=IdR.PYr;
    PPr:=IdR.PPr;

    Payment:=IdR.Payment;

    Reconcile:=IdR.Reconcile;

    CustCode:=IdR.CustCode;

    PDate:=IdR.PDate;

    DocLTLink:=IdR.DocLTLink;

    MLocStk:=IdR.MLocStk;
  end; {With..}

end; {Proc..}

Function TBatchTLRecToId(TKTLRec : TBatchTLRec; TKTHRec : TBatchTHRec) : IDetail;
var
  ValidCheck : Boolean;
  SMode : integer;

  //PR 27/08/03 Take doctype from line rather than header, as in some cases header may be undefined
  function GetDocHed : DocTypes;
  var
    DocCode : string;
  begin
    Result := SIN;
{    DocCode := '';

    if Trim(DocCode) = '' then
      DocCode := Copy(TKTLRec.TransRefNo, 1, 3);

    //Paul 5.60
    //Previously, an empty doctype was getting set to PRN. with the addition of apps & vals types
    //it's getting set to JPA which has bad effects on calculations. Restore to original setting.
    if Trim(DocCode) = '' then
      DocCode := 'PRN';

    Result := DocTypeFCode(DocCode);}
  end;

Begin
  FillChar(Result, SizeOf(Result), #0);
  SMode := 0;

  With Result do
  Begin
    IDDocHed:=SIN;
    DocPRef:=TKTHRec.OurRef;                { In v4.31 - Our Reference }
    PYr:=TKTHRec.ACYr;                      { Accounting Year }
    PPr:=TKTHRec.AcPr;                      { Accounting Period }

    LineNo:=TKTLRec.LineNo;
    ABSLineNo:=LineNo;

    if IDDocHed = NMT then
      Payment := DocPayType[NMT]
    else
      If TKTLRec.Payment then
        Payment:=DocPayType[SRC]
      else
        Payment:=DocPayType[SIN];

    If ((Payment=DocPayType[SRC]) or (IdDocHed In NomSplit+StkAdjSplit)) and not (IdDocHed in JAPSplit) then
      LineNo:=RecieptCode;

    NomCode:=TKTLRec.NomCode;

    {* Currency & EXRate *}
    Currency:=TKTLRec.Currency;
    CXRate[FALSE]:=TKTLRec.CoRate;
    CXRate[TRUE]:=TKTLRec.VATRate;
    SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }

    If (SMode <> 0) and ((Not bMultiCurr) or (Not (IdDocHed In RecieptSet+NomSplit+StkAdjSplit+TSTSplit))) then
    Begin
      Currency:=TKTHRec.Currency;
//      CXRate:=TKTHRec.CXRate;
//      CurrTriR:=TKTHRec.CurrTriR; { for v4.31 }
    end; {if..}


    CCDep[TRUE]:=UpperCase(TKTLRec.CC);      { Cost Centre }
    CCDep[FALSE]:=UpperCase(TKTLRec.Dep);    { Department }

    { 07.07.2000 }
    //PR: 5/9/02 - Don't allow stockcode on NOM
    //PR: 27/03/06 - Allow StockCode (PayRef) on Noms
    //PR: 30/5/06 - Don't UpperCase and pad payref
    if not (IDDocHed in [NMT]) then
      StockCode:=UpperCase((Strip('B',[#1,#32],TKTLRec.StockCode)))
    else
      StockCode := TKTLRec.StockCode;

    Qty:=TKTLRec.Qty;
    QtyMul:=TKTLRec.QtyMul;

    //PR: 25/05/02 Changed so that qtypick & qtypwoff could be set on add as well as update
//PR: 10/12/02 Bugfix - added SDN & PDN so that qtypick is saved for them, otherwise non-stock items don't get
//             invoiced
      If (IDDocHed In [SOR,POR,SDN,PDN] + StkRetSplit) then      { If SOR or POR }
      begin
        //PR: 5/9/02 changed so that can't pick lines on transaction on credit hold
        if TKTHRec.HoldFlg and 7 <> 6 then
          QtyPick:=TKTLRec.QtyPick;               { Pick Qty }

        //PR: 17/11/03 - Set QtyPick to qty for delivery notes to avoid 30505 errors
        if (IDDocHed in [PDN, SDN]) and (Qty > 0) then
          QtyPick := Qty;

        QtyPWOff:=TKTLRec.QtyPWOff;             { WriteOff Qty }
      end; {If SOR,POR...}

    If (IDDocHed In WOPSplit) then
    begin
      if TKTHRec.HoldFlg and 7 <> 6 then
        QtyPick:=TKTLRec.QtyPick;               { Pick Qty }
      QtyPWOff:=TKTLRec.QtyPWOff;             { WriteOff Qty }
    end; {If SOR,POR...}

    If (QtyMul=0) then
      QtyMul:=1;
    If (Trim(StockCode) <> '') then
    begin

//      ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));
      ValidCheck:=TRUE;

      if ValidCheck then
      begin
        ID.UsePack := Stock.CalcPack;
        ID.PrxPack := Stock.PricePack;


        ID.ShowCase := Stock.DPackQty;

      // HM 09/07/01: Mod for ADJ Pack Qty support
      // HM 10/07/01: Removed limitation to ADJ only after consultation with EL
      //              as same problem was hapening with any trans type using stock
        ShowCase := Stock.DPackQty;

      //PR 14/11/06: We need to set QtyPack even if Stock.DPackQty is false
      //PR 6/7/05 - QtyPack was always being set to buyunit which didn't work if buyunits & sellunits were different.
        if ID.IdDocHed in SalesSplit then
          ID.QtyPack := Stock.SellUnit
        else
          ID.QtyPack := Stock.BuyUnit;


        Qty := Case2Ea(ID, Stock, Qty);
        QtyPick := Case2Ea(ID, Stock, QtyPick);
        QtyPWoff := Case2Ea(ID, Stock, QtyPWoff);
        QtyDel := Case2Ea(ID, Stock, QtyDel);
        QtyWoff := Case2Ea(ID, Stock, QtyWoff);

        //PR 09/07/04 - Set SerialQty in the same way as Enterprise
      end;
    end;

    //PR: 29/04/02 Added this as heinz use it - needs special ini file switch
    if FALSE or (SMode = B_Update) or (IdDocHed in JAPSplit) then
      QtyDel := TKTLRec.QtyDel;

    NetValue:=TKTLRec.NetValue;         { Unit Value }

    If (TKTLRec.DiscountChr = '%') Then
      // Percentage Discount where 1.25% = 0.0125 therefore need to round to 4dp
//      Discount:= Round_Up(TKTLRec.Discount, TKSysRec.DiscountDec + 2)         { Unit Discount Value }
      Discount:= Round_Up(TKTLRec.Discount, 4)         { Unit Discount Value }
    Else
      // Amount Discount where £1.25 = 1.25 so round to 2dp
//      Discount:= Round_Up(TKTLRec.Discount, TKSysRec.DiscountDec);         { Unit Discount Value }
      Discount:= Round_Up(TKTLRec.Discount, 2);         { Unit Discount Value }

    //PR 9/9/02 - Add vat inclusive value
    IncNetValue := TKTLRec.IncNetValue;

    //PR: 5/9/02 - Don't allow Vat on NOM + ADJ, WOR & Payment lines 30/10/02
    //PR 06/05/03 In v551 Vat is allowed on noms
    if not (IDDocHed in [NMT, ADJ, WOR]) and
           ((not TKTLRec.Payment) or (IDDocHed = NMT)) then
    begin
      VATCode:=TKTLRec.VATCode;           { Line VAT Code }
      VAT:=TKTLRec.VAT;                   { Line VAT Amount }
    end;

    if not (IDDocHed in JAPSplit) then
      DiscountChr:=TKTLRec.DiscountChr   { Discount Type }
    else
      DiscountChr := '%';
    CostPrice:=TKTLRec.CostPrice;       { Unit Cost Price }

    If (IDDocHed In SalesSplit+PurchSplit+JAPSplit) then  { Account Code }
      CustCode:=TKTHRec.CustCode;

    {* Changed on 21.11.97 for TL Delivery Date *}
    If (Not EmptyKey(TKTLRec.LineDate,SizeOf(PDate))) and
       (Not (IDDocHed In [NMT,ADJ,SBT,PBT])) then
          PDate:=TKTLRec.LineDate
    else
      PDate:=TKTHRec.TransDate;

    Item:=TKTLRec.Item;                 { Line Item No. }
    Desc:=TKTLRec.Desc;                 { Line Description }
    LWeight:=TKTLRec.LWeight;           { Line Weight }

    //PR: 5/9/02 - Don't allow location on NOM
    if not (IDDocHed in [NMT]) then
    begin
      MLocStk:=UpperCase(TKTLRec.MLocStk);           { Multi-location code }
    end;

//    DeductMLoc:=(TKSysRec.UseMLoc);       { Deduct from Location Stock Y/N }

    // HM 13/08/01: Added FullxxxCode calls as was preventing posting from
    //              Job Daybook if Job Code is < 10 chars
    JobCode:=UpperCase(TKTLRec.JobCode);   { Line Job Code }

    AnalCode:=UpperCase(TKTLRec.AnalCode);  { Line Job Analysis Code }

    Reconcile:=TKTLRec.Reconcile;

    If (IdDocHed In TSTSplit) then      { If Tran= TSH (Time Sheet)}
    begin
      NomMode := TSTNomMode;            { TSTNomMode = 3 }
      Reconcile:=TKTLRec.TSHCCurr;      { Time Sheet Currency }

      JobCode:=(UpperCase(TKTLRec.JobCode));    { Line Job Code - importtant to use FullJobCode }
      AnalCode:=(UpperCase(TKTLRec.AnalCode));  { Line Job Analysis Code }
    end; {if..}

    If (IdDocHed In StkAdjSplit) then   { If Tran=ADJ (Stock Adjustment)}
    Begin
      PostedRun:=StkAdjRunNo;           { ADJ Run No }
      NomMode:=StkAdjNomMode;           { Nominal Mode }
    end;

    if IdDocHed in JapSplit then
      NomMode := TSTNomMode;

    If (TKTLRec.DocLTLink In [1..4]) or
       ((IDDocHed in JAPSplit) and (TKTLRec.DocLTLink In [1..18])) or
       (IDDocHed in StkRetSplit) then       { Document Link }
      DocLTLink:=TKTLRec.DocLTLink;

    if not (IDDocHed in JAPSplit) then
    begin
      LineType:=StkLinetype[IdDocHed];             { Line Type }
      SOPLink := TKTLRec.SOPLink;
    end
    else
    begin
      LineType := ' ';
      if TKTHRec.TransMode > 0 then
//        SOPLink := JAPParentFolio;  //to link jap transactions to parent terms
    end;

    KitLink:=TKTLRec.KitLink;                   { Kit Link if Stock is BOM }

    SOPLineNo:=TKTLRec.SOPLineNo;               { SOP Line No }

    { HM 22/12/98: This is needed otherwise the ADJ has no effect on stock levels }
    { will need to be intelligently set as in adjlineu based on the stock item    }

    {*** Ver 4.31 ***}
    LineUser1:=TKTLRec.LineUser1;       { Line User 1 to 4}
    LineUser2:=TKTLRec.LineUser2;
    LineUser3:=TKTLRec.LineUser3;
    LineUser4:=TKTLRec.LineUser4;

    SSDUplift:=TKTLRec.SSDUplift;       { SSD Information }
    SSDCommod:=TKTLRec.SSDCommod;
    SSDSPUnit:=TKTLRec.SSDSPUnit;
    SSDCountry:=TKTLRec.SSDCountry;
    SSDUseLine:=TKTLRec.SSDUseLine;
    If (PriceMulx=0) then
      PriceMulx:=1;                     { according to spec. }

    if IDDocHed in JAPSplit then
      PriceMulx := 0;

    VATIncFlg:=TKTLRec.VATIncFlg;       { VAT Include Flag }

    If (SMode=B_Update) then            { If UPDATE }
    begin
      ABSLineNo:=TKTLRec.ABSLineNo;     { Use Old ABS Line No }
      QtyMul := TKTLRec.QtyMul;
      AutoLineType := TKTLRec.AutoLineType;
    end; {If SMode=B_Update ..}
    {*** -------------- ***}

    //PR: 25/03/2009 Advanced Discount fields
    Discount2     := TKTLRec.tlMultiBuyDiscount;
    Discount2Chr  := TKTLRec.tlMultiBuyDiscountChr;
    Discount3     := TKTLRec.tlTransValueDiscount;
    Discount3Chr  := TKTLRec.tlTransValueDiscountChr;
    Discount3Type := TKTLRec.tlTransValueDiscountType;

  end; {With..}
end;

end.
