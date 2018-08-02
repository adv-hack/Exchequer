unit CalcPric;

interface
uses
  UseDLLU, DLLInc, etStrU, EPOSProc, StrUtil, TXRecs, VarConst;

  function WhatIsOne(TKStockRec : TBatchSKRec) : real;
  procedure CalcStockPrice(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec
  ; bResetDiscount : boolean = TRUE);
  function RecalcNonStockPrice(var TheNonStockLineRec : TTXLineRec; InputPrice, Quantity : Real
  ;VATCode : Char; VATInclusive : boolean) : TPriceRec;{.166}

implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  SysUtils, ETMiscU, MathUtil, EPOSCnst, TXHead, TKUtil;

Procedure Correct_PVAT(PVAT, PVATInc, CVAT, CVATInc  :  Char; var DefaultVATCode, DefaultIncVATCode: Char) ;

Var
  CompCode,
  Comp2Code  :  Char;

Begin

  CompCode:= 'Z';
  //SyssVAT.VATRates.VAT[Zero].Code;

  Comp2Code:= 'E';
  //SyssVAT.VATRates.VAT[Exempt].Code;

  If (CVAT In VATEECSet) then
  begin
    DefaultVATCode:=CVAT
  end
  else
    If (PVAT=CompCode) or (CVAT=CompCode) then
    begin
      DefaultVATCode:=CompCode
    end
    else
      If (PVAT=Comp2Code) or (CVAT=Comp2Code) then
      begin
        DefaultVATCode:=Comp2Code
      end
      else
      begin
        DefaultVATCode:=PVAT;
      end;
end;

function WhatIsOne(TKStockRec : TBatchSKRec) : real;
Var
  TStr  :  string;
  Cp    :  Byte;
  NV    :  SmallInt;
  Cases, UnitX :  Double;
  QtyMul : real;
//    WasNV :  Boolean;
Begin{WhatIsOne}
  TStr:='';
  NV:=1;
//    WasNV:=(CQ<0.0);

{    With Idr do
  Begin}
  if not tkstockrec.StDPackQty
  then QtyMul := tkstockrec.SellUnit
  else QtyMul := 1;

  If (QtyMul=1) and (TKStockRec.stDPackQty) then
  With TKStockRec do
  Begin
    TStr := Form_Real(1,0,TKSysRec.QuantityDP);
    Cp:=LastPos('.',TStr);

    If (TKSysRec.QuantityDP>0) then
    Begin
      Cases:=RealStr(Copy(TStr,1,Pred(CP)));
      UnitX:=ABS(RealStr(Copy(TStr,Succ(CP),Length(TStr)-Cp)));

      If (UnitX>SellUnit) and (TStr[Length(TStr)]='0') and (Cases>0.0) and (TKSysRec.QuantityDP>=2) then
        UnitX:=DivWChk(UnitX,Power(10,Pred(TKSysRec.QuantityDP)));
    end
    else
    Begin
      Cases:=RealStr(TStr);
      UnitX:=0;
    end;
{        If (WasNV) then
    Begin
      NV:=-1;
      Cases:=ABS(Cases);
    end;}
    Result:=((Cases*SellUnit)+UnitX)*NV;
  end
  else
    Result:=1;

  Result := 1 / Result;
end;{WhatIsOne}


procedure CalcStockPrice(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec; bResetDiscount : boolean = TRUE);
{calculates the price and VAT using the transaction line record}

  function WorkOutNetPriceOfOne(ATXLineRec : TTXLineRec; ATKTLRec : TBatchTLRec) : Double;
  begin{WorkOutNetPriceOfOne}
    with ATXLineRec, ATKTLRec do begin
      DiscountChr := ' ';
      Discount := 0;

      {.296}
      tlMultiBuyDiscount := 0;
      tlMultiBuyDiscountChr := ' ';
      tlTransValueDiscount := 0;
      tlTransValueDiscountChr := ' ';
      tlTransValueDiscountType := 0;

      DoDiscountLineTotal(ATXLineRec, ATKTLRec, 1, Result, FALSE, FALSE);
    end;{with}
  end;{WorkOutNetPriceOfOne}

  Function HOOK_TXLineBeforeCalcStockPrice : boolean;
  begin{HOOK_NonStockBeforeStore}
    Result := TRUE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTransactionLine, hpTXLineBeforeCalcStockPrice) then begin
        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign (FrmTXHeader.Handle, twiTransactionLine, hpTXLineBeforeCalcStockPrice
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, TheTXLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin
          if DataChanged then begin
            // Update form with changes
            TheTXLineRec := LCurrentTXLineRec;
            Result := FALSE;
//            TheTXLineRec.bVATInclusive := (TheTXLineRec.TKStockRec.VATCode = 'I');
          end;{if}
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_NonStockBeforeStore}

  function GetVATAmountForOne(VatTKTLRec : TBatchTLRec; var LTKTLRec : TBatchTLRec) : Real;{.213}
  var
    VatForOneTKTLRec : TBatchTLRec;
    iStatus : Integer;
  begin{GetVATAmountForOne}
    VatForOneTKTLRec := VatTKTLRec;
    VatForOneTKTLRec.Qty := 1;
    if VatForOneTKTLRec.VatCode = 'M' then VatForOneTKTLRec.VatCode := 'I';
    if VatForOneTKTLRec.VatCode = 'I' then begin
      VatForOneTKTLRec.NetValue := TheTXLineRec.TKTLRec.IncNetValue;
      if SetupRecord.DiscountType = 0 then begin
//        VatForOneTKTLRec.NetValue := TheTXLineRec.rPreEPOSDiscount + Ltktlrec.VAT;

        {.215}
//        VatForOneTKTLRec.NetValue := Round_Up(TheTXLineRec.rPreEPOSDiscount + Ltktlrec.VAT, 2);

        if zerofloat(TheTXLineRec.TKStockPriceRec.DiscVal) then VatForOneTKTLRec.NetValue := Round_Up(TheTXLineRec.rPreEPOSDiscount + Ltktlrec.VAT, 2)
        else VatForOneTKTLRec.NetValue := Round_Up(TheTXLineRec.rPreEPOSDiscount + Ltktlrec.VAT, TKSysRec.PriceDP);

//        if ZeroFloat(TheTXLineRec.rdiscount then VatForOneTKTLRec.NetValue := Round_Up(TheTXLineRec.rPreEPOSDiscount + Ltktlrec.VAT, 2)
//        else VatForOneTKTLRec.NetValue := Round_Up(TheTXLineRec.rPreEPOSDiscount + Ltktlrec.VAT, TKSysRec.PriceDP);

        LTKTLRec.IncNetValue := VatForOneTKTLRec.NetValue;
