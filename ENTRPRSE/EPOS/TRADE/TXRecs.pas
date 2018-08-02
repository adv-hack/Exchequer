unit TXRecs;

interface
uses
  VarRec2U, ComCtrls, Classes, StrUtil, DLLInc, EPOSCnst, VarConst, CalcVBD
  , TCMEntFuncs, EXWrap1U, APIUtil, Dialogs;

type
  TCustType = (ctNormal, ctCashOnly, ctOnHold);

  TTXRec = Record
    bAccountOK : boolean;
    rNetTotal : real;
//    rVatTotal : real;
    rVATIncTotal : real;
    rDepositsTaken : real;
    rDepositToTake : real;
    rMoneyToBeTaken : real;
    rOutstanding : real;
    rTendered : real;
    rChange : real;
    rWrittenOff : real;
    bRefund : boolean;
    sCostCentre : string20;
    sDepartment : string20;
    iFolioNum : integer;
    arPayments : array[Low(TPayedBy)..High(TPayedBy)] of real;
    iCardType : integer;
    asCardDetails : array[1..4] of string;
    LCust : CustRec;
    CustType : TCustType;
    bNonTCMTX : boolean;
    sOverrideUserName : string;
    TKTXHeader : TBatchTHRec;
    bCardRefund : boolean;

    {.296}
    VBDs : T2VBDs;
    rTTDAmount : double;
    rVBDAmount : double;
    sTransDiscount : string20;
    rNetTotalAfterDisc : real;
    rOrigNetTotal : real;
    bFindModeTTD : boolean;

    {.298}
    bReversed : boolean;
  end;

  pTXRec = ^TTXRec;


  TTXLineRec = Record
    sDesc : String55;
    iListFolioNo : integer;
    bDescLine : boolean;
    bStockOK : boolean;
    rDiscount : real;
    cDiscount : char;
    sDiscount : string50;
    rDiscAmount : real;
    rTotalDiscAmount : real;
    rNonDiscLineNetTotal : double;
    rPreEPOSDiscount : real;
    rNetPrice : double;
    rTotalLineVATAmount : real; {.213}
    rVATAmountForOne : real; {.213}
//    rVATAmount : real;
    rPrice : real;
    rLineTotal : real;
    rLineNetTotal : double;
//    cVATCode : char;
    bVATInclusive : boolean;
    bOrigVatIncPriceStored : boolean;
    rOrigVatIncPrice : real;
    iDescLines : byte;
    TKStockRec : TBatchSKRec;
    TKStockPriceRec : TBatchStkPriceRec;
    TKStockLocRec : TBatchSLRec;
    TKTLRec : TBatchTLRec;
    bSerial : boolean;
    SerialNumbers : TStringList;
    BinNumbers : TStringList;
    iBOMParentFolioNo : integer;
    rBOMQtyUsed : Double;
    BOMComponents : Array of integer;
    bBOM : boolean;
    bBOMComponent : boolean;
    bNonStock : Boolean;
    bDateChangedByCustomisation : Boolean;
    bSellingPriceTooLow : Boolean;

    {.296}
    rDiscount3 : double;
    cDiscount3 : Char;
    iDiscount3Type : integer;
    rMultiBuyDisc : double;
    cMultiBuyDisc : char;
    bDiscountDescLine : boolean;
    MBDDescLines : TStringList;
    bMBDLine : boolean;
    rAdvDiscLineNetTotal : double;

    {.298}
    rTotalNetNoDiscounts : double;
    rTotalStandardDiscountAmount : double;
    rTotalMBDAmount : double;
    rTotalTransDiscountAmount : double;
    rIncNetPrice : double;
    rOrigNetAmount : double;
    rIncVATDiscDiff : double;

    {.303}
    rMultiBuyDiscAmount : double;
  end;

  pTXLineRec = ^TTXLineRec;


  TTXLineInfo = Class
    TXLineRec : TTXLineRec;
    procedure RecalcLine(TheTXRec : TTXRec; bResetDiscount : Boolean);
    procedure RefreshStockLevels;
    constructor create(TheTXLineRec : TTXLineRec);
  end;


  procedure FillTXLineRec(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec; StockCode : string20
  ; Quantity : real; bResetDiscounts : boolean = TRUE);
  function DoDiscountLineTotal(var TheTXLineRec : TTXLineRec; var TheTKTLRec : TBatchTLRec
  ; rQty : real; var rTotal : double; bRound : boolean; bSetDiscFields : boolean = TRUE
  ; bIncludeTransDiscount : boolean = TRUE) : smallint;
  Procedure GetCCDept(var sCC : String3; var sDept : String3; var TheTXLineRec : TTXLineRec);
  Procedure InitialiseTXLine(var TheTXLineRec : TTXLineRec; rQuantity : real = 1);
  procedure TXLineRecToItem(var TXLineRec : TTXLineRec; TheItem : TListItem);
  procedure PopulateOtherThingsAboutThisLine(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec
  ; iLineNo : integer);
  procedure RepopulateOtherThingsAboutAllLines(var TheTXRec : TTXRec; var TheListView : TListView);
  procedure SetNonStockFields(var ANonStockLineRec : TTXLineRec; bSetVATCodes : boolean);
  procedure RecalcAllTXLines(var TheTXRec : TTXRec; var TheListView : TListView
  ; bResetDiscount : Boolean);
  procedure RecalcTXTotals(var TheTXRec : TTXRec; var TheListView : TListView; bRecalcNetTotal : boolean = TRUE);
  Procedure CopyListViewItems(FromItems : TListItems; ToItems : TListItems);
  procedure DeleteLines(var TheListView : TListView; iStartIndex : integer; DeleteBOMs : boolean = TRUE);
//  procedure SetDiscountDesc(var TheTXLineRec : TTXLineRec);
  function AddTXLine(LvLines : TListView; var TheTXLineRec : TTXLineRec; var TheTXRec : TTXRec; var iInsertIndex : integer
  ; iStockFolio : integer; rPrevQty : real = 0; bExplodeBOMs : boolean = TRUE) : integer;
  procedure SetDiscountStr(var TXLineRec : TTXLineRec);
  function AddMBDDescLines(TheTXLineRec : TTXLineRec; TheLines : TListView; iInsertIndex : integer; sDate : string8) : integer;
  procedure RemoveStockCodesFromMBDDescLines(sStockCode : string; slLines : TStringList);
  procedure PopulateIDRecFromTXLineRec(TheTXLineRec : TTXLineRec; var ExLocal : TdExLocal);

var
  TXRec : TTXRec;

implementation
uses
  ETMiscU, MathUtil, {NeilProc,} EPOSProc, SysUtils, MiscUTil, TKUtil, UseDLLU
  , LicUtil, CalcPric, SerialPrc, MultiBinPrc, TTDCalcTCM;