//        VatForOneTKTLRec.Discount := VATIncTKTLRec.Discount;
//        VatForOneTKTLRec.DiscountChr := cOrigDiscType;
      end;{if}
    end;{if}
    iStatus := Ex_CalcLineTax(@VatForOneTKTLRec, sizeof(VatForOneTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
    ShowTKError('Ex_CalcLineTax', 144, iStatus);
    VatForOneTKTLRec.NetValue := Round_Up(VatForOneTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}

    Result := VatForOneTKTLRec.VAT;

    // set netprice for vat inclusive
    if (SetupRecord.DiscountType = 0) and TheTXLineRec.bVATinclusive then
    begin

      {.303}
//      TheTXLineRec.rNetPrice := VatForOneTKTLRec.NetValue - TheTXLineRec.rMultiBuyDisc;
      TheTXLineRec.rNetPrice := VatForOneTKTLRec.NetValue - TheTXLineRec.rMultiBuyDiscAmount;

      LTKTLRec.NetValue := TheTXLineRec.rNetPrice;
      Case VatForOneTKTLRec.DiscountChr of
        DT_DISCOUNT_AMOUNT : TheTXLineRec.rNetPrice := TheTXLineRec.rNetPrice - VatForOneTKTLRec.Discount;
        DT_PERCENTAGE : begin
          TheTXLineRec.TKTLRec.NetValue := LTKTLRec.NetValue;
          TheTXLineRec.rNetPrice := TheTXLineRec.rNetPrice
          - ((TheTXLineRec.rNetPrice + VatForOneTKTLRec.VAT) * VatForOneTKTLRec.Discount);
        end;
      end;{Case}
    end;{if}
  end;{GetVATAmountForOne}

  {.310}
  procedure SetTKTLDiscountFields(var TheTKTLRec : TBatchTLRec; rDiscount : double; cDiscount : char);
  begin{SetTKTLDiscountFields}
    case cDiscount of
      DT_DISCOUNT_AMOUNT : TheTKTLRec.Discount := rDiscount;// Amount
      DT_PERCENTAGE : TheTKTLRec.Discount := rDiscount / 100; // Percentage
//      '£' : Discount := 0;// Price Override
    end;{case}
    TheTKTLRec.DiscountChr := cDiscount;
  end;{SetTKTLDiscountFields}

var
  VATCodeRec : TVATCodeDefaultType;
  iStatus : smallint;
  VATIncTKTLRec, VatTKTLRec, LTKTLRec, LLTKTLRec : TBatchTLRec;
  rIncVATRate, rPrevVAT, rTemp, rPrevQty, rSaveDiscount : double;

begin{CalcStockPrice}

  with TheTXLineRec do begin

    if not HOOK_TXLineBeforeCalcStockPrice then bResetDiscount := TRUE;

    if Trim(TKStockRec.StockCode) = '' then
      begin

        /////////////////////
        // Non-Stock Items //
        // Non-Stock Items //
        // Non-Stock Items //
        /////////////////////

        if bVATInclusive then rNetPrice := rOrigVATIncPrice;

        {Populate TX Line Record}
        fillchar(LTKTLRec, sizeOf(LTKTLRec),#0);
        LTKTLRec.TransRefNo := 'SIN'; // Ex_GetLineTotal needs to know the TX Type in order to get the correct amount of decimal places NF: 08/11/2005
        with LTKTLRec do begin
          Currency := SetupRecord.TillCurrency;

          // we don't need to work out the exact CC / Dept, as it is not used in the calculations
          CC := SetupRecord.DefCostCentre;
          Dep := SetupRecord.DefDepartment;

          StockCode := TKTLRec.StockCode;
          Qty := 1;

          QtyMul := 1;

          VATCode := TKTLRec.VATCode;

{.265}
//if VATCode = 'M' then VATCode := 'I';


          VATIncFlg := TKTLRec.VATIncFlg;

//          if bVATInclusive then
//            begin
//              VATIncFlg := TKTLRec.VATCode;
//              VATCode := 'I';
//              VATCode := TKTLRec.VATCode;
//            end
//          else VATCode := TKTLRec.VATCode;

          DiscountChr := cDiscount;
          Discount := rDiscount;
          if cDiscount = DT_PERCENTAGE then Discount := Discount / 100;

          CustCode := TheTXRec.TKTXHeader.CustCode;

          NetValue := rNetPrice;
          iStatus := Ex_CalcLineTax(@LTKTLRec, sizeof(LTKTLRec),TheTXRec.TKTXHeader.DiscSetl);

          if iStatus = 0 then
            begin
              LTKTLRec.NetValue := Round_Up(LTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}

              rPreEPOSDiscount := NetValue;

              // remove TTD / VBD, so it doesn't put this into the standard TX Line Discount field.{.296}
              LTKTLRec.tlTransValueDiscount := 0;
              LTKTLRec.tlTransValueDiscountChr := #0;
              LTKTLRec.tlTransValueDiscountType := 0;

              {Remove EPOS discount}
              if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, 1, rNetPrice, FALSE, FALSE))
              then NetValue := rNetPrice;
              rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
              , TKSysRec.PriceDP) - rNetPrice, TKSysRec.PriceDP); {store the amount that has been discounted}

              {Calculate VAT}
              Qty := TKTLRec.Qty;

              VatTKTLRec := LTKTLRec;
              VatTKTLRec.NetValue := rPreEPOSDiscount;

              // The VAT needs to be calculated, based on the Discounted amount {.296}
              VatTKTLRec.tlTransValueDiscount := rDiscount3;
              VatTKTLRec.tlTransValueDiscountChr := cDiscount3;
              VatTKTLRec.tlTransValueDiscountType := iDiscount3Type;

              iStatus := Ex_CalcLineTax(@VatTKTLRec, sizeof(VatTKTLRec),TheTXRec.TKTXHeader.DiscSetl);

              if iStatus = 0 then
                begin
                  VatTKTLRec.NetValue := Round_Up(VatTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}
                  if bVATInclusive then
                  begin
                    with VatTKTLRec do begin
                      case DiscountChr of
                        DT_DISCOUNT_AMOUNT : begin
                          rNetPrice := NetValue - Discount;
                          rPreEPOSDiscount := NetValue;
                        end;
                      end;{case}
                    end;{with}
                  end;{if}

                  {Reset discount so that Ex_CalcLineTax is calculated correctly}
                  Discount := 0;
                  DiscountChr := ' ';

                  {.296}
                  tlMultiBuyDiscount := 0;
                  tlMultiBuyDiscountChr := ' ';
                  tlTransValueDiscount := 0;
                  tlTransValueDiscountChr := ' ';
                  tlTransValueDiscountType := 0;

                  TKTLRec.VAT := VatTKTLRec.VAT;
                  rTotalLineVATAmount := SafeDiv(VatTKTLRec.VAT, TKTLRec.Qty); // reinstated, as discounts were not affecting VAT 3/10/02
                  rPrice := rTotalLineVATAmount + rNetPrice;{.155}
                  NetValue := rPreEPOSDiscount;

                  {.298}
                  if bVATInclusive then
                  begin
                    LTKTLRec.DiscountChr := cDiscount;
                    LTKTLRec.Discount := rDiscount;
                    if cDiscount = '%' then LTKTLRec.Discount := LTKTLRec.Discount / 100;

                    LTKTLRec.tlTransValueDiscount := 0;
                    LTKTLRec.tlTransValueDiscountChr := #0;
                    LTKTLRec.tlTransValueDiscountType := 0;
                    LTKTLRec.IncNetValue := rOrigVATIncPrice;
                    LTKTLRec.NetValue := rOrigVATIncPrice;
                    Ex_CalcLineTax(@LTKTLRec, sizeof(LTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
                    rIncVATDiscDiff := LTKTLRec.VAT;

                    LTKTLRec.tlTransValueDiscount := rDiscount3;
                    LTKTLRec.tlTransValueDiscountChr := cDiscount3;
                    LTKTLRec.tlTransValueDiscountType := iDiscount3Type;
                    DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rAdvDiscLineNetTotal, FALSE, FALSE);
                    Ex_CalcLineTax(@LTKTLRec, sizeof(LTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
                    TKTLRec.VAT := LTKTLRec.VAT;
                    TKTLRec.NetValue := LTKTLRec.NetValue;

                    DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rAdvDiscLineNetTotal, FALSE, FALSE);
                    rIncVATDiscDiff :=  rIncVATDiscDiff - LTKTLRec.VAT;
                  end;{if}

                  if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rLineNetTotal, TRUE))
                  then begin
                    NetValue := rNetPrice;

                    // get total discount amount
                    LTKTLRec.DiscountChr := ' ';
                    LTKTLRec.Discount := 0;

                    {.296}
//                    LTKTLRec.tlMultiBuyDiscount := 0;
//                    LTKTLRec.tlMultiBuyDiscountChr := ' ';
                    LTKTLRec.tlTransValueDiscount := 0;
                    LTKTLRec.tlTransValueDiscountChr := ' ';
                    LTKTLRec.tlTransValueDiscountType := 0;

                    LTKTLRec.NetValue := rPreEPOSDiscount;
                    rSaveDiscount := rDiscount;{.226}
                    rDiscount := 0;{.226}
                    if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rNonDiscLineNetTotal, TRUE, FALSE))
                    then rTotalDiscAmount := rNonDiscLineNetTotal - rLineNetTotal;
                    rDiscount := rSaveDiscount;{.226}
                  end;{if}

                  {.301}
                  if not bVATInclusive then
                  begin
                    rAdvDiscLineNetTotal := rLineNetTotal;
                  end;{if}

                  {.298}
                  if bVATInclusive then rLineTotal := rLineNetTotal + TKTLRec.VAT
                  else rLineTotal := rLineNetTotal + TKTLRec.VAT;
                  rOrigNetAmount := rLineNetTotal;
                  rTotalLineVATAmount := TKTLRec.VAT;
                  rTotalNetNoDiscounts := rNonDiscLineNetTotal;
                end
              else ShowTKError('Ex_CalcLineTax', 144, iStatus);
            end
          else ShowTKError('Ex_CalcLineTax', 144, iStatus);
        end;{with}
      end
    else begin

      /////////////////
      // Stock Items //
      // Stock Items //
      // Stock Items //
      /////////////////

      with TKStockRec do begin
        Case SetupRecord.DiscountType of

          0 : begin // Get Stock Pricing for TCM Additional Discounts

            //////////////////////////////
            // TCM Additional Discounts //
            // TCM Additional Discounts //
            // TCM Additional Discounts //
            //////////////////////////////

            FillChar(TKStockPriceRec, SizeOf(TKStockPriceRec),#0);

            {.277} // NF: Added to support prices in a date range
            TKStockPriceRec.PriceDate := DateToStr8(Date);

            with TKStockPriceRec do begin
              (* ORDER OF PLAY
              Ex_CalcStockPrice         - To get Standard Stock Price
              Ex_GetCorrectVATCode      - To work out which vat code to use (cust / stock)
              Ex_CalcLineTax            - To remove VAT from inclusive VAT items
              Ex_GetLineTotal           - For enterprise discount
              Ex_GetLineTotal           - For EPOS discount
              Ex_CalcLineTax            - To get VAT amount *)

              {gets the standard stock price}
              StockCode := TKTLRec.StockCode;
              CustCode := TheTXRec.TKTXHeader.CustCode;
              if TKSysRec.MultiLocn > 0 then LocCode := SetupRecord.DefStockLocation;
              Currency := SetupRecord.TillCurrency;
              Qty := TKTLRec.Qty;


              iStatus := Ex_CalcStockPrice(@TKStockPriceRec, SizeOf(TKStockPriceRec));
              if iStatus = 0 then
                begin

                  // NF: 21/04/2008 {.287}
                  // For override price discounts, just put the new price, in place of the Exchequer Price
                  if (cDiscount = DT_OVERRIDE_PRICE) {and (not ZeroFloat(rDiscount)) and bVATInclusive} then
                  begin
                    TKStockPriceRec.Price := rDiscount;
                  end;{if}

//                  cOrigDiscType := TKStockPriceRec.DiscChar;
                  rNetPrice := Price;

                  {Decides which VAT code to use - stock or cust}
                  VATCodeRec.StockVATCode := VATCode;
                  VATCodeRec.AccountVATCode := TheTXRec.LCust.VATCode;
                  iStatus := Ex_GetCorrectVATCode(@VATCodeRec, SizeOf(VATCodeRec));
                  if iStatus = 0 then
                    begin
                      TKTLRec.VATCode := VATCodeRec.DefaultVATCode;

                      {Populate TX Line Record}
                      fillchar(LTKTLRec, sizeOf(LTKTLRec),#0);
                      LTKTLRec.TransRefNo := 'SIN'; // Ex_GetLineTotal needs to know the TX Type in order to get the correct amount of decimal places NF: 08/11/2005
                      with LTKTLRec do begin
                        Currency := SetupRecord.TillCurrency;

                        // we don't need to work out the exact CC / Dept, as it is not used in the calculations
                        CC := SetupRecord.DefCostCentre;
                        Dep := SetupRecord.DefDepartment;

                        StockCode := TKTLRec.StockCode;
                        Qty := WhatIsOne(TKStockRec);

                        if TKStockRec.PriceByStkUnit then Qty := Qty / TKStockRec.SellUnit; {.195}

                        {.240}
                        // QtyMul := 1;
                        // Changed so that split packs calculate correctly
                        if not tkstockrec.StDPackQty
                        then QtyMul := tkstockrec.SellUnit
                        else QtyMul := 1;

                        VATCode := TKTLRec.VATCode;
                        if DiscChar = DT_DISCOUNT_AMOUNT then Discount := DiscVal
                        else Discount := DiscVal / 100;
                        DiscountChr := DiscChar;

                        // NF: 21/04/2008 {.287}
                        // If we are overriding the price, then do not apply any exchequer discounts
                        if (cDiscount = DT_OVERRIDE_PRICE) then
                        begin
                          Discount := 0;
                          discountchr := DT_DISCOUNT_AMOUNT;
                        end;


                        {.296}
                        tlMultiBuyDiscount := 0;
                        tlMultiBuyDiscountChr := cMultiBuyDisc;
                        tlTransValueDiscount := rDiscount3;
                        tlTransValueDiscountChr := cDiscount3;
                        tlTransValueDiscountType := iDiscount3Type;

                        CustCode := TheTXRec.TKTXHeader.CustCode;
                        VATIncFlg := SVATIncFlg;
                        NetValue := rNetPrice;

                        {.299}
                        //if bVATInclusive then VATIncTKTLRec := LTKTLRec;
                        if bVATInclusive then
                        begin
                          IncNetValue := TKTLRec.IncNetValue;
                          VATIncTKTLRec := LTKTLRec;
                          LTKTLRec.VatCode := 'M';
                        end;

                        iStatus := Ex_CalcLineTax(@LTKTLRec, sizeof(LTKTLRec),TheTXRec.TKTXHeader.DiscSetl);

                        if iStatus = 0 then
                          begin
                            LTKTLRec.NetValue := Round_Up(LTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}
                            if bVATInclusive then
                            begin
                              TKTLRec.IncNetValue := LTKTLRec.IncNetValue;

                              {.298}
                              // Get orig net value, without discounts
                              LLTKTLRec := LTKTLRec;
                              LLTKTLRec.tlTransValueDiscount := 0;
                              LLTKTLRec.tlTransValueDiscountChr := #0;
                              LLTKTLRec.tlTransValueDiscountType := 0;
                              iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
                              rIncNetPrice := LLTKTLRec.netvalue;
                            end else
                            begin
                              rNetPrice := NetValue;
                            end;

                            {Remove Exchequer discounts}
//                            iStatus := Ex_RemoveDiscounts(@LTKTLRec, sizeof(LTKTLRec), TRUE, 0.0, rNetPrice);

                            // Must remove Advanced discounts, or this will affect the net price {.296}
                            tlMultiBuyDiscount := 0;
                            tlMultiBuyDiscountChr := #0;
                            tlTransValueDiscount := 0;
                            tlTransValueDiscountChr := #0;
                            tlTransValueDiscountType := 0;

                            // NF: 23/03/2011 - v6.70.315
                            // fixes for https://jira.iris.co.uk/browse/ABSEXCH-10596
                            // & https://jira.iris.co.uk/browse/ABSEXCH-11106
                            if bVATInclusive then
                            begin
                              // https://jira.iris.co.uk/browse/ABSEXCH-10596
                              // & https://jira.iris.co.uk/browse/ABSEXCH-11106
                              rIncVATRate := 1 + GetVatRateFromCode(TheTXLineRec.TKStockRec.SVATIncFlg);

                              if (cDiscount = DT_OVERRIDE_PRICE) then
                              begin
                                // https://jira.iris.co.uk/browse/ABSEXCH-11106
                                TheTXLineRec.TKTLRec.IncNetValue := TheTXLineRec.rDiscount;
                                LTKTLRec.IncNetValue := TheTXLineRec.TKTLRec.IncNetValue;
                              end
                              else
                              begin
                                // https://jira.iris.co.uk/browse/ABSEXCH-10596
                                LTKTLRec.IncNetValue := TheTXLineRec.rNetPrice;
                              end;{if}

                              // https://jira.iris.co.uk/browse/ABSEXCH-10596
                              LTKTLRec.NetValue := LTKTLRec.IncNetValue / rIncVATRate;
                              LTKTLRec.VAT := LTKTLRec.IncNetValue - LTKTLRec.NetValue;
                            end;{if}

                            {Remove Exchequer discounts} {.279}
                            rPrevQty := LTKTLRec.Qty; // Save so we can restore it after Ex_RemoveDiscounts
                            LTKTLRec.Qty := LTKTLRec.Qty * tkstockrec.SellUnit; // we need to pass 1 in, as Ex_RemoveDiscounts works out "WhatIsOne" Itself
                            iStatus := Ex_RemoveDiscounts(@LTKTLRec, sizeof(LTKTLRec), TRUE, 0.0, rNetPrice);
                            LTKTLRec.Qty := rPrevQty; // Restore original "WhatIsOne" value

                            if iStatus = 0 then
                              begin
                                NetValue := rNetPrice;

                                {Store the Pre-EPOS Discount Price}
                                rPreEPOSDiscount := rNetPrice;

                                {Remove EPOS discount}

                                // remove TTD / VBD, so it doesn't put this into the standard TX Line Discount field.{.296}
                                LTKTLRec.tlTransValueDiscount := 0;
                                LTKTLRec.tlTransValueDiscountChr := #0;
                                LTKTLRec.tlTransValueDiscountType := 0;

                                // Need to work out the EPOS Discounted price and VAT used in the defined EPOS Discount {.296}
                                // I have no idea why the discount was not already set here - ?
                                if (cDiscount <> DT_OVERRIDE_PRICE) then
                                begin
                                  Discount := rDiscount;
                                  DiscountChr := cDiscount;
                                  if cDiscount = DT_PERCENTAGE then Discount := Discount/100;
                                end;{if}

                                {.213}
//                                if DoDiscountLineTotal(TheTXLineRec, LTKTLRec, 1, rNetPrice, FALSE) = 0
//                                then NetValue := rNetPrice;

                                {.298}
                                // if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, 1, rNetPrice, FALSE, FALSE))
                                if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, 1, rNetPrice, TRUE, FALSE))
                                then begin
                                  NetValue := rNetPrice;

                                  {.303}