{TTXLineInfo}

constructor TTXLineInfo.create(TheTXLineRec : TTXLineRec);
begin
  TXLineRec := TheTXLineRec;
end;

procedure TTXLineInfo.RecalcLine(TheTXRec : TTXRec; bResetDiscount : Boolean);
begin
  CalcStockPrice(TheTXRec, TXLineRec, bResetDiscount);
end;


procedure FillTXLineRec(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec; StockCode : string20
; Quantity : real; bResetDiscounts : boolean = TRUE);
{fills in the TX line details from the stock record}
var
  iStatus : smallint;
  asStockCode : ANSIString;

(*  Function HOOK_TXLineAfterGetStock : boolean;
  begin{HOOK_NonStockBeforeStore}
    Result := TRUE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTransactionLine, hpTXLineAfterGetStock) then begin
        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign (FrmTXHeader.Handle, twiTransactionLine, hpTXLineAfterGetStock
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
  end;{HOOK_NonStockBeforeStore}*)

begin
  with TheTXLineRec do begin
    TKTLRec.StockCode := StockCode;
    bStockOK := TRUE;
    TKTLRec.Qty := Quantity;

    asStockCode := TKTLRec.StockCode;
    {get toolkit record for the stock item}
    iStatus := Ex_GetStock(@TKStockRec, SizeOf(TKStockRec), PChar(asStockCode), 0, B_GetEq, FALSE);
    if (iStatus = 0) then
      begin
        with TKStockRec do begin
          TKTLRec.VATCode := VATCode;

//          if not HOOK_TXLineAfterGetStock then bResetDiscounts := TRUE;

          bSerial := ((StkValType = 'A') and (SerNoWAvg = 1)) or (StkValType = 'R');
          bVATInclusive := (TKTLRec.VATCode = 'I');
          CalcStockPrice(TheTXRec, TheTXLineRec, bResetDiscounts);

        end;{with}
      end
    else ShowTKError('Ex_GetStock', 80, iStatus);
  end;{with}
end;

function DoDiscountLineTotal(var TheTXLineRec : TTXLineRec; var TheTKTLRec : TBatchTLRec
; rQty : real; var rTotal : double; bRound : boolean; bSetDiscFields : boolean = TRUE
; bIncludeTransDiscount : boolean = TRUE) : smallint;
begin

  with TheTXLineRec, TheTKTLRec do begin

    if bSetDiscFields then begin

      case cDiscount of

        DT_PERCENTAGE :
        begin
          Discount := rDiscount / 100;
          DiscountChr := cDiscount;
        end;

        DT_DISCOUNT_AMOUNT :
        begin
          Discount := rDiscount;
          DiscountChr := cDiscount;
        end;

        DT_OVERRIDE_PRICE :
        begin
          // NF: 21/04/2008 {.287}
//          if not (bVATInclusive and (SetupRecord.DiscountType = 1)) then
//          begin
//            Discount := rPreEPOSDiscount - rDiscount;
//            DiscountChr := DT_DISCOUNT_AMOUNT;
//          end;{if}
          Discount := 0;
          DiscountChr := DT_DISCOUNT_AMOUNT;
        end;

      end;{case}

      {.296}
      tlMultiBuyDiscount := rMultiBuyDisc;
      tlMultiBuyDiscountChr := cMultiBuyDisc;

      if bIncludeTransDiscount then
      begin
        tlTransValueDiscount := rDiscount3;
        tlTransValueDiscountChr := cDiscount3;
        tlTransValueDiscountType := iDiscount3Type;
      end;

    end;{if}

    Qty := rQty;

    if bRound then
      begin
        Result := Ex_GetLineTotal(@TheTKTLRec, sizeof(TheTKTLRec), TRUE, 0.0, rTotal);
        ShowTKError('Ex_GetLineTotal', 127, Result);
      end
    else begin
      Result := Ex_RemoveDiscounts(@TheTKTLRec, sizeof(TheTKTLRec), TRUE, 0.0, rTotal);
      ShowTKError('Ex_RemoveDiscounts', 152, Result);
    end;{if}

  end;{with}
end;{DoDiscountLineTotal}

Procedure GetCCDept(var sCC : String3; var sDept : String3; var TheTXLineRec : TTXLineRec);
var
  DefaultCCDept, NewCCDept, StockCCDept : CCDepType;

  procedure ReplaceCCDeptFromLoc;
  begin{ReplaceCCDeptFromLoc}
    if TKLocationRecord.loUseCCDep then begin
      TheTXLineRec.TKStockRec.CC := TKLocationRecord.loCC;
      TheTXLineRec.TKStockRec.Dep := TKLocationRecord.loDep;
    end;{if}
  end;{ReplaceCCDeptFromLoc}