//                                  rNetPrice := rNetPrice - rMultiBuyDisc;{.298}
                                  rNetPrice := rNetPrice - rMultiBuyDiscAmount;{.303}

                                  if (TheTXLineRec.cDiscount = DT_OVERRIDE_PRICE) then TKTLRec.Discount := LTKTLRec.Discount;
                                end;{if}

                                rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
                                , TKSysRec.PriceDP) - rNetPrice, TKSysRec.PriceDP); {store the amount that has been discounted}

                                ///////////////////
                                // Calculate VAT //
                                ///////////////////
                                Qty := TKTLRec.Qty;

                                VatTKTLRec := LTKTLRec;

                                // Add TTD / VBD, so it works out the VAT including the Discount.{.296}
                                VatTKTLRec.tlTransValueDiscount := rDiscount3;
                                VatTKTLRec.tlTransValueDiscountChr := cDiscount3;
                                VatTKTLRec.tlTransValueDiscountType := iDiscount3Type;

                                {.297}
                                VatTKTLRec.tlMultiBuyDiscount := rMultiBuyDisc;
                                VatTKTLRec.tlMultiBuyDiscountChr := cMultiBuyDisc;

                                VatTKTLRec.NetValue := rPreEPOSDiscount;

                                {.155}
                                If bVATInclusive then begin
                                  with VatTKTLRec do begin
                                    case DiscountChr of
                                      DT_DISCOUNT_AMOUNT : begin
                                        rNetPrice := NetValue - Discount;
                                        rPreEPOSDiscount := NetValue;
                                      end;
                                    end;{case}
                                  end;{with}
                                end;{if}

                                {Reset discount so that Ex_CalcLineTax is calculated correctly}
//                                Discount := 0; {.194}
//                                DiscountChr := ' '; {.194}
                                rTotalLineVATAmount := VatTKTLRec.VAT;

                                {get tax for 1} {.213}
                                rVATAmountForOne := GetVATAmountForOne(VatTKTLRec, LTKTLRec);
                                rPrice := rVATAmountForOne + rNetPrice;
                                if bVATInclusive then
                                begin
                                  {.298}
//                                  TKTLRec.IncNetValue := LTKTLRec.IncNetValue;
                                  TKTLRec.IncNetValue := LTKTLRec.IncNetValue;
                                  LTKTLRec.netvalue := TheTXLineRec.TKTLRec.NetValue;
                                  // init temp local TK TL Record
                                  LLTKTLRec := LTKTLRec;
                                  LLTKTLRec.NetValue := rIncNetPrice;

                                  // No Discount
                                  {.310}
                                  SetTKTLDiscountFields(LLTKTLRec, 0, #0);
//                                  LLTKTLRec.Discount := 0;
//                                  LLTKTLRec.DiscountChr := #0;
                                  LLTKTLRec.tlMultiBuyDiscount := 0;
                                  LLTKTLRec.tlMultiBuyDiscountChr := #0;
                                  LLTKTLRec.tlTransValueDiscount := 0;
                                  LLTKTLRec.tlTransValueDiscountChr := #0;
                                  LLTKTLRec.tlTransValueDiscountType := 0;
                                  iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                                  DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                                  , rTotalNetNoDiscounts, TRUE, FALSE);
                                  rPrevVAT := LLTKTLRec.VAT;

                                  // Add Standard Discount
                                  {.310}
                                  SetTKTLDiscountFields(LLTKTLRec, rDiscount, cDiscount);
//                                  LLTKTLRec.Discount := rDiscount;
//                                  LLTKTLRec.DiscountChr := cDiscount;
//                                  if cDiscount = '%' then LLTKTLRec.Discount := LLTKTLRec.Discount / 100;
                                  iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                                  DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                                  , rTemp, TRUE, FALSE);
                                  rTotalStandardDiscountAmount := rTotalNetNoDiscounts - rTemp
                                  + (rPrevVAT - LLTKTLRec.VAT);

                                  // Add MBD
                                  LLTKTLRec.tlMultiBuyDiscount := rMultiBuyDisc;
                                  LLTKTLRec.tlMultiBuyDiscountChr := cMultiBuyDisc;
                                  iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                                  DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                                  , rOrigNetAmount, TRUE, FALSE);
                                  rTotalMBDAmount := rTotalNetNoDiscounts - rOrigNetAmount - rTotalStandardDiscountAmount;

                                  // Add TTD/VBD
                                  LLTKTLRec.tlTransValueDiscount := rDiscount3;
                                  LLTKTLRec.tlTransValueDiscountChr := cDiscount3;
                                  LLTKTLRec.tlTransValueDiscountType := iDiscount3Type;
                                  iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                                  rTotalLineVATAmount := LLTKTLRec.VAT;
                                  rIncVATDiscDiff := rPrevVAT - rTotalLineVATAmount;
                                  rTotalMBDAmount := rTotalMBDAmount + rIncVATDiscDiff;
                                  DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                                  , rTemp, TRUE, FALSE);
                                  rTotalTransDiscountAmount := rOrigNetAmount - rTemp;

                                  // Get alt net total
                                  LTKTLRec.tlMultiBuyDiscount := rMultiBuyDisc;
                                  LTKTLRec.tlMultiBuyDiscountChr := cMultiBuyDisc;
                                  LTKTLRec.tlTransValueDiscount := rDiscount3;
                                  LTKTLRec.tlTransValueDiscountChr := cDiscount3;
                                  LTKTLRec.tlTransValueDiscountType := iDiscount3Type;
                                  DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty
                                  , rAdvDiscLineNetTotal, FALSE, FALSE);
                                  LTKTLRec.tlMultiBuyDiscount := 0;
                                  LTKTLRec.tlMultiBuyDiscountChr := #0;

                                  rLineNetTotal := rOrigNetAmount - rTotalTransDiscountAmount;
                                end else
                                begin
                                  NetValue := rPreEPOSDiscount;
                                  {.298}
                                  ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty
                                  , rLineNetTotal, not bVATInclusive, not bVATInclusive));
                                end;{if]
//                                if bVATInclusive then TKTLRec.IncNetValue := rPrice
//                                else NetValue := rPreEPOSDiscount;
//                                rPrice := rTotalLineVATAmount + rNetPrice;{.155}

                                  {.298}
                                  //if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty
                                  //, rLineNetTotal, not bVATInclusive, not bVATInclusive)) then
//                                NetValue := rNetPrice; {.194}

                                {.298}
                                if not bVATInclusive then
                                begin
                                  rAdvDiscLineNetTotal := rLineNetTotal;
                                end;{if}

                                // get total discount amount
                                LTKTLRec.DiscountChr := ' ';
                                LTKTLRec.Discount := 0;

                                {.296}
                                LTKTLRec.tlMultiBuyDiscount := 0;
                                LTKTLRec.tlMultiBuyDiscountChr := ' ';
                                LTKTLRec.tlTransValueDiscount := 0;
                                LTKTLRec.tlTransValueDiscountChr := ' ';
                                LTKTLRec.tlTransValueDiscountType := 0;

                                if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rNonDiscLineNetTotal, TRUE, FALSE))
                                then rTotalDiscAmount := rNonDiscLineNetTotal - rLineNetTotal;

                                if bVATInclusive then begin {.194}
                                  VATIncTKTLRec.Qty := TKTLRec.Qty; {.194}
                                  VatTKTLRec := VATIncTKTLRec;{.194}

                                  {.215}
//                                  VatTKTLRec.NetValue := rPreEPOSDiscount + LTKTLRec.VAT;

//                                  VatTKTLRec.NetValue := Round_Up(rPreEPOSDiscount + Ltktlrec.VAT, 2);

//                                  VatTKTLRec.NetValue := Round_Up(rPreEPOSDiscount + Ltktlrec.VAT, TKSysRec.PriceDP);

                                  if zerofloat(TheTXLineRec.TKStockPriceRec.DiscVal)
                                  then VatTKTLRec.NetValue := Round_Up(rPreEPOSDiscount + Ltktlrec.VAT, 2)
                                  else VatTKTLRec.NetValue := Round_Up(rPreEPOSDiscount + Ltktlrec.VAT, TKSysRec.PriceDP);

                                  case cDiscount of
                                    DT_PERCENTAGE : VatTKTLRec.Discount := thetxlinerec.rdiscount / 100;
                                    DT_DISCOUNT_AMOUNT : VatTKTLRec.Discount := thetxlinerec.rdiscount;
                                  end;{case}

                                  VatTKTLRec.DiscountChr := cDiscount;

                                  {.298}
                                  // Add TTD / VBD / MBD, so it works out the VAT including the Discount.{.298}
                                  VatTKTLRec.tlTransValueDiscount := rDiscount3;
                                  VatTKTLRec.tlTransValueDiscountChr := cDiscount3;
                                  VatTKTLRec.tlTransValueDiscountType := iDiscount3Type;
                                  VatTKTLRec.tlMultiBuyDiscount := rMultiBuyDisc;
                                  VatTKTLRec.tlMultiBuyDiscountChr := cMultiBuyDisc;