begin{GetCCDept}
  case SetupRecord.CCDeptMode of
    0,2 : begin
      sCC := TxRec.sCostCentre;
      sDept := TxRec.sDepartment;
    end;

    1 : begin
      if TKSysRec.MultiLocn > 0 then ReplaceCCDeptFromLoc;

      case EnhancedSecurity of

        luLicenced : UserProfile^ := Get_PWDefaults(sUserName);

        luNotLicenced : begin
          // fake up a user profile record that mimics enterprises default behaviour
          FillChar(UserProfile^,SizeOf(UserProfile^),#0);
          with UserProfile^ do begin
            CCDepRule := 0;
//            CCDep[FALSE] := SetupRecord.DefCostCentre;
//            CCDep[TRUE] := SetupRecord.DefDepartment;
            CCDep[TRUE] := SetupRecord.DefCostCentre;
            CCDep[FALSE] := SetupRecord.DefDepartment;
          end;{with}
        end;

      end;{case}

{      StockCCDept[FALSE] := TheTXLineRec.TKStockRec.CC;
      StockCCDept[TRUE] := TheTXLineRec.TKStockRec.Dep;
      DefaultCCDept[FALSE] := SetupRecord.DefCostCentre;
      DefaultCCDept[TRUE] := SetupRecord.DefDepartment;}
      StockCCDept[TRUE] := TheTXLineRec.TKStockRec.CC;
      StockCCDept[FALSE] := TheTXLineRec.TKStockRec.Dep;
      DefaultCCDept[TRUE] := SetupRecord.DefCostCentre;
      DefaultCCDept[FALSE] := SetupRecord.DefDepartment;

      NewCCDept := GetProfileCCDep(TXRec.LCust.CustCC, TXRec.LCust.CustDep,StockCCDept,DefaultCCDept,0);

//      sCC := NewCCDept[FALSE];
//      sDept := NewCCDept[TRUE];
      sCC := NewCCDept[TRUE];
      sDept := NewCCDept[FALSE];

    end;
  end;{case}
end;{GetCCDept}

Procedure InitialiseTXLine(var TheTXLineRec : TTXLineRec; rQuantity : real = 1);
begin
  FillChar(TheTXLineRec, SizeOf(TheTXLineRec),#0);
  with TheTXLineRec do begin
    cDiscount := DT_PERCENTAGE;
    TKTLRec.Qty := rQuantity;
    TKTLRec.LineDate := TXRec.TKTXHeader.TransDate;
    TKTLRec.QtyMul := 1; {.195}
    bStockOK := FALSE;
//    sDiscount := '-';
    SetDiscountStr(TheTXLineRec);

    if Assigned(SerialNumbers) then
    begin
      ClearList(SerialNumbers);
      SerialNumbers.Free;
    end;
    SerialNumbers := TStringList.Create;

    if Assigned(BinNumbers) then
    begin
      ClearList(BinNumbers);
      BinNumbers.Free;
    end;
    BinNumbers := TStringList.Create;

    if Assigned(MBDDescLines) then
    begin
      ClearList(MBDDescLines);
      MBDDescLines.Free;
    end;
    MBDDescLines := TStringList.Create;

    bDateChangedByCustomisation := FALSE;
  end;{with}
end;

procedure TXLineRecToItem(var TXLineRec : TTXLineRec; TheItem : TListItem);
{copies the contents of a TXLineRec into an item in the list view}

  procedure FillLVLine;
  begin
    with TheItem, TXLineRec do begin
      SubItems[1] := FloatToStrF(TKTLRec.Qty, ffFixed, 15, TKSysRec.QuantityDP);

      if not bMBDLine then
      begin
        SubItems[2] := sDiscount;

        Case SetupRecord.DiscountType of
          0 : SubItems[3] := FloatToStrF(rNetPrice, ffFixed, 15, TKSysRec.PriceDP);
          1 : SubItems[3] := FloatToStrF(rPreEPOSDiscount, ffFixed, 15, TKSysRec.PriceDP);
        end;{case}

        SubItems[4] := MoneyToStr(rLineNetTotal);
      end;{if}
    end;{with}
  end;{FillLVLine}

begin
  with TheItem, TXLineRec, TKStockRec do begin

    if (not bDescLine) and ((Trim(TKTLRec.StockCode) <> '') or bMBDLine) then
      begin
        // NOT a Decription only line
        TheItem.Caption := StockCode;
        SubItems[0] := Desc[1];
        sDesc := Desc[1];

        if ZeroFloat(TKTLRec.Qty) and ZeroFloat(rNetPrice) then
          begin
            {non-stock item extra description lines}
             bDescLine := TRUE;
          end
        else begin
          FillLVLine;
{          SubItems[1] := FloatToStrF(TKTLRec.Qty, ffFixed, 15, TKSysRec.QuantityDP);
          SubItems[2] := sDiscount;
          SubItems[3] := FloatToStrF(rNetPrice, ffFixed, 15, TKSysRec.PriceDP);
          SubItems[4] := MoneyToStr(rLineNetTotal);}
        end;{if}

        // Get BOM Icon ?
        if (TKStockRec.StockType = 'M') and TKStockRec.ShowAsKit then TheItem.ImageIndex := 1
        else begin
          if bBOMComponent then TheItem.ImageIndex := 2;
        end;{if}
      end
    else begin

      // Decription only line
      SubItems[0] := TXLineRec.sDesc;
      if bNonStock then
        begin
          ImageIndex := 0;
          FillLVLine;
        end
      else ImageIndex := -1;

    end;{if}
  end;{with}
end;

procedure PopulateOtherThingsAboutThisLine(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec; iLineNo : integer);
var
  sCC, sDept : string3;
begin

  with TheTXLineRec, TKTLRec do begin

    // Set CC / Dept for line
    GetCCDept(sCC, sDept, TheTXLineRec);
    CC := sCC;
    Dep := sDept;

    // discount fields for line
    Case cDiscount of
      DT_PERCENTAGE : begin
        DiscountChr := DT_PERCENTAGE;
        Discount := rDiscount / 100;
      end;

      DT_DISCOUNT_AMOUNT : begin
        DiscountChr := ' ';
        Discount := rDiscAmount;
      end;

      DT_OVERRIDE_PRICE : begin
//        NetValue := rNetPrice;
        NetValue := rNetPrice * WhatisOne(TheTXLineRec.TKStockRec);{.281} // Fix for override price on split packs
        DiscountChr := ' ';

        {.213}
//      Discount := 0;
        if (SetupRecord.DiscountType <> 0) then Discount := 0;

      end;
    end;{case}

    // Set Line GL Code
    if TheTXRec.LCust.DefNomCode <> 0 then TKTLRec.NomCode := TheTXRec.LCust.DefNomCode
    else begin
      if Trim(TKTLRec.StockCode) = '' then
        begin
//          TKTLRec.NomCode := SetupRecord.DefNonStockNomCode
          SetNonStockFields(TheTXLineRec, FALSE);
        end
      else begin
        if (TKSysRec.MultiLocn > 0) and TKLocationRecord.loUseNom then
          begin
            if TKStockLocRec.lsDefNom[1] = 0 then TKTLRec.NomCode := TKLocationRecord.loNominal[1] // Get GL Code from Location Record
            else TKTLRec.NomCode := TKStockLocRec.lsDefNom[1]; // Get GL Code from Stock Location Record
          end
        else TKTLRec.NomCode := TKStockRec.NomCodeS[1]; // Get GL Code from Stock Record
      end;{if}
    end;{if}

    // Make Inclusive VAT Non-Stock Items come out as Vat=MS
    if (bVATInclusive and bNonStock) then
      begin
        TKTLRec.VATCode := 'M';
//        TKTLRec.VATIncFlg := TKTLRec.VATCode;
      end
    else begin
      // Set Inclusive VAT Codes
      if (TKTLRec.VATCode in ['I', 'M']) then
      begin
        TKTLRec.VATCode := 'M';
        if Length(Trim(TKStockRec.SVATIncFlg)) > 0 then TKTLRec.VATIncFlg := TKStockRec.SVATIncFlg; {.298}
      end;{if}
    end;{if}

    // Set Line No
    TKTLRec.LineNo := iLineNo;

    // Set Qty Picked
    if SetupRecord.TransactionType = TX_PICKED_SORs then TKTLRec.QtyPick := TKTLRec.Qty;

    {Intrastat stuff}
    if TKSysRec.IntraStat and TheTXRec.LCust.EECMember then begin
      TKTLRec.SSDUplift := TKStockRec.SSDDUplift;
      TKTLRec.SSDCommod := TKStockRec.CommodCode;
      TKTLRec.SSDSPUnit := TKStockRec.SuppSUnit;
      TKTLRec.SSDCountry := TKStockRec.SSDCountry;
      TKTLRec.SSDUseLine := FALSE;
    end;{if}

  end;{with}
end;

procedure RepopulateOtherThingsAboutAllLines(var TheTXRec : TTXRec; var TheListView : TListView);
var
  iLine : integer;
begin
  For iLine := 0 to TheListView.Items.Count - 1 do
  begin
    PopulateOtherThingsAboutThisLine(TheTXRec, ttxlineinfo(TheListView.items[iLine].data).txlinerec
    , (iLine + 1) * 2);

    TXLineRecToItem(ttxlineinfo(TheListView.items[iLine].data).txlinerec,  TheListView.items[iLine]);{.305}
  end;{for}
end;

procedure SetNonStockFields(var ANonStockLineRec : TTXLineRec; bSetVATCodes : boolean);
var
  NewTKStockRec : TBatchSKRec;
  asStockCode : AnsiString;
  iStatus : integer;
begin
  with ANonStockLineRec, TKStockRec, SetupRecord do begin
    case TakeNonStockDefaultFrom of

      0 : begin
        // uses system setup defaults
        NomCodeS[1] := DefNonStockNomCode;
        TKTLRec.NomCode := DefNonStockNomCode;
        if bSetVATCodes then TKTLRec.VATCode := NonStockVATCode;
      end;

      1 : begin
        // gets info from another stock record

        {get toolkit record for the stock item}
        asStockCode := NonStockItemCode;
        iStatus := Ex_GetStock(@NewTKStockRec, SizeOf(NewTKStockRec), PChar(asStockCode), 0, B_GetEq, FALSE);
        if iStatus = 0 then
          begin
            NomCodeS[1] := NewTKStockRec.NomCodes[1];
            TKTLRec.NomCode := NewTKStockRec.NomCodes[1];
            if bSetVATCodes then TKTLRec.VATCode := NewTKStockRec.VATCode;
            TKStockRec.NomCodes[1] := NewTKStockRec.NomCodes[1];
            if bSetVATCodes then TKStockRec.VATCode := NewTKStockRec.VATCode;
          end
        else ShowTKError('Ex_GetStock', 80, iStatus);
      end;
    end;{case}
  end;{with}
end;

procedure RecalcAllTXLines(var TheTXRec : TTXRec; var TheListView : TListView; bResetDiscount : Boolean);
{Recalculates the pricing for every line in the list}
var
  iLine : integer;
begin
  with TheListView do begin
    For iLine := 0 to Items.Count - 1 do begin
      with TTXLineInfo(Items.Item[iLine].Data) do begin
        if (not TXLineRec.bDescLine) then begin
          if TXLineRec.bNonStock then TXLineRec.rNetPrice := TXLineRec.rPreEPOSDiscount;
          RecalcLine(TheTXRec, bResetDiscount);

          // added in .265
          PopulateOtherThingsAboutThisLine(TheTXRec, TXLineRec, iLine);
          SetDiscountStr(TXLineRec);
          //if not TXLineRec.bNonStock then PopulateOtherThingsAboutThisLine(TheTXRec, TXLineRec, iLine);

        end;{if}
        TXLineRecToItem(TXLineRec, Items.Item[iLine]);
      end;{with}
    end;{for}
  end;{with}
end;

procedure RecalcTXTotals(var TheTXRec : TTXRec; var TheListView : TListView; bRecalcNetTotal : boolean = TRUE);
{recalculates the transaction totals, from the lines in the ListView}
var
  oTTDCalculator : TTTDCalculator;
  iResult, iLine : integer;
  rNonDiscTotal : double;
  LTKTLRec : TBatchTLRec;
  iVatIdx : smallint;
begin
  with TheTXRec, TheListView do
  begin
    if bRecalcNetTotal then rNetTotal := 0;
//    rVatTotal := 0;
    rVATIncTotal := 0;

    TKTXHeader.DiscAmount := 0;
    TKTXHeader.InvNetVal := 0;
    TKTXHeader.InvVat := 0;
    FillChar(TKTXHeader.InvVatAnal, SizeOf(TKTXHeader.InvVatAnal),#0);

    For iLine := 0 to Items.Count - 1 do
    begin
      with TTXLineInfo(Items.Item[iLine].Data).TXLineRec do
      begin
        if bRecalcNetTotal then rNetTotal := rNetTotal + rLineNetTotal;
//        TKTXHeader.InvVat := TKTXHeader.InvVat + TKTLRec.VAT;

//        rVATIncTotal := rVATIncTotal + rLineTotal;

        {.298}
        if bVatInclusive then rVATIncTotal := rVATIncTotal + rOrigNetAmount - rTotalTransDiscountAmount + rTotalLineVATAmount
        else rVATIncTotal := rVATIncTotal + rLineTotal;

        if not bDescLine then
        begin
          // Calculate InvNetVal and Total Discount for Header
          LTKTLRec := TKTLRec;
          LTKTLRec.TransRefNo := 'SIN'; // Ex_GetLineTotal needs to know the TX Type in order to get the correct amount of decimal places NF: 08/11/2005

          iResult := Ex_GetLineTotal(@LTKTLRec, SizeOf(LTKTLRec), FALSE, 0.0, rNonDiscTotal);
          ShowTKError('Ex_GetLineTotal', 127, iResult);
          if iResult = 0 then TKTXHeader.InvNetVal := TKTXHeader.InvNetVal + rNonDiscTotal;
          TKTXHeader.DiscAmount := TKTXHeader.DiscAmount + Round_Up(rTotalDiscAmount, TKSysRec.PriceDP);

          // Add Vat to appropriate vat total on Header
          iVatIdx := -1;{.221}
          if (TKTLRec.VATCode = 'D') and LCust.EECMember then iVatIdx := 6
          else begin
            if TKTLRec.VATCode in ['M', 'I'] then iVatIdx := VatCharToIdx(TKTLRec.VATIncFlg)
            else begin
              if TKTLRec.VATCode <> #0 then iVatIdx := VatCharToIdx(TKTLRec.VATCode); {.221}
            end;
          end;{if}
          if (iVatIdx <> -1) then TKTXHeader.InvVatAnal[iVatIdx] := TKTXHeader.InvVatAnal[iVatIdx] + TKTLRec.VAT;{.221}
          TKTXHeader.InvVat := TKTXHeader.InvVat + TKTLRec.VAT;
        end;{if}
      end;{with}
    end;{for}

//rVATIncTotal := rNetTotalAfterDisc + TKTXHeader.InvVat;

//    rNetTotalAfterDisc := Round_Up(rNetTotal - rTransDiscount - rValueDiscount, 2);
    if (not ZeroFloat(rTTDAmount)) then rVBDAmount := 0; // zero VBD, when using TTD

    rNetTotalAfterDisc := Round_Up(rOrigNetTotal - rTTDAmount - rVBDAmount, 2);

//    TKTXHeader.DiscSetAm := Round_Up(rNetTotal * TKTXHeader.DiscSetl, 2);
    TKTXHeader.DiscSetAm := Round_Up(rNetTotalAfterDisc * TKTXHeader.DiscSetl, 2);

    rOutstanding := Round_Up(rVATIncTotal - rDepositsTaken - rWrittenOff - (TKTXHeader.DiscSetAm * WordBoolOrd(TKTXHeader.DiscTaken)), 2);
  end;{with}
end;

Procedure CopyListViewItems(FromItems : TListItems; ToItems : TListItems);
var
  iSerial, iLine, iBin, iPos, iPos2 : integer;
  NewItem : TListItem;
  SerialInfo : TSerialInfo;
  BinInfo : TBinInfo;
begin
  ToItems.Clear;
  For iPos := 0 to FromItems.Count - 1 do begin
    NewItem := ToItems.Add;
//    NewItem.Caption := FromItems[iPos].Caption;
    NewItem.Data := TTXLineInfo.create(TTXLineInfo(FromItems[iPos].Data).TXLineRec);
    For iPos2 := 1 to 5 do NewItem.SubItems.Add('');
    TXLineRecToItem(TTXLineInfo(ToItems.Item[iPos].Data).TXLineRec, NewItem);

    // Copy Serial Numbers
    with TTXLineInfo(NewItem.Data).TXLineRec do begin
      if bSerial and Assigned(TTXLineInfo(FromItems[iPos].Data).TXLineRec.SerialNumbers) then begin
        SerialNumbers := TStringList.Create;
        For iSerial := 0 to TTXLineInfo(FromItems[iPos].Data).TXLineRec.SerialNumbers.Count - 1 do begin
          SerialInfo := TSerialInfo.Create;
          SerialInfo.CopyFrom(TSerialInfo(TTXLineInfo(FromItems[iPos].Data).TXLineRec.SerialNumbers.Objects[iSerial]));
          SerialNumbers.AddObject(TTXLineInfo(FromItems[iPos].Data).TXLineRec.SerialNumbers[iSerial]
          , SerialInfo);
        end;{for}
      end;{if}
    end;{with}

    // Copy Bin Numbers
    with TTXLineInfo(NewItem.Data).TXLineRec do begin
      if TKStockRec.UsesBins and Assigned(TTXLineInfo(FromItems[iPos].Data).TXLineRec.BinNumbers) then begin
        BinNumbers := TStringList.Create;
        For iBin := 0 to TTXLineInfo(FromItems[iPos].Data).TXLineRec.BinNumbers.Count - 1 do begin
          BinInfo := TBinInfo.Create;
          BinInfo.CopyFrom(TBinInfo(TTXLineInfo(FromItems[iPos].Data).TXLineRec.BinNumbers.Objects[iBin]));
          BinNumbers.AddObject(TTXLineInfo(FromItems[iPos].Data).TXLineRec.BinNumbers[iBin], BinInfo);
        end;{for}
      end;{if}
    end;{with}

    // Copy MBD Description Lines
    with TTXLineInfo(NewItem.Data).TXLineRec do
    begin
      if Assigned(TTXLineInfo(FromItems[iPos].Data).TXLineRec.MBDDescLines) then
      begin
        MBDDescLines := TStringList.Create;
        For iLine := 0 to TTXLineInfo(FromItems[iPos].Data).TXLineRec.MBDDescLines.Count - 1 do
        begin
          MBDDescLines.Add(TTXLineInfo(FromItems[iPos].Data).TXLineRec.MBDDescLines[iLine]);
        end;{for}
      end;{if}
    end;{with}
  end;{for}
end;

procedure DeleteLines(var TheListView : TListView; iStartIndex : integer; DeleteBOMs : boolean = TRUE);
{deletes all lines for this item - including all additional description lines}
var
  iLine, iLastLine, iPos : integer;
begin
  with TheListView do begin

    // Delete all BOM items
    if DeleteBOMs and TTXLineInfo(Items[iStartIndex].Data).TXLineRec.bBOM then begin
      For iPos := 0 to length(TTXLineInfo(Items[iStartIndex].Data).TXLineRec.BOMComponents) - 1 do begin
        iLine := 0;
        While iLine < Items.Count do begin
          if TTXLineInfo(Items.Item[iLine].Data).TXLineRec.iListFolioNo
          = TTXLineInfo(Items[iStartIndex].Data).TXLineRec.BOMComponents[iPos]
          then DeleteLines(TheListView, iLine);
          inc(iLine);
        end;{while}
      end;{for}
    end;{if}

    {figure out which lines to delete}
//    iLastLine := Selected.Index;
    iLastLine := iStartIndex;

    Repeat
      Inc(iLastLine)
    Until (iLastLine > (Items.Count - 1))
    or ((TTXLineInfo(Items.Item[iLastLine].Data).TXLineRec.bDescLine = FALSE)
    and (TTXLineInfo(Items.Item[iLastLine].Data).TXLineRec.bMBDLine = FALSE));

    {delete lines}
    For iPos := iStartIndex to iLastLine - 1 do Items.Item[iStartIndex].Delete;
  end;{with}
end;
(*
procedure SetDiscountDesc(var TheTXLineRec : TTXLineRec);
begin
  with TheTXLineRec do
  begin
    case cDiscount of
      DT_PERCENTAGE : begin
        sDiscount := MoneyToStr(rDiscount) + ' %';
      end;

      DT_DISCOUNT_AMOUNT, ' ' : begin
        sDiscount := sCurrencySym + ' ' + MoneyToStr(rDiscount);
      end;

      DT_OVERRIDE_PRICE : sDiscount := 'override';
    end;{case}
  end;{with}
end;
*)
function AddTXLine(LvLines : TListView; var TheTXLineRec : TTXLineRec; var TheTXRec : TTXRec; var iInsertIndex : integer
; iStockFolio : integer; rPrevQty : real = 0; bExplodeBOMs : boolean = TRUE) : integer;
{adds a new line into the list}
var
  NewItem : TListItem;
  iLine : smallint;
  iPos : byte;
  {MBDTXLineRec, }DescLineRec : TTXLineRec;
  iFocusItem, iPrevFolioNo : integer;
  MainTXLineInfo : TTXLineInfo;

  procedure AddEditBOMItems;
  var
    pStockCode : PChar;
    BOMRec : TBatchBOMLinesRec;
    iLine, iBOMItemCount, iStatus : integer;
    BOMTXLineRec : TTXLineRec;

    procedure ZeroValues(var TheBOMTXLineRec : TTXlineRec);
    begin
      with TheBOMTXLineRec do begin
//        sDiscount := '-';
        SetDiscountStr(TheBOMTXLineRec);
        rDiscAmount := 0;
        rPreEPOSDiscount := 0;
        rNetPrice := 0;
        TKTLRec.VAT := 0;
        rTotalLineVATAmount := 0;
        rLineTotal := 0;
        rLineNetTotal := 0;
      end;{with}
    end;{ZeroValues}

    procedure UpdateBOMLines(var BOMTXLineRec : TTXLineRec);
    var
      iLine, iPos : integer;
    begin{UpdateBOMLines}
      with BOMTXLineRec, LvLines do begin
        For iPos := 0 to length(BOMComponents) - 1 do begin
          For iLine := 0 to Items.Count - 1 do begin
            if TTXLineInfo(Items.Item[iLine].Data).TXLineRec.iListFolioNo
            = BOMTXLineRec.BOMComponents[iPos] then begin
              TTXLineInfo(Items.Item[iLine].Data).TXLineRec.TKTLRec.Qty
              := (TTXLineInfo(Items.Item[iLine].Data).TXLineRec.TKTLRec.Qty / rPrevQty)
              * TheTXLineRec.TKTLRec.Qty;

              If BOMTXLineRec.TKStockRec.StKitPrice then ZeroValues(TTXLineInfo(Items.Item[iLine].Data).TXLineRec)
              else TTXLineInfo(Items.Item[iLine].Data).RecalcLine(TheTXRec, TRUE);

              TXLineRecToItem(TTXLineInfo(Items.Item[iLine].Data).TXLineRec, Items.Item[iLine]);
              if TTXLineInfo(Items.Item[iLine].Data).TXLineRec.bBOM then UpdateBOMLines(TTXLineInfo(Items.Item[iLine].Data).TXLineRec);
            end;{if}
          end;{for}
        end;{for}
      end;{with}
    end;{UpdateBOMLines}

  begin{AddEditBOMItems}

    TheTXLineRec.bBOM := TRUE;

    case iPrevFolioNo of
      0 : begin // New Item Added - Add BOM Items
        pStockCode := StrAlloc(21);
        StrPCopy(pStockCode,TheTXLineRec.TKTLRec.StockCode);
        iStatus := EX_GETSTOCKBOM(@BOMRec,SizeOf(BOMRec), pStockCode, 0);
        if iStatus = 0 then
          begin
            iBOMItemCount := 1;
            while (length(Trim(BOMRec[iBOMItemCount].StockCode)) > 0) and (iBOMItemCount <= 500) do begin

              InitialiseTXLine(BOMTXLineRec);
//              FillChar(BOMTXLineRec, SizeOf(BOMTXLineRec), #0);

              FillTXLineRec(TheTXRec, BOMTXLineRec, BOMRec[iBOMItemCount].StockCode
              , BOMRec[iBOMItemCount].QtyUsed * TheTXLineRec.TKTLRec.Qty);

              BOMTXLineRec.iBOMParentFolioNo := TheTXLineRec.iListFolioNo;
              BOMTXLineRec.rBOMQtyUsed := BOMRec[iBOMItemCount].QtyUsed;
              BOMTXLineRec.TKTLRec.KitLink := iStockFolio;
              BOMTXLineRec.bBOMComponent := TRUE;

              // Zero Price, if Price comes from BOM Header
              If TheTXLineRec.TKStockRec.StKitPrice then ZeroValues(BOMTXLineRec);

              Inc(iInsertIndex);
              SetLength(TheTXLineRec.BOMComponents, length(TheTXLineRec.BOMComponents) + 1);
              PopulateOtherThingsAboutThisLine(TheTXRec, BOMTXLineRec, (iInsertIndex + 1) * 2);
              TheTXLineRec.BOMComponents[length(TheTXLineRec.BOMComponents) - 1]
              := AddTXLine(lvLines, BOMTXLineRec, TheTXRec, iInsertIndex, iStockFolio);

              inc(iBOMItemCount);
            end;{while}
          end
        else ShowTKError('EX_GETSTOCKBOM', 46, iStatus);
        StrDispose(pStockCode);
      end;

      else begin // BOM Items already added, update items
        if rPrevQty <> 0 then begin
          with LvLines do begin
            For iLine := 0 to Items.Count - 1 do begin
              with TTXLineInfo(Items.Item[iLine].Data), TXLineRec do begin
//                if iBOMParentFolioNo = iPrevFolioNo then begin
                if (iListFolioNo = TheTXLineRec.iListFolioNo) then begin
                  UpdateBOMLines(TXLineRec);
                  Break;
                end;{if}
              end;{with}
            end;{for}
          end;{with}
        end;{if}
      end;

    end;{case}
  end;{AddEditBOMItems}

  function GetNextListFolioNo : integer;
  begin{GetNextListFolioNo}
    Result := lvLines.Tag;
    lvLines.Tag := lvLines.Tag + 1;
  end;{GetNextListFolioNo}

begin{AddTXLine}

//  FillChar(DescLineRec, SizeOf(DescLineRec), #0);
  InitialiseTXLine(DescLineRec);
  DescLineRec.TKTLRec.Qty := 0;
  DescLineRec.bDescLine := TRUE;
  DescLineRec.bSerial := FALSE;

{  InitialiseTXLine(MBDTXLineRec);
  MBDTXLineRec.bMBDLine := TRUE;
  MBDTXLineRec.bSerial := FALSE;}

  with TheTXLineRec do begin
    iPrevFolioNo := iListFolioNo;
    if iListFolioNo = 0 then iListFolioNo := GetNextListFolioNo;
    Result := iListFolioNo;
    bDescLine := FALSE;
//    bDescLine := (TKTLRec.KitLink <> 0) and (Trim(TKTLRec.StockCode) = '');
    iDescLines := 0;
    For iLine := 1 to 6 do begin
      if TKStockRec.Desc[iLine] <> '' then inc(iDescLines);
    end;{for}

    For iLine := 0 to TheTXLineRec.iDescLines - 1 do begin

      {adds the new line}
      NewItem := lvLines.Items.Insert(iInsertIndex + iLine);

      {inserts blank subitems to be filled in later by "TXLineRecToItem"}
      For iPos := 1 to 5 do NewItem.SubItems.Add('');

      if iLine = 0 then
      begin
        {fills the 1st line}
        TXLineRecToItem(TheTXLineRec, NewItem);

        {adds the TXLineRec object to the line}
        MainTXLineInfo := TTXLineInfo.Create(TheTXLineRec);
        NewItem.Data := MainTXLineInfo;

        if (TKStockRec.StockType = 'M') and TKStockRec.ShowAsKit then NewItem.ImageIndex := 1
        else begin
          if TheTXLineRec.bBOMComponent then
          begin
            NewItem.ImageIndex := 2;
          end else
          begin
            if TheTXLineRec.bMBDLine then NewItem.ImageIndex := -1;
          end;{if}
        end;{if}

      end else
      begin
        {fills the description line}
        NewItem.SubItems[0] := TKStockRec.Desc[iLine + 1];

        {adds the "Description Only" TXLineRec object to the line}
        if DescLineRec.TKTLRec.LineNo = 0 then DescLineRec.TKTLRec.LineNo := (iLine + 1) * 2;
        DescLineRec.sDesc := TKStockRec.Desc[iLine + 1];
        DescLineRec.bNonStock := TheTXLineRec.bNonStock;{.281}

        if TheTXLineRec.bNonStock
        then DescLineRec.TKTLRec.KitLink := SET_TO_TX_FOLIO_NO_ON_STORE;{.281} // By setting the kit link to this "magic number", on storing the TX, the toolkit will then set the Kitlink to the folio number of the transaction, once it knows what it is.


        NewItem.Data := TTXLineInfo.Create(DescLineRec);
        NewItem.ImageIndex := -1;
      end;{if}

    end;{for}

    // Bill Of Materials Item
    iFocusItem := iInsertIndex;
    if (TKStockRec.StockType = 'M') and TKStockRec.ShowAsKit and bExplodeBOMs then begin
      AddEditBOMItems;
      MainTXLineInfo.TXLineRec := TheTXLineRec; // update the list items info
    end;{if}

    AddMBDDescLines(TheTXLineRec, lvLines, iInsertIndex, TheTXRec.TKTXHeader.TransDate);

    // Add MBD Desc Lines
{    if Assigned(TheTXLineRec.MBDDescLines) then
    begin
      For iLine := 0 to TheTXLineRec.MBDDescLines.Count - 1 do
      begin
        {adds the new line}
{        NewItem := lvLines.Items.Insert(iInsertIndex + iLine + TheTXLineRec.iDescLines + 1);

        {inserts blank subitems to be filled in later by "TXLineRecToItem"}
{        For iPos := 1 to 5 do NewItem.SubItems.Add('');

        if MBDTXLineRec.TKTLRec.LineNo = 0 then MBDTXLineRec.TKTLRec.LineNo := lvLines.Items.Count+1;
        MBDTXLineRec.TKStockRec.Desc[1] := MBDDescLines[iLine];
        MBDTXLineRec.sDesc := MBDTXLineRec.TKStockRec.Desc[1];
        MBDTXLineRec.TKTLRec.Qty := TheTXLineRec.TKTLRec.Qty;
        MBDTXLineRec.TKTLRec.tlTransValueDiscountType := 255;
        MBDTXLineRec.iDiscount3Type := 255;
        MBDTXLineRec.TKTLRec.LineDate := TheTXRec.TKTXHeader.TransDate;
        MBDTXLineRec.TKTLRec.VATCode := #0;
        TXLineRecToItem(MBDTXLineRec, NewItem);

        NewItem.Data := TTXLineInfo.Create(MBDTXLineRec);
        NewItem.ImageIndex := -1;
      end;{for}
{    end;{if}

  end;{with}


  {focuses the 1st line of the newly added line}
  with lvLines do begin
//    Selected := Items.Item[iInsertIndex];
//    ItemFocused := Items.Item[iInsertIndex];
    Selected := Items.Item[iFocusItem];
    ItemFocused := Items.Item[iFocusItem];
  end;{with}

  {Updates display}
  RecalcTXTotals(TheTXRec, lvLines);
end;{AddTXLine}

procedure SetDiscountStr(var TXLineRec : TTXLineRec);
begin
  with TXLineRec do
  begin
    // Add Standard Discount
    if ZeroFloat(rDiscount) then
    begin
      sDiscount := '';
    end else
    begin
      case cDiscount of
        DT_PERCENTAGE : begin
          sDiscount := MoneyToStr(rDiscount) + '%';
        end;

        DT_DISCOUNT_AMOUNT, ' ' : begin
          sDiscount := sCurrencySym + MoneyToStr(rDiscount);
        end;

        DT_OVERRIDE_PRICE : sDiscount := 'OVR';
        else sDiscount := '';
      end;{case}
    end;{if}

    // Add Separator
    sDiscount := sDiscount + ' / ';

    // Add MBD
    if ZeroFloat(rMultiBuyDisc) then
    begin
      // Don't add anything to sDiscount
    end else
    begin
      case cMultiBuyDisc of
        DT_PERCENTAGE : begin
          sDiscount := sDiscount + MoneyToStr(rMultiBuyDisc * 100) + '%';
        end;

        DT_DISCOUNT_AMOUNT, ' ' : begin
          sDiscount := sDiscount + sCurrencySym + MoneyToStr(rMultiBuyDisc);
        end;
      end;{case}
    end;{if}

    // Add Separator
    sDiscount := sDiscount + ' / ';

    // Add TTD/VBD
    if ZeroFloat(rDiscount3) then
    begin
      // Don't add anything to sDiscount
    end else
    begin
      case cDiscount3 of
        DT_PERCENTAGE : begin
          sDiscount := sDiscount + MoneyToStr(rDiscount3 * 100) + '%';
        end;

        DT_DISCOUNT_AMOUNT, ' ' : begin
          sDiscount := sDiscount + sCurrencySym + MoneyToStr(rDiscount3);
        end;
      end;{case}
    end;{if}
  end;{with}
end;

function AddMBDDescLines(TheTXLineRec : TTXLineRec; TheLines : TListView; iInsertIndex : integer; sDate : string8) : integer;
var
  iPos, iLine : integer;
  NewItem : TListItem;
  MBDTXLineRec : TTXLineRec;
begin
  Result := 0;{.307}
  InitialiseTXLine(MBDTXLineRec);
  MBDTXLineRec.bMBDLine := TRUE;
  MBDTXLineRec.bSerial := FALSE;

  with TheTXLineRec do
  begin
    // Add MBD Desc Lines
    if Assigned(MBDDescLines) then
    begin
      For iLine := 0 to MBDDescLines.Count - 1 do
      begin
        {adds the new line}
        NewItem := TheLines.Items.Insert(iInsertIndex + iLine + iDescLines{ + 1});

        {inserts blank subitems to be filled in later by "TXLineRecToItem"}
        For iPos := 1 to 5 do NewItem.SubItems.Add('');

        if MBDTXLineRec.TKTLRec.LineNo = 0 then MBDTXLineRec.TKTLRec.LineNo := TheLines.Items.Count+1;
        MBDTXLineRec.TKStockRec.Desc[1] := MBDDescLines[iLine];
        MBDTXLineRec.sDesc := MBDTXLineRec.TKStockRec.Desc[1];
        MBDTXLineRec.TKTLRec.Qty := TKTLRec.Qty;
        MBDTXLineRec.TKTLRec.tlTransValueDiscountType := 255;
        MBDTXLineRec.iDiscount3Type := 255;
        MBDTXLineRec.TKTLRec.LineDate := sDate;
        MBDTXLineRec.TKTLRec.VATCode := #0;
        TXLineRecToItem(MBDTXLineRec, NewItem);

        NewItem.Data := TTXLineInfo.Create(MBDTXLineRec);
        NewItem.ImageIndex := -1;
      end;{for}
      Result := MBDDescLines.Count;{.307}
    end;{if}
//    Result := MBDDescLines.Count;{.307}
  end;{with}
end;

procedure RemoveStockCodesFromMBDDescLines(sStockCode : string; slLines : TStringList);
var
  iPos, iLine : integer;
begin{RemoveStockCodesFromMBDDescLines}
  For iLine := 0 to slLines.Count-1 do
  begin
    iPos := Pos(sStockCode, slLines[iLine]);
    slLines[iLine] := Copy( slLines[iLine], 1, iPos-1)
    + Copy( slLines[iLine], iPos + Length(sStockCode) + 1, 255);
  end;{for}
end;{RemoveStockCodesFromMBDDescLines}


procedure PopulateIDRecFromTXLineRec(TheTXLineRec : TTXLineRec; var ExLocal : TdExLocal);
begin
  FillChar(ExLocal.LId, SizeOf(ExLocal.LId), #0);
  ExLocal.LId := TBatchTLRecToId(TheTXLineRec.TKTLRec, TXRec.TKTXHeader);

  if TheTXLineRec.bVATInclusive then
  begin
    ExLocal.LId.NetValue := ExLocal.LId.IncNetValue
  end else
  begin
{    case SetupRecord.DiscountType of
      0 : ExLocal.LId.NetValue := TheTXLineRec.rPreEPOSDiscount;
      1 : ExLocal.LId.NetValue := TheTXLineRec.rNetPrice;
    end;{case}
//    ExLocal.LId.NetValue := TheTXLineRec.rNetPrice;

    ExLocal.LId.NetValue := TheTXLineRec.rPreEPOSDiscount;
  end;

  ExLocal.LId.DiscountChr := TheTXLineRec.cDiscount;
  ExLocal.LId.Discount := TheTXLineRec.rDiscount;
  if TheTXLineRec.cDiscount = '%' then ExLocal.LId.Discount := ExLocal.LId.Discount/100;
end;

procedure TTXLineInfo.RefreshStockLevels;
var
  LTKStockRec : TBatchSKRec;
  LTKStockLocRec : TBatchSLRec;
  iStatus : integer;
  asLocation, asStockCode : ANSIString;
begin
  asStockCode := TXLineRec.TKTLRec.StockCode;

  // v6.50.313 07/10/2010 - Do not refresh for non-stock items
  // bug fix for https://jira.iris.co.uk/browse/ABSEXCH-10310
  if Trim(asStockCode) = '' then exit;

  // MultiLocation  ?
  if (TKSysRec.MultiLocn = 0) then
  begin
    // Get Stock levels from Stock record
    iStatus := Ex_GetStock(@LTKStockRec, SizeOf(LTKStockRec), PChar(asStockCode), 0, B_GetEq, FALSE);

    // v6.50.314 12/11/2010 Fix for https://jira.iris.co.uk/browse/ABSEXCH-10478
    // Do not show error, if no stock location record exists
    if iStatus in [0,4] then
    begin
      if iStatus = 4 then
      begin
        FillChar(LTKStockLocRec, SizeOf(LTKStockLocRec), #0);
      end;{if}
//  if iStatus = 0 then
//  begin
      TXLineRec.TKStockrec.QtyInStock := LTKStockRec.QtyInStock;
      TXLineRec.TKStockrec.QtyPicked := LTKStockRec.QtyPicked;
      TXLineRec.TKStockrec.QtyPickWOR := LTKStockRec.QtyPickWOR;
    end
    else
    begin
      ShowTKError('Ex_GetStock', 80, iStatus);
    end;{if}
  end
  else
  begin
    // Get Stock levels from Stock Location record
    asLocation := SetupRecord.DefStockLocation;
    iStatus := EX_GETSTOCKLOC(@LTKStockLocRec, SizeOf(LTKStockLocRec), PChar(asStockCode), PChar(asLocation), FALSE);
    if iStatus = 0 then
    begin
      TXLineRec.TKStockLocRec.lsQtyInStock := LTKStockLocRec.lsQtyInStock;
      TXLineRec.TKStockLocRec.lsQtyPicked := LTKStockLocRec.lsQtyPicked;
      TXLineRec.TKStockLocRec.lsQtyPickWOR := LTKStockLocRec.lsQtyPickWOR;

      // In multi-location mode, Totals are held in the stock record - I think!
      TXLineRec.TKStockrec.QtyInStock := LTKStockLocRec.lsQtyInStock;
      TXLineRec.TKStockrec.QtyPicked := LTKStockLocRec.lsQtyPicked;
      TXLineRec.TKStockrec.QtyPickWOR := LTKStockLocRec.lsQtyPickWOR;
    end
    else
    begin
      ShowTKError('EX_GETSTOCKLOC', 70, iStatus);
    end;{if}
  end;{if}

  // Adjust Qtys for split packs
  TXLineRec.TKStockrec.QtyPicked := TXLineRec.TKStockrec.QtyPicked * WhatIsOne(TXLineRec.TKStockRec);
  TXLineRec.TKStockrec.QtyAllocated := TXLineRec.TKStockrec.QtyAllocated * WhatIsOne(TXLineRec.TKStockRec);
  TXLineRec.TKStockrec.QtyInStock := TXLineRec.TKStockrec.QtyInStock * WhatIsOne(TXLineRec.TKStockRec);
  TXLineRec.TKStockLocRec.lsQtyPicked := TXLineRec.TKStockLocRec.lsQtyPicked * WhatIsOne(TXLineRec.TKStockRec);
  TXLineRec.TKStockLocRec.lsQtyAlloc := TXLineRec.TKStockLocRec.lsQtyAlloc * WhatIsOne(TXLineRec.TKStockRec);
  TXLineRec.TKStockLocRec.lsQtyInStock := TXLineRec.TKStockLocRec.lsQtyInStock * WhatIsOne(TXLineRec.TKStockRec);
end;

end.