//                                  VatTKTLRec.NetValue := rPrice;
//                                  VatTKTLRec.Discount := 0;
//                                  VatTKTLRec.DiscountChr := #0;
                                end; {.194}

                                iStatus := Ex_CalcLineTax(@VatTKTLRec, sizeof(VatTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
                                if (iStatus = 0) then
                                  begin
                                    VatTKTLRec.NetValue := Round_Up(VatTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}
                                    TKTLRec.VAT := VatTKTLRec.VAT;

                                    rLineTotal := rLineNetTotal + TKTLRec.VAT;
//rLineNetTotalAfterDisc := Round_Up(rLineOrigNetTotal - rLineTransDiscount - rLineValueDiscount, 2);
//rLineNetTotalAfterDisc := Round_Up(rLineNetTotal - rLineTransDiscount - rLineValueDiscount, 2);
//if bVatInclusive then rLineTotal := rLineNetTotalAfterDisc + TKTLRec.VAT
//else rLineTotal := rLineNetTotal + TKTLRec.VAT;

                                  end
                                else ShowTKError('Ex_CalcLineTax', 144, iStatus);
                              end
                            else ShowTKError('Ex_RemoveDiscounts', 152, iStatus);
                          end
                        else ShowTKError('Ex_CalcLineTax', 144, iStatus);
                      end;{with}
                    end
                  else ShowTKError('Ex_GetCorrectVATCode', 145, iStatus);
                end
              else ShowTKError('Ex_CalcStockPrice', 80, iStatus);
            end;{with}
          end;


          1 : begin // Get Stock Pricing when Using and Modifying Enterprise Discounts

            //////////////////////////////////////
            // Use & Modify Exchequer Discounts //
            // Use & Modify Exchequer Discounts //
            // Use & Modify Exchequer Discounts //
            //////////////////////////////////////

            FillChar(TKStockPriceRec, SizeOf(TKStockPriceRec),#0);

            {.277} // NF: Added to support prices in a date range
            TKStockPriceRec.PriceDate := DateToStr8(Date);

            with TKStockPriceRec do begin
              (* ORDER OF PLAY
              Ex_CalcStockPrice         - To get Standard Stock Price
              Ex_GetCorrectVATCode      - To work out which vat code to use (cust / stock)
              Ex_CalcLineTax            - To remove VAT from inclusive VAT items
              Ex_GetLineTotal           - For enterprise discount
              Ex_GetLineTotal           - For EPOS discount
              Ex_CalcLineTax            - To get VAT amount *)

              {gets the standard stock price}
              StockCode := TKTLRec.StockCode;
              CustCode := TheTXRec.TKTXHeader.CustCode;
              if TKSysRec.MultiLocn > 0 then LocCode := SetupRecord.DefStockLocation;
              Currency := SetupRecord.TillCurrency;
              Qty := TKTLRec.Qty;

              iStatus := Ex_CalcStockPrice(@TKStockPriceRec, SizeOf(TKStockPriceRec));
              if iStatus = 0 then
                begin

                  // NF: 21/04/2008 {.287}
                  // For override price discounts, just put the new price, in place of the Exchequer Price
                  if (cDiscount = DT_OVERRIDE_PRICE) {and (not ZeroFloat(rDiscount)) and bVATInclusive} then
                  begin
                    TKStockPriceRec.Price := rDiscount;
                  end;{if}

                  if bResetDiscount then
                  begin
                    cDiscount := DiscChar;
                    rDiscount := DiscVal;

                    {.296}
//                    rMultiBuyDisc := MultiBuyDiscValue;
//                    cMultiBuyDisc := MultiBuyDiscChar;
                    {.304}
//                    rMultiBuyDisc := MultiBuyDiscValue;
//                    cMultiBuyDisc := MultiBuyDiscChar;
                    {.305}
//                    rMultiBuyDisc := MultiBuyDiscValue;
//                    cMultiBuyDisc := MultiBuyDiscChar;

                    {.303}
//                    if cMultiBuyDisc = '%' then rMultiBuyDiscAmount := (Price * rMultiBuyDisc)
//                    else rMultiBuyDiscAmount := rMultiBuyDisc;
                    {.304}
//                    if cMultiBuyDisc = '%' then rMultiBuyDiscAmount := (Price * rMultiBuyDisc)
//                    else rMultiBuyDiscAmount := rMultiBuyDisc;
                    {.305}
//                    if cMultiBuyDisc = '%' then rMultiBuyDiscAmount := (Price * rMultiBuyDisc)
//                    else rMultiBuyDiscAmount := rMultiBuyDisc;
                  end;{if}

//                  If bVATInclusive and (cDiscount = '£') then Price := rDiscount;

                  rNetPrice := Price;

                  {Decides which VAT code to use - stock or cust}
                  VATCodeRec.StockVATCode := VATCode;
                  VATCodeRec.AccountVATCode := TheTXRec.LCust.VATCode;
                  iStatus := Ex_GetCorrectVATCode(@VATCodeRec, SizeOf(VATCodeRec));
                  if iStatus = 0 then
                    begin
                      TKTLRec.VATCode := VATCodeRec.DefaultVATCode;

                      {Populate TX Line Record}
                      fillchar(LTKTLRec, sizeOf(LTKTLRec),#0);
                      LTKTLRec.TransRefNo := 'SIN'; // Ex_GetLineTotal needs to know the TX Type in order to get the correct amount of decimal places NF: 08/11/2005
                      with LTKTLRec do begin
                        Currency := SetupRecord.TillCurrency;

                        // we don't need to work out the exact CC / Dept, as it is not used in the calculations
                        CC := SetupRecord.DefCostCentre;
                        Dep := SetupRecord.DefDepartment;

                        StockCode := TKTLRec.StockCode;
                        Qty := 1;
                        if TKStockRec.PriceByStkUnit then Qty := Qty / TKStockRec.SellUnit; {.195}

                        {.240}
                        // QtyMul := 1;
                        // Changed so that split packs calculate correctly
                        if not tkstockrec.StDPackQty
                        then QtyMul := tkstockrec.SellUnit
                        else QtyMul := 1;

                        VATCode := TKTLRec.VATCode;

                        {.213}
                        case cDiscount of
                          DT_DISCOUNT_AMOUNT : Discount := rDiscount;// Amount
                          DT_PERCENTAGE : Discount := rDiscount / 100; // Percentage
//                          '£' : Discount := 0;// Price Override
                        end;{case}
                        DiscountChr := cDiscount;

                        {.296}
                        tlMultiBuyDiscount := rMultiBuyDisc;
                        tlMultiBuyDiscountChr := cMultiBuyDisc;
                        tlTransValueDiscount := rDiscount3;
                        tlTransValueDiscountChr := cDiscount3;
                        tlTransValueDiscountType := iDiscount3Type;

                        CustCode := TheTXRec.TKTXHeader.CustCode;
                        VATIncFlg := SVATIncFlg;

                        NetValue := rNetPrice;
                        iStatus := Ex_CalcLineTax(@LTKTLRec, sizeof(LTKTLRec), TheTXRec.TKTXHeader.DiscSetl);

                        if iStatus = 0 then
                          begin
                            LTKTLRec.NetValue := Round_Up(LTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}
                            {.213}
                            if bVATInclusive then begin
                              TKTLRec.IncNetValue := LTKTLRec.IncNetValue;
                              VatTKTLRec := LTKTLRec;
                              Ex_CalcLineTax(@VatTKTLRec, sizeof(VatTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
                              VatTKTLRec.NetValue := Round_Up(VatTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}
                            end;{if}
//                            if bVATInclusive then TKTLRec.IncNetValue := LTKTLRec.IncNetValue;

                            rNetPrice := NetValue;

                            {Implement enterprise discounts}
                            if bResetDiscount then begin

                              rDiscAmount := 0;
{                              if ZeroFloat(rDiscount) then sDiscount := '-'
                              else begin
                                case cDiscount of
                                  DT_PERCENTAGE : sDiscount := MoneyToStr(rDiscount) + ' %';
                                  DT_DISCOUNT_AMOUNT, ' ' : sDiscount := sCurrencySym + ' ' + MoneyToStr(rDiscount);
                                  DT_OVERRIDE_PRICE : sDiscount := 'override';
                                  else sDiscount := '-';
                                end;{case}
//                              end;{if}
                              SetDiscountStr(TheTXLineRec);

                            end;{if}

//                            rPreEPOSDiscount := rNetPrice;{.196}
                            rPreEPOSDiscount := WorkOutNetPriceOfOne(TheTXLineRec, LTKTLRec); {.196}

                            // remove TTD / VBD, so it doesn't put this into the standard TX Line Discount field.{.296}
                            LTKTLRec.tlTransValueDiscount := 0;
                            LTKTLRec.tlTransValueDiscountChr := #0;
                            LTKTLRec.tlTransValueDiscountType := 0;

                            {.298}
                            //if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, 1, rNetPrice, FALSE, FALSE))
                            if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, 1, rNetPrice, TRUE, FALSE)) then
                            begin
                              NetValue := rNetPrice;
                              //rNetPrice := rNetPrice - rMultiBuyDisc;{.298}
                            end;

                            {.298}
                            // rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
                            // , TKSysRec.PriceDP) - rNetPrice, TKSysRec.PriceDP); {store the amount that has been discounted}

                            {.302}
//                            rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
//                            , TKSysRec.PriceDP) - rNetPrice - rMultiBuyDisc, TKSysRec.PriceDP); {store the amount that has been discounted}
{                            rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
                            , TKSysRec.PriceDP) - rNetPrice, TKSysRec.PriceDP) - rMultiBuyDisc; {store the amount that has been discounted}
//                            if (rDiscAmount < 0.01) and (not ZeroFloat(0.01 - rDiscAmount)) then rDiscAmount := 0;}

                            {.303}
                            rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
                            , TKSysRec.PriceDP) - rNetPrice, TKSysRec.PriceDP) - rMultiBuyDiscAmount; {store the amount that has been discounted}
                            if (rDiscAmount < 0.01) and (not ZeroFloat(0.01 - rDiscAmount)) then rDiscAmount := 0;

                            {Calculate VAT}
                            Qty := TKTLRec.Qty;
                            VatTKTLRec := LTKTLRec;

                            // Add TTD / VBD, so it works out the VAT including the Discount.{.296}
                            VatTKTLRec.tlTransValueDiscount := rDiscount3;
                            VatTKTLRec.tlTransValueDiscountChr := cDiscount3;
                            VatTKTLRec.tlTransValueDiscountType := iDiscount3Type;
//                            VatTKTLRec.NetValue := rPreEPOSDiscount; {.197}

                            {.155}
                            If bVATInclusive then
                              begin
                                VatTKTLRec.NetValue := rPreEPOSDiscount; {.197}
                                with VatTKTLRec do begin
                                  case DiscountChr of
                                    DT_DISCOUNT_AMOUNT : begin
                                      rNetPrice := NetValue - Discount;
                                      rPreEPOSDiscount := NetValue;
                                    end;
                                  end;{case}
                                end;{with}
                              end
                            else VatTKTLRec.NetValue := TKStockPriceRec.Price;{.197}

                            {Reset discount so that Ex_CalcLineTax is calculated correctly}
                            Discount := 0;
                            DiscountChr := ' ';

                            {.296}
                            tlMultiBuyDiscount := 0;
                            tlMultiBuyDiscountChr := ' ';
                            tlTransValueDiscount := 0;
                            tlTransValueDiscountChr := ' ';
                            tlTransValueDiscountType := 0;

                            rTotalLineVATAmount := VatTKTLRec.VAT;

                            {get tax for 1} {.213}
                            rVATAmountForOne := GetVATAmountForOne(VatTKTLRec, LTKTLRec);
                            rPrice := rVATAmountForOne + rNetPrice;
//                                rPrice := rTotalLineVATAmount + rNetPrice;{.155}{.213}

                            {.197}
                            If bVATInclusive then
                            begin
//                              NetValue := rPreEPOSDiscount;

                              {.298}
                              NetValue := rPreEPOSDiscount;
                              TKTLRec.IncNetValue := LTKTLRec.IncNetValue;
                              // init temp local TK TL Record
                              LLTKTLRec := LTKTLRec;

                              // NF: 18/05/2011 - v6.70.316
                              // https://jira.iris.co.uk/browse/ABSEXCH-11345
                              // Removed line below, since in this discount mode rIncNetPrice is never set
                              //, so will be zero, or some random number....
                              //LLTKTLRec.NetValue := rIncNetPrice;

                              // No Discount
                              {.310}
                              SetTKTLDiscountFields(LLTKTLRec, 0, #0);
//                              LLTKTLRec.Discount := 0;
//                              LLTKTLRec.DiscountChr := #0;
                              LLTKTLRec.tlMultiBuyDiscount := 0;
                              LLTKTLRec.tlMultiBuyDiscountChr := #0;
                              LLTKTLRec.tlTransValueDiscount := 0;
                              LLTKTLRec.tlTransValueDiscountChr := #0;
                              LLTKTLRec.tlTransValueDiscountType := 0;
                              iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                              DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                              , rTotalNetNoDiscounts, TRUE, FALSE);
                              rPrevVAT := LLTKTLRec.VAT;

                              // Add Standard Discount
                              {.310}
                              SetTKTLDiscountFields(LLTKTLRec, rDiscount, cDiscount);
//                              LLTKTLRec.Discount := rDiscount;
//                              LLTKTLRec.DiscountChr := cDiscount;
//                              if cDiscount = '%' then LLTKTLRec.Discount := LLTKTLRec.Discount / 100;
                              iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                              DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                              , rTemp, TRUE, FALSE);
                              rTotalStandardDiscountAmount := rTotalNetNoDiscounts - rTemp
                              + (rPrevVAT - LLTKTLRec.VAT);

                              // Add MBD
                              LLTKTLRec.tlMultiBuyDiscount := rMultiBuyDisc;
                              LLTKTLRec.tlMultiBuyDiscountChr := cMultiBuyDisc;
                              iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                              DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                              , rOrigNetAmount, TRUE, FALSE);

                              rTotalMBDAmount := rTotalNetNoDiscounts - rOrigNetAmount - rTotalStandardDiscountAmount;

                              // Add TTD/VBD
                              LLTKTLRec.tlTransValueDiscount := rDiscount3;
                              LLTKTLRec.tlTransValueDiscountChr := cDiscount3;
                              LLTKTLRec.tlTransValueDiscountType := iDiscount3Type;
                              iStatus := Ex_CalcLineTax(@LLTKTLRec, sizeof(LLTKTLRec),TheTXRec.TKTXHeader.DiscSetl); // recalcs netvalue
                              rTotalLineVATAmount := LLTKTLRec.VAT;
                              rIncVATDiscDiff := rPrevVAT - rTotalLineVATAmount;
                              rTotalMBDAmount := rTotalMBDAmount + rIncVATDiscDiff;
                              DoDiscountLineTotal(TheTXLineRec, LLTKTLRec, TKTLRec.Qty
                              , rTemp, TRUE, FALSE);
                              rTotalTransDiscountAmount := rOrigNetAmount - rTemp;

                              // Get alt net total
                              LTKTLRec.Discount := rDiscount;
                              LTKTLRec.DiscountChr := cDiscount;
                              if cDiscount = '%' then LTKTLRec.Discount := LTKTLRec.Discount / 100;
                              LTKTLRec.tlMultiBuyDiscount := rMultiBuyDisc;
                              LTKTLRec.tlMultiBuyDiscountChr := cMultiBuyDisc;
                              LTKTLRec.tlTransValueDiscount := rDiscount3;
                              LTKTLRec.tlTransValueDiscountChr := cDiscount3;
                              LTKTLRec.tlTransValueDiscountType := iDiscount3Type;
                              DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty
                              , rAdvDiscLineNetTotal, FALSE, FALSE);
                              LTKTLRec.tlMultiBuyDiscount := 0;
                              LTKTLRec.tlMultiBuyDiscountChr := #0;

                              rLineNetTotal := rOrigNetAmount - rTotalTransDiscountAmount;
                            end else
                            begin
                              NetValue := TKStockPriceRec.Price;

                              {.298}
                              ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty
                              , rLineNetTotal, not bVATInclusive, not bVATInclusive));
                            end;

                            {.298}
                            // if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rLineNetTotal, TRUE)) then
//                            begin

//                                  NetValue := rNetPrice; {.196}

                            // get total discount amount
                            LTKTLRec.DiscountChr := ' ';
                            LTKTLRec.Discount := 0;

                            {.296}
                            LTKTLRec.tlMultiBuyDiscount := 0;
                            LTKTLRec.tlMultiBuyDiscountChr := ' ';
                            LTKTLRec.tlTransValueDiscount := 0;
                            LTKTLRec.tlTransValueDiscountChr := ' ';
                            LTKTLRec.tlTransValueDiscountType := 0;

//                                  LTKTLRec.NetValue := rPreEPOSDiscount;

                            {.197}
                            If bVATInclusive then NetValue := rPreEPOSDiscount
                            else NetValue := TKStockPriceRec.Price;

                            if ZeroFloat(DoDiscountLineTotal(TheTXLineRec, LTKTLRec, TKTLRec.Qty, rNonDiscLineNetTotal, TRUE, FALSE))
                            then rTotalDiscAmount := rNonDiscLineNetTotal - rLineNetTotal;
//                            end;{if}

                            {.298}
                            if not bVATInclusive then
                            begin
                              rAdvDiscLineNetTotal := rLineNetTotal;
                            end;{if}

                            iStatus := Ex_CalcLineTax(@VatTKTLRec, sizeof(VatTKTLRec),TheTXRec.TKTXHeader.DiscSetl);
                            if (iStatus = 0) then
                              begin
                                VatTKTLRec.NetValue := Round_Up(VatTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}
                                TKTLRec.VAT := VatTKTLRec.VAT;
                                rLineTotal := rLineNetTotal + TKTLRec.VAT;
//                                If bVATInclusive then begin
    //                                  rNetPrice := VatTKTLRec.NetValue; {.213}
    //                                  TKTLRec.NetValue := VatTKTLRec.NetValue; {.213}
//                                end;
                              end
                            else ShowTKError('Ex_CalcLineTax', 144, iStatus);
                          end
                        else ShowTKError('Ex_CalcLineTax', 144, iStatus);
                      end;{with}
                    end
                  else ShowTKError('Ex_GetCorrectVATCode', 145, iStatus);
                end
              else ShowTKError('Ex_CalcStockPrice', 80, iStatus);
            end;{with}
          end;
        end;{case}
      end;{with}
    end;{if}
  end;{with}
end;

function RecalcNonStockPrice(var TheNonStockLineRec : TTXLineRec; InputPrice, Quantity : Real
;VATCode : Char; VATInclusive : boolean) : TPriceRec;{.166}
var
  sFormat : string;
  VATRate : Real;
begin
  {setup rounding from enterprise}
  sFormat := '############0.' + StringOfChar('0',TKSysRec.PriceDP);

  with TheNonStockLineRec do begin
    TKTLRec.VATCode := VATCode;
    TKTLRec.Qty := Quantity;
    bVATInclusive := VATInclusive;
    VATRate := GetVatRateFromCode(VATCode);

    if bVATInclusive then
      begin
        rNetPrice := InputPrice / (1 + VATRate);
      end
    else begin
      rNetPrice := InputPrice;
    end;{if}

    {round it}
    if bVATInclusive then rNetPrice := StrToFloat(FormatFloat(sFormat, rNetPrice));

    {***************** ADD EPOS DISCOUNTS ****************}
    rPreEPOSDiscount := rNetPrice;

    {Remove EPOS discount}
    if rDiscount > 0 then begin
      case cDiscount of
        DT_OVERRIDE_PRICE : rNetPrice := rDiscount; {Override Price}
        DT_PERCENTAGE : rNetPrice := rNetPrice * ((100 - rDiscount) / 100); {Percentage Discount}
        DT_DISCOUNT_AMOUNT : rNetPrice := rNetPrice - rDiscount; {Amount Discount}
      end;{case}
    end;{if}

    rPrice := rNetPrice * (1 + VATRate);
    if bVATInclusive then rPrice := StrToFloat(FormatFloat(sFormat, rPrice));

    rDiscAmount := Round_Up(Round_Up(rPreEPOSDiscount
    , TKSysRec.PriceDP) - rNetPrice, TKSysRec.PriceDP); {store the amount that has been discounted}

    if (rDiscAmount < 0.00001) or (rDiscAmount > 0.00001)
    then rDiscAmount := 0; {stop rounding errors}

    rTotalLineVATAmount := rPrice - rNetPrice;
    TKTLRec.VAT := rTotalLineVATAmount * TKTLRec.Qty;
    rLineTotal := rPrice * TKTLRec.Qty;
    rLineNetTotal := rNetPrice * TKTLRec.Qty;

    Result.NetPrice := rNetPrice;
    Result.VATAmount:= rTotalLineVATAmount;
    Result.Price := rPrice;
    Result.Quantity := TKTLRec.Qty;
    Result.TotalPrice := rLineTotal;
  end;{with}
end;


end.
