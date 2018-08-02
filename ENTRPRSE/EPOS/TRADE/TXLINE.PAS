unit TxLine;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , VarConst, EPOSProc, StdCtrls, IAeverButton, ExtCtrls, FindStk, LineDisc
  , mbdLineFrame, TEditVal, StrUtil, DLLInc, BTSupU1, TXRecs, MiscUtil
  , EntLicence, Btrvu2, MultiBuyVar, CalcPric, ExWrap1U, TCMEntFuncs;

type
  TFrmTXLine = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edStockCode: TEdit;
    shBar: TShape;
    btnFind: TIAeverButton;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    Label5: TLabel;
    lDesc1: TLabel;
    btnDiscount: TIAeverButton;
    lDesc2: TLabel;
    lDesc3: TLabel;
    lDesc4: TLabel;
    lDesc5: TLabel;
    lDesc6: TLabel;
    edQuantity: TCurrencyEdit;
    panPrice: TPanel;
    lNetPrice: TLabel;
    Label6: TLabel;
    Shape2: TShape;
    lVATAmountTit: TLabel;
    lPriceIncVAT: TLabel;
    lVATAmount: TLabel;
    lPrice: TLabel;
    Label11: TLabel;
    lQuantity: TLabel;
    lTotalPriceincVAT: TLabel;
    lTotalPrice: TLabel;
    btnStock: TIAeverButton;
    panStock: TPanel;
    Label4: TLabel;
    Shape3: TShape;
    Label8: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    HedStock: TIAeverButton;
    HedPrice: TIAeverButton;
    Label19: TLabel;
    lTotInStock: TLabel;
    lTotAllocated: TLabel;
    lTotPicked: TLabel;
    lTotFreeStock: TLabel;
    lTotOnOrder: TLabel;
    btnSerial: TIAeverButton;
    PanStockLoc: TPanel;
    Label18: TLabel;
    lLocInStock: TLabel;
    lLocAllocated: TLabel;
    lLocPicked: TLabel;
    lLocFreeStock: TLabel;
    lLocOnOrder: TLabel;
    cmbVatRate: TComboBox;
    cbInclusive: TCheckBox;
    lVATRate: TLabel;
    btnCustom1: TIAeverButton;
    btnCustom2: TIAeverButton;
    btnBins: TIAeverButton;
    lInclusive: TLabel;
    panMBD: TPanel;
    sbMBD: TScrollBox;
    btnNonStock: TIAeverButton;
    btnMultiBuy: TIAeverButton;
    hedMBD: TIAeverButton;
    procedure btnFindClick(Sender: TObject);
    procedure btnDiscountClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStockCodeExit(Sender: TObject);
    procedure edQuantityChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edQuantityExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnNonStockClick(Sender: TObject);
    procedure btnStockClick(Sender: TObject);
    procedure btnSerialClick(Sender: TObject);
    procedure VATChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HOOK_TXLineCustomButtonClick(Sender: TObject);
    procedure HOOK_TXLineEnterQuantity(Sender: TObject);
    procedure btnBinsClick(Sender: TObject);
    procedure lInclusiveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnMultiBuyClick(Sender: TObject);
  private
    bShowMultiBuy, bBarCode : boolean;
    sBarCode : string;
    MBDFrames : TMBDFramesController;
//    ExchIDRec : IDetail;
    ExLocal : TdExLocal;
    iMBDFrames : integer;
    procedure EnableDisable;
    procedure FillFormFromRec(bChangeDetails : boolean; bUpdateMBD : boolean = TRUE);
//    function AskForSerialNumbers : boolean;
//    function AskForBinNumbers : boolean;
    procedure ResizeWindow;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
//    procedure PopulateIDRec;
    procedure MBDChanged(Sender: TObject);
    procedure CreateMBDFrameController;
    procedure PopulateMBDs;
  public
    TXLineRec : TTXLineRec;
    FormMode : TFormMode;
  end;

var
  FrmTXLine: TFrmTXLine;

implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  EPOSKey, EntLkUp, TXHead, TKUtil, UseDLLU, APIUtil, EPOSCnst, NonStock, SysU2
  , Serial, GfxUtil, BackGrnd, SerialPrc, MultiBinPrc, mathutil, MultiBins;

{$R *.DFM}

Function AllocStock(TKStockRec : TBatchSKRec) : Double;
Begin
  With TKStockRec do begin
    {$IFDEF SOP}
      If (TKSysRec.UsePick4All) then
        Result := QtyPicked
      else
    {$ENDIF}
      Result := QtyAllocated;
  end; {With..}
end; {Func..}

Function FreeStock(TKStockRec : TBatchSKRec) :  Real;
Begin
  With TKStockRec do begin
    If (TKSysRec.FreeExAll) then
      FreeStock := QtyInStock
    else
      FreeStock := (QtyInStock-AllocStock(TKStockRec));
  end; {With..}
end; {Func..}


procedure TFrmTXLine.btnFindClick(Sender: TObject);
begin
  with TFrmFindStock.Create(Self) do begin
    try
      if ShowModal = mrOK then begin
//        TXLineRec.sStockCode := Stock.StockCode;
        FillTXLineRec(TXRec, TXLineRec, Stock.StockCode, edQuantity.Value);
        FillFormFromRec(TRUE);
        EnableDisable;
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TFrmTXLine.btnDiscountClick(Sender: TObject);
begin
  if btnDiscount.enabled then begin
    ActiveControl := btnDiscount;
    with TFrmLineDiscount.Create(Self) do begin
      try
        with TXLineRec do begin
         {Fill form from TXLineRec discount fields}

          // NF: 21/04/2008 {.287}
{          if bVATInclusive and (cDiscount = DT_OVERRIDE_PRICE) then begin
            cDiscount := DT_PERCENTAGE;
            rDiscount := 0;
          end;{if}

          case cDiscount of
            DT_PERCENTAGE : rbPercent.Checked := TRUE;
            DT_DISCOUNT_AMOUNT  : rbAmount.Checked := TRUE;
            DT_OVERRIDE_PRICE : rbOverride.Checked := TRUE;
          end;{case}
          edDiscount.Value := rDiscount;

          {.258}
//          if bVATInclusive then rbOverride.Enabled := FALSE;

          if ShowModal = mrOK then begin
            {Fill TXLineRec discount fields from form}
            if rbPercent.Checked then cDiscount := DT_PERCENTAGE
            else if rbAmount.Checked then cDiscount := DT_DISCOUNT_AMOUNT
                 else if rbOverride.Checked then cDiscount := DT_OVERRIDE_PRICE;

            rDiscount := edDiscount.Value;

{            case cDiscount of
              DT_PERCENTAGE : sDiscount := MoneyToStr(rDiscount) + ' %';
              DT_DISCOUNT_AMOUNT  : sDiscount := sCurrencySym + ' ' + MoneyToStr(rDiscount);
              DT_OVERRIDE_PRICE : sDiscount := 'override';
            end;{case}

            SetDiscountStr(TXLineRec);

            {.258}
            // NF: 21/04/2008 {.287}
            // Botch VAT inclusive price override
{            if bVATInclusive and rbOverride.Checked then
            begin
              cDiscount := DT_DISCOUNT_AMOUNT;
//              if not bOrigVatIncPriceStored then rOrigVatIncPrice := rPrice;
              if not bOrigVatIncPriceStored then rOrigVatIncPrice := TKStockPRiceRec.Price; {.266}
 {             bOrigVatIncPriceStored := TRUE;
              rDiscount := rOrigVatIncPrice - edDiscount.Value;
            end;{if}

            {Recalculate and show new price}
            CalcStockPrice(TXRec, TXLineRec, FALSE);

//            PopulateIDRec;
//            MBDFrames.UpdateValues(TXLineRec.TKTLRec.Qty, ExLocal.LId.NetValue, ExLocal.LId);

            FillFormFromRec(FALSE);
            EnableDisable;
          end;{if}
        end;{with}
      finally
        Release;
      end;{try}
    end;{with}

    // newbridge special
//    btnDiscount.enabled := FALSE;
  end;{if}
end;

procedure TFrmTXLine.FormKeyPress(Sender: TObject; var Key: Char);
var
  iStatus : smallint;
begin
  if BarCodeKeyPress(Sender, Key, ActiveControl, Handle, bBarCode, sBarCode, TRUE) then
  begin
    iStatus := Ex_GetStock(@TXLineRec.TKStockRec, SizeOf(TXLineRec.TKStockRec), PChar(sBarCode), 8, B_GetEq, FALSE);
    case iStatus of
      0 : begin {found - add item to list}
        with TXLineRec, TKStockRec do begin
          TKTLRec.StockCode := StockCode;
          bStockOK := TRUE;
//          sDiscount := '-';
          SetDiscountStr(TXLineRec);
          FillTXLineRec(TXRec, TXLineRec, TKTLRec.StockCode, 1, TRUE);
        end;{with}
        CalcStockPrice(TXRec, TXLineRec);
        FillFormFromRec(TRUE);
        ActiveControl := edQuantity;
        EnableDisable;
      end;

      4 : begin {not found}
        MyMsgBox('There is no stock record that matches this barcode : ' + sBarCode,mtInformation
        ,[mbOK],mbOK,'Barcode not found');
      end;

      else ShowTKError('Ex_GetStock', 80, iStatus);
    end;{case}
  end;{if}
end;

procedure TFrmTXLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  if (not bBarCode) and (Key <> VK_CONTROL) then begin
    GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
    LocalKey := Key;
    Key := 0;

    {trap function Keys}
    If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
      begin
        case LocalKey of
//          VK_F1 : Application.HelpCommand(HELP_Finder,0);
          VK_F4 : btnDiscountClick(btnDiscount);
          VK_F5 : btnStockClick(btnStock);
          VK_F6 : btnBinsClick(btnBins);
          VK_F7 : btnSerialClick(btnSerial);
          VK_F8 : btnNonStockClick(btnNonStock);
          VK_F9 : btnOKClick(btnOK);
          VK_F12 : btnFindClick(btnFind);
          else Key := LocalKey;
        end;{case}
      end
    else Key := LocalKey;
  end;{if}
end;

procedure TFrmTXLine.edStockCodeExit(Sender: TObject);
var
  sStockCode : String20;
  sPrevStockCode : string;
  {iStatus, }iPos : integer;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> btnFind) and (ActiveControl <> nil)
  and (ActiveControl <> btnNonStock) then begin
    sPrevStockCode := Trim(TXLineRec.TKTLRec.StockCode);
    TXLineRec.TKTLRec.StockCode := edStockCode.Text;
    sStockCode := TXLineRec.TKTLRec.StockCode;
    if DoGetStock(self, sCurrCompPath, TXLineRec.TKTLRec.StockCode, sStockCode, [stkProduct, stkBOM]
    , vmShowList, TRUE) then
      begin
        TXLineRec.TKTLRec.StockCode := sStockCode;
        edStockCode.Text := TXLineRec.TKTLRec.StockCode;
        if (Trim(sStockCode) <> sPrevStockCode) then begin {.213}
//        if (Trim(TXLineRec.TKTLRec.StockCode) <> sPrevStockCode) then begin
          FillTXLineRec(TXRec, TXLineRec, edStockCode.Text, edQuantity.Value, Trim(sPrevStockCode) <> Trim(TXLineRec.TKTLRec.StockCode));

          // MBD
          PopulateMBDs;

          FillFormFromRec(TRUE);
          EnableDisable;

          {clear serial numbers list}
          if Assigned(TXLineRec.SerialNumbers) then begin
            with TXLineRec, SerialNumbers do begin
              For iPos := 0 to Count - 1 do Objects[iPos].Free;
              Clear;
            end;{with}
          end;{if}

          {clear Bin numbers list}
          if Assigned(TXLineRec.BinNumbers) then begin
            with TXLineRec, BinNumbers do begin
              For iPos := 0 to Count - 1 do Objects[iPos].Free;
              Clear;
            end;{with}
          end;{if}

          // MBD
{          PopulateIDRec;
//            MBDFrames.ExLocal.LId := ExchIDRec;
          MBDFrames.AddMBDLineFrames(TXRec.TKTXHeader.CustCode, TXLineRec.TKTLRec.StockCode
          , DateToStr8(Date), SetupRecord.TillCurrency);}
        end;{if}
      end
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TFrmTXLine.edQuantityChange(Sender: TObject);
begin
  lQuantity.Caption := edQuantity.Text;
  EnableDisable;
end;

procedure TFrmTXLine.EnableDisable;
{enables / disables the appropriate controls}
begin
  btnOK.Enabled := TXLineRec.bStockOK and (StrToFloatDef(edQuantity.Text,0) <> 0);
  btnDiscount.Visible := aAllowedTo[atDoDiscounts];
  btnDiscount.Enabled := btnDiscount.Visible and TXLineRec.bStockOK and (edQuantity.Value <> 0);
  btnNonStock.Visible := FormMode = fmAdd;
  btnSerial.Enabled := TXLineRec.bSerial;
  btnBins.Enabled := TXLineRec.TKStockRec.UsesBins;
//  cbInclusive.enabled := TXLineRec.cDiscount <> DT_OVERRIDE_PRICE;
//  lInclusive.enabled := cbInclusive.enabled;
end;

procedure TFrmTXLine.btnOKClick(Sender: TObject);
var
  bContinue, bOk : boolean;
  rLNetPrice : real;

  // v6.40.311
  // https://jira.iris.co.uk/browse/ABSEXCH-9892
  // https://jira.iris.co.uk/browse/ABSEXCH-7881
  // Moved to EPOSPROC.pas
{  function ShowStockWarning : boolean;
  begin{ShowStockWarning}
{    if (SetupRecord.TransactionType = TX_UNPICKED_SORs) then  // Unpicked SORs
      begin
        // just warn - always allow user to continue
        Result := TRUE;
        MyMsgBox('There is not enough stock to cover the quantity that you have entered.'
        ,mtInformation,[mbOK],mbOK,'Stock Level Warning');
      end
    else Result := AllowedTo(atNegativeStock);
  end;{ShowStockWarning}

  Procedure HOOK_TXLineBeforeStore;
  begin{HOOK_NonStockBeforeStore}
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTransactionLine, hpTXLineBeforeStore) then begin
        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransactionLine, hpTXLineBeforeStore
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, TXLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin
          if DataChanged then begin
            // Update form with changes
            TXLineRec := LCurrentTXLineRec;
          end;{if}
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_NonStockBeforeStore}
(*
  Function CheckStock(TKStockRec : TBatchSKRec; TKStockLocRec : TBatchSLRec; rLineQty : real) : boolean;

    Function CheckStockLevel(LStockrec : TBatchSkRec; LStockLocRec : TBatchSLRec; rQty : real) : boolean;
    begin{CheckStockLevel}
      Result := TRUE;

      // NOT Multi Location Stock
      if ((TKSysRec.MultiLocn = 0)
      and ((LStockrec.QtyInStock - Lstockrec.QtyPicked - Lstockrec.QtyPickWOR) < rQty))
      then Result := FALSE;

      // Multi Location Stock
      if ((TKSysRec.MultiLocn > 0)
      and ((LStockLocRec.lsQtyInStock - LStockLocRec.lsQtyPicked - LStockLocRec.lsQtyPickWOR) < rQty))
      then Result := FALSE;
    end;{CheckStockLevel}

  var
    BOMLinesRec : TBatchBOMLinesRec;
    LStockRec : TBatchSkRec;
    LStockLocRec : TBatchSLRec;
    asStockCode, asDefStockLocation, asCompStockCode : ANSIString;
    iStatus, iComp : integer;
    bBOMStockLevelOK : boolean;

  begin{CheckStock}
    Result := TRUE;
    asDefStockLocation := SetupRecord.DefStockLocation;

    if (TKStockRec.stocktype <> 'D') then
    begin

      // Is it a BOM ?
      if (TKStockRec.StockType = 'M') {and TKStockRec.ShowAsKit} then
      begin

        // Get Stock Record for the BOM
        asCompStockCode := TKStockRec.StockCode;
        iStatus := EX_GETSTOCK(@LStockRec, SizeOf(LStockRec), PChar(asCompStockCode)
        , 0, B_GetEq, FALSE);

        if iStatus = 0 then
        begin

          // Get Stock Location Record for the BOM
          iStatus := EX_GETSTOCKLOC(@LStockLocRec, SizeOf(LStockLocRec)
          , PChar(asCompStockCode), PChar(asDefStockLocation), FALSE);

          if (iStatus = 4) then
          begin
            // There are no stock location records for this item
            FillChar(LStockLocRec, SizeOf(LStockLocRec), #0);
          end else
          begin
            ShowTKError('EX_GETSTOCKLOC', 70, iStatus);
          end;{if}

          // Check Stock Level of BOM itself
          bBOMStockLevelOK := CheckStockLevel(LStockRec, LStockLocRec, rLineQty);
          if bBOMStockLevelOK then exit;  // Stock Level of BOM is OK so we're alright

          if TKSysRec.DeductBOMComponents then
          begin

            // Check Stock levels for all the components in this BOM, since the BOM is not in stock
            asStockCode := TKStockRec.StockCode;

            // get the components for this BOM
            if EX_GETSTOCKBOM(@BOMLinesRec, SizeOf(BOMLinesRec), PChar(asStockCode), 0) = 0 then
            begin

              // go through all the components
              For iComp := 1 to 500 do
              begin
                asCompStockCode := BOMLinesRec[iComp].StockCode;

                // stop when you find a blank stock code
                if trim(asCompStockCode) = '' then exit;

                // Get Stock Record for this component
                iStatus := EX_GETSTOCK(@LStockRec, SizeOf(LStockRec), PChar(asCompStockCode)
                , 0, B_GetEq, FALSE);
                if iStatus = 0 then
                begin
                  // Get Stock Location Record for this component
                  iStatus := EX_GETSTOCKLOC(@LStockLocRec, SizeOf(LStockLocRec)
                  , PChar(asCompStockCode), PChar(asDefStockLocation), FALSE);

                  if (iStatus = 4) then
                  begin
                    // There are no stock location records for this item
                    FillChar(LStockLocRec, SizeOf(LStockLocRec), #0);
                  end else
                  begin
                    ShowTKError('EX_GETSTOCKLOC', 70, iStatus);
                  end;{if}

                end else
                begin
                  // Stock Record Not found
                  if (iStatus = 4) then FillChar(LStockRec, SizeOf(LStockRec), #0)  // No Stock Record - this should never happen
                  else ShowTKError('EX_GETSTOCK', 80, iStatus);
                end;{if}

                Result := CheckStock(LStockRec, LStockLocRec, rLineQty * BOMLinesRec[iComp].QtyUsed);

                // quit if any component is not in stock
                if Result = FALSE then exit;

              end;{for}
            end;{if}
          end else
          begin
            Result := bBOMStockLevelOK;
          end;{if}
        end else
        begin
          // Stock Record Not found
          if (iStatus = 4) then FillChar(LStockRec, SizeOf(LStockRec), #0)  // No Stock Record - this should never happen
          else ShowTKError('EX_GETSTOCK', 80, iStatus);
        end;{if}
      end else
      begin
        // Not a BOM so just check the stock level of the Stock item
        Result := CheckStockLevel(TKStockRec, TKStockLocRec, rLineQty);
      end;{if}
    end;{if}
  end;{CheckStock}
*)
  procedure GetMBDDescLines;
  begin{GetMBDDescLines}
    if Assigned(TXLineRec.MBDDescLines) then
    begin
      ClearList(TXLineRec.MBDDescLines);
      TXLineRec.MBDDescLines.Free;
    end;{if}
    TXLineRec.MBDDescLines := TStringList.Create;
    TXLineRec.MBDDescLines.Assign(MBDFrames.GetDiscountLineStrings);
    RemoveStockCodesFromMBDDescLines(Trim(TXLineRec.TKStockRec.StockCode), TXLineRec.MBDDescLines);
  end;{GetMBDDescLines}

begin
  with TXLineRec do begin
    if (TKTLRec.Qty > 0) or ((TKTLRec.Qty < 0) and AllowedTo(atEnterNegQty)) then begin
      if (rNetPrice >= 0) or ((rNetPrice < 0) and AllowedTo(atEnterNegValue)) then begin
//        if Assigned(MBDFrames) and (MBDFrames.TotalBuyQty > TKTLRec.Qty) then
        if Assigned(MBDFrames) and (MBDFrames.TotalBuyQty > TKTLRec.Qty) and (TKTLRec.Qty >= 0) then {.309}
        begin
          // {306}
          MyMsgBox('The quantity required for the specified Multi-Buy(s) exceeds the line quantity.'
          , mtWarning, [mbOK], mbOK, 'Multi-Buy Quantity'); 
        end
        else
        begin
          if btnOK.enabled then begin

            // Check Stock Levels
            bContinue := TRUE;
            bOk := TRUE;
            if Not CheckStock(tkstockrec, TKStockLocRec, TKTLRec.Qty)
            then ShowStockWarning(bContinue);

            if bContinue then
            begin

              // reset cost price flag
              bSellingPriceTooLow := FALSE;

              // Check Exchequer Password;
              if not aAllowedTo[atSellAtLessThanCost] then
              begin
                // Check Cost Price is more than selling price
                rLNetPrice := rNetPrice * WhatIsOne(TKStockRec);{.279}
                if ZeroFloat(rLNetPrice - TKStockRec.CostPrice){.279}
                or ((rLNetPrice - TKStockRec.CostPrice) > 0) then  // A-OK {.279}
                else begin
                  MyMsgBox('The selling price is too low for this stock item.'#13#13#9
                  + 'Cost Price : ' + MoneyToStr(TKStockRec.CostPrice, TKSysRec.CostDP) + #13#9
                  + 'Sales Price : ' + MoneyToStr(rLNetPrice, TKSysRec.PriceDP) + #13#9
                  , mtWarning, [mbOK], mbOK, 'Selling Price Warning');
                  bSellingPriceTooLow := TRUE;
  //                bContinue := FALSE;
                end;{if}
              end;{if}

              if bContinue then
              begin

                // Check for serial numbers
  //              bOk := TRUE;
                if bSerial then begin
                  if TKTLRec.Qty <> Round(TKTLRec.Qty) then
                  begin
                    MsgBox('You cannot have a fractional quantity on a serial numbered item.'
                    ,mtError,[mbOK],mbOK,'Serial Numbering Error');
                    bOK := FALSE;
                  end else
                  begin
                    // Don't ask for Serials for Unpicked Orders
                    if SetupRecord.TransactionType <> TX_UNPICKED_SORs then
                    begin
                      {check to see if we have stored enough serial numbers}
                      if not zerofloat(NoOfSerialNumbers(SerialNumbers, TKStockRec) - TKTLRec.Qty)
                      then bOk := AskForSerialNumbers(TXLineRec);
                    end;{if}
                  end;{if}
                end;{if}

                // Check for bin numbers
                if bOK and TKStockRec.UsesBins then begin
    {              if TKTLRec.Qty <> Round(TKTLRec.Qty) then
                    begin
                      MsgBox('You cannot have a fractional quantity on a serial numbered item.'
                      ,mtError,[mbOK],mbOK,'Serial Numbering Error');
                      bOK := FALSE;
                    end
                  else begin}
                    // Don't ask for Bins for Unpicked Orders
                    if SetupRecord.TransactionType <> TX_UNPICKED_SORs then begin
                      {check to see if we have stored enough serial numbers}
                      if not zerofloat(NoOfBinNumbers(BinNumbers, TKStockRec) - ABS(TKTLRec.Qty))
                      then bOk := AskForBinNumbers(TXLineRec);
                    end;{if}
    //              end;{if}
                end;{if}
              end;{if}

              {OK - Add Line}
              if bOk then begin
                ActiveControl := btnOK;

                GetMBDDescLines;

                HOOK_TXLineBeforeStore;

                ModalResult := mrOk;
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{with}
end;

procedure TFrmTXLine.edQuantityExit(Sender: TObject);
var
  bQtyChanged : boolean;
begin
  {Modifies the quantity, recalculates the price and updates the display}
  bQtyChanged := TXLineRec.TKTLRec.Qty <> edQuantity.Value;
  TXLineRec.TKTLRec.Qty := edQuantity.Value;
  if trim(TXLineRec.TKTLRec.StockCode) <> '' then begin
    CalcStockPrice(TXRec, TXLineRec, bQtyChanged and (SetupRecord.DiscountType = 1));
    FillFormFromRec(FALSE);
  end;{if}
end;

procedure TFrmTXLine.FillFormFromRec(bChangeDetails : boolean; bUpdateMBD : boolean = TRUE);
{fills the form's fields from the transaction line record}
var
  rMBD : Double;
  cMBD : Char;
  TKStockRec4Loc : TBatchSKRec;
  pLocation, pStockCode : PChar;
  iStatus : integer;
begin
  with TXLineRec, TKStockRec do begin

    // Calc MBD
    if bUpdateMBD then
    begin
//      PopulateIDRec;
      PopulateIDRecFromTXLineRec(TXLineRec, ExLocal);
      MBDFrames.StockCode := TXLineRec.TKTLRec.StockCode;
      MBDFrames.EnableFrames(TXLineRec.TKTLRec.Qty);
      MBDFrames.UpdateQuantities(TXLineRec.TKTLRec.Qty);
      MBDFrames.UpdateValues(TXLineRec.TKTLRec.Qty, ExLocal.LId.NetValue, ExLocal.LId);
    end;{if}
    MBDFrames.GetUnitDiscountValue(rMBD, cMBD);
    TXLineRec.rMultiBuyDisc := rMBD;
    TXLineRec.cMultiBuyDisc := cMBD;

    {.303}
//    if TXLineRec.cMultiBuyDisc = '%' then TXLineRec.rMultiBuyDiscAmount := (TXLineRec.rNetPrice * TXLineRec.rMultiBuyDisc)
//    else TXLineRec.rMultiBuyDiscAmount := TXLineRec.rMultiBuyDisc;
    {.304}
    if TXLineRec.cMultiBuyDisc = '%'
    then TXLineRec.rMultiBuyDiscAmount := (TXLineRec.rPreEPOSDiscount * TXLineRec.rMultiBuyDisc)
    else TXLineRec.rMultiBuyDiscAmount := TXLineRec.rMultiBuyDisc;

    TXLineRec.TKTLRec.tlMultiBuyDiscount := rMBD;
    TXLineRec.TKTLRec.tlMultiBuyDiscountChr := cMBD;
    CalcStockPrice(TXRec, TXLineRec, FALSE);
    SetDiscountStr(TXLineRec);

    lNetPrice.Caption := sCurrencySym + ' ' + FloatToStrF(rNetPrice, ffFixed, 15, TKSysRec.PriceDP);

//    lVATAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rTotalLineVATAmount);{.213}
    lVATAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rVATAmountForOne);{.213}

    lPrice.Caption := sCurrencySym + ' ' + MoneyToStr(rPrice);
    lQuantity.Caption := FloatToStrF(TKTLRec.Qty, ffFixed, 15, TKSysRec.QuantityDP);
    lTotalPrice.Caption := sCurrencySym + ' ' + MoneyToStr(rLineTotal);

    if bChangeDetails then begin
      edStockCode.Text := TKTLRec.StockCode;
      edQuantity.Value := TKTLRec.Qty;

      lDesc1.Caption := Desc[1];
      lDesc2.Caption := Desc[2];
      lDesc3.Caption := Desc[3];
      lDesc4.Caption := Desc[4];
      lDesc5.Caption := Desc[5];
      lDesc6.Caption := Desc[6];

      if cmbVATRate.visible then
      begin
        if bVATInclusive then HighlightVATRate(SVATIncFlg, cmbVATRate)
        else HighlightVATRate(VATCode, cmbVATRate);
        cbInclusive.Checked := bVATInclusive;
      end;{if}

      {Get Multi Location stock information}
      FillChar(TKStockRec4Loc,sizeOf(TKStockRec4Loc),#0);
      FillChar(TKStockLocRec,sizeOf(TKStockLocRec),#0);

      if (Trim(edStockCode.Text) <> '') then begin

        pStockCode := StrAlloc(255);
        pLocation := StrAlloc(255);
        StrPCopy(pStockCode, edStockCode.Text);
        StrPCopy(pLocation, SetupRecord.DefStockLocation);
        iStatus := EX_GETSTOCKLOC(@TKStockLocRec, SizeOf(TKStockLocRec), pStockCode, pLocation, FALSE);
        if (iStatus <> 4) then ShowTKError('EX_GETSTOCKLOC', 70, iStatus);

        // Update Qty's for split packs {.281}
        QtyPicked := QtyPicked * WhatIsOne(TKStockRec);
        QtyAllocated := QtyAllocated * WhatIsOne(TKStockRec);
        QtyInStock := QtyInStock * WhatIsOne(TKStockRec);
        TKStockLocRec.lsQtyPicked := TKStockLocRec.lsQtyPicked * WhatIsOne(TKStockRec);
        TKStockLocRec.lsQtyAlloc := TKStockLocRec.lsQtyAlloc * WhatIsOne(TKStockRec);
        TKStockLocRec.lsQtyInStock := TKStockLocRec.lsQtyInStock * WhatIsOne(TKStockRec);

        if (iStatus = 0) then begin
          {Fill values needed to pass into AllocStock & FreeStock routines}
          with TKStockRec4Loc do begin
            QtyPicked := TKStockLocRec.lsQtyPicked;
            QtyAllocated := TKStockLocRec.lsQtyAlloc;
            QtyInStock := TKStockLocRec.lsQtyInStock;
          end;{with}
        end;{if}

        StrDispose(pStockCode);
        StrDispose(pLocation);
      end;{if}

      {show location stock details}
      lLocInStock.Caption := MoneyToStr(TKStockLocRec.lsQtyInStock, TKSysRec.QuantityDP);
      lLocAllocated.Caption := MoneyToStr(AllocStock(TKStockRec4Loc), TKSysRec.QuantityDP);
      lLocPicked.Caption := MoneyToStr(TKStockLocRec.lsQtyPicked, TKSysRec.QuantityDP);
      lLocFreeStock.Caption := MoneyToStr(FreeStock(TKStockRec4Loc), TKSysRec.QuantityDP);
      lLocOnOrder.Caption := MoneyToStr(TKStockLocRec.lsQtyOnOrder, TKSysRec.QuantityDP);

      {Show Total Stock Details}
      lTotInStock.Caption := MoneyToStr(TKStockRec.QtyInStock, TKSysRec.QuantityDP);
      lTotAllocated.Caption := MoneyToStr(AllocStock(TKStockRec), TKSysRec.QuantityDP);
      lTotPicked.Caption := MoneyToStr(TKStockRec.QtyPicked, TKSysRec.QuantityDP);
      lTotFreeStock.Caption := MoneyToStr(FreeStock(TKStockRec), TKSysRec.QuantityDP);
      lTotOnOrder.Caption := MoneyToStr(TKStockRec.QtyOnOrder, TKSysRec.QuantityDP);
    end;{if}

  end;{with}
end;

procedure TFrmTXLine.FormShow(Sender: TObject);
var
  bCloseWindow : boolean;

  function HOOK_TXLineInitialise : boolean;
  begin{HOOK_TXLineInitialise}
    Result := FALSE;
    bCloseWindow := FALSE;
    if (FormMode = fmAdd) then begin
      {$IFDEF TCCU}  // Trade Counter Customisation
        // Check to see if the event has been enabled by a Plug-In
        if TradeCustomisation.GotEvent(twiTransactionLine, hpTXLineInitialise) then begin
          // Update EventData with current data values
          TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransactionLine, hpTXLineInitialise
          , TXRec, FrmTXHeader.lvLines, TKLocationRecord, TXLineRec, TKPayLines, FrmTXHeader);

          // Execute the Hook Point Event
          TradeCustomisation.ExecuteEvent;

          // Check the Plug-In changed something
          with TradeCustomisation.EventDataO do begin
            if DataChanged then begin
              // Update form with changes
              TXLineRec := LCurrentTXLineRec;
              bCloseWindow := TradeCustomisation.EventDataO.aBoolResult[1];
              Result := TRUE;
            end;{if}
          end;{with}
        end; { If TradeCustomisation.GotEvent... }
      {$ENDIF}
    end;{if}
  end;{HOOK_TXLineInitialise}

begin{FormShow}
  lVATRate.Visible := SetupRecord.AllowModifyVATRate and AllowedTo(atModifyVATRates);
  cbInclusive.Visible := SetupRecord.AllowModifyVATRate and AllowedTo(atModifyVATRates);
  lInclusive.Visible := cbInclusive.Visible;
  cmbVatRate.Visible := SetupRecord.AllowModifyVATRate and AllowedTo(atModifyVATRates);

  if cmbVatRate.Visible then FillVatCombo(cmbVatRate);

  ResizeWindow;

  cbInclusive.Caption := sVATText + ' Inclusive';
  lInclusive.Caption := cbInclusive.Caption;
  lVATRate.Caption := sVATText + ' Rate';
  lVATAmountTit.Caption := sVATText + ' Amount';
  lPriceIncVAT.Caption := 'Price (inc. ' + sVATText + ')';
  lTotalPriceincVAT.Caption := 'Total Price (inc. ' + sVATText + ')';

  edQuantity.displayformat := '###0.' + StringOfChar('0',TKSysRec.QuantityDP); {cos this gets reset @ run-time - nice}

  {initialises transaction line record}

  if FormMode = fmAdd then InitialiseTXLine(TXLineRec);

  {updates the display}
  if HOOK_TXLineInitialise then
  begin
    PopulateMBDs;
    FillFormFromRec(TRUE);
    TXLineRec.TKTLRec.StockCode := '';  // NF: 23/05/2007 Added to force the screen to refresh
    ActiveControl := edQuantity;
    edStockCodeExit(edStockCode);
  end else
  begin
    PopulateMBDs;
    FillFormFromRec(TRUE);
  end;

  EnableDisable;

  {updates the display}
{  HOOK_TXLineInitialise;
  FillFormFromRec(TRUE);
  if FormMode <> fmAdd then
  begin
//    TXLineRec.TKTLRec.StockCode := '';  // NF: 23/05/2007 Added to force the screen to refresh
//    ActiveControl := edQuantity;
//    edStockCodeExit(edStockCode);
  end;{if}
{  EnableDisable;}

  if bCloseWindow then PostMessage(Self.Handle,WM_FormCloseMsg,0,0);
end;

procedure TFrmTXLine.Button1Click(Sender: TObject);
begin
  ShowMessage(edQuantity.DisplayFormat);
end;

procedure TFrmTXLine.btnNonStockClick(Sender: TObject);
var
  iModalResult : byte;
begin
  with TFrmNonStockItem.Create(Self) do begin
    try
      FormMode := fmAdd;
      iModalResult := ShowModal;
      if iModalResult = mrOK then begin
        TXLineRec := NonStockLineRec;
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
  if iModalResult = mrOK then ModalResult := mrOK;
end;

procedure TFrmTXLine.btnStockClick(Sender: TObject);
begin
  bShowStock := not bShowStock;
  ResizeWindow;
end;

procedure TFrmTXLine.btnSerialClick(Sender: TObject);
begin
  if btnSerial.enabled then begin
    ActiveControl := btnSerial;
    AskForSerialNumbers(TXLineRec);
  end;{if}
end;

procedure TFrmTXLine.ResizeWindow;
var
  bShowVATRate, bMultiLocation : boolean;
begin
  panStock.Visible := bShowStock;
  hedStock.Visible := bShowStock;

  panMBD.Visible := bShowMultiBuy;
  hedMBD.Visible := bShowMultiBuy;

  bMultiLocation := TKSysRec.MultiLocn > 0;
  PanStockLoc.Visible := bMultiLocation;

//  bShowVATRate := SetupRecord.AllowModifyVATRate and AllowedTo(atModifyVATRates);
  bShowVATRate := TRUE;

  shBar.Height := 168 + (34 * Ord(bShowVATRate));

  Height := 354
  + (71 * Ord(bShowStock))
  + (95 * Ord(bShowMultiBuy))
  + (24 * Ord(bShowStock and (bMultiLocation)))
  + (40 * Ord(bShowVATRate));

  PanStock.Height := 65 + (24 * Ord(bMultiLocation));
  HedStock.Height := PanStock.Height + 1;

  HedPrice.Top := 207 + (40 * Ord(bShowVATRate));
  panPrice.Top := HedPrice.Top + 1;

//  HedStock.Top := HedPrice.Top + 72;
//  panStock.Top := panPrice.Top + 72;
  HedStock.Top := HedMBD.Top + (95 * Ord(bShowMultiBuy));
  panStock.Top := panMBD.Top + (95 * Ord(bShowMultiBuy));

  btnStock.Top := ClientHeight - 41;
  btnCustom1.Top := btnStock.Top;
  btnCustom2.Top := btnStock.Top;
  btnOK.Top := btnStock.Top;
  btnCancel.Top := btnStock.Top;

  Top := Trunc((Screen.Height - Height)/2);
end;

procedure TFrmTXLine.VATChange(Sender: TObject);
begin
  with TXLineRec, TKStockRec do begin
    if cbInclusive.Checked then
      begin
        VATCode := 'I';
        SVATIncFlg := TVATInfo(cmbVATRate.Items.Objects[cmbVATRate.ItemIndex]).cCode;
      end
    else begin
      VATCode := TVATInfo(cmbVATRate.Items.Objects[cmbVATRate.ItemIndex]).cCode;
      SVATIncFlg := #0;
    end;{if}
    bVATInclusive := cbInclusive.Checked;
  end;{with}
  CalcStockPrice(TXRec, TXLineRec, FALSE);
  FillFormFromRec(FALSE);
end;

procedure TFrmTXLine.FormCreate(Sender: TObject);
var
  iStatus : integer;
begin
  btnMultibuy.Enabled := EnterpriseLicence.elModuleVersion = mvSPOP;

  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);

  bShowMultiBuy := FALSE;

  CreateMBDFrameController;

  ExLocal.Create;
  iStatus := Open_File(F[MultiBuyF], sCurrCompPath + FileNames[MultiBuyF], 0);
  Report_BError(MultiBuyF,iStatus);

  {$IFDEF TCCU}  // Trade Counter Customisation

    // Check to see if the Custom Buttons have been enabled by a Plug-In
    btnCustom1.Visible := TradeCustomisation.GotEvent (twiTransactionLine, hpTXLineCustom1);
    If btnCustom1.Visible Then btnCustom1.Caption := TradeCustomisation.CustomText (twiTransactionLine, hpTXLineCustom1, btnCustom1.Caption);
    SendMessage(btnCustom1.Handle,CM_MOUSEENTER,0,0); {redraw button}

    // Check to see if the Custom Buttons have been enabled by a Plug-In
    btnCustom2.Visible := TradeCustomisation.GotEvent (twiTransactionLine, hpTXLineCustom2);
    If btnCustom2.Visible Then btnCustom2.Caption := TradeCustomisation.CustomText (twiTransactionLine, hpTXLineCustom2, btnCustom2.Caption);
    SendMessage(btnCustom2.Handle,CM_MOUSEENTER,0,0); {redraw button}

  {$ENDIF}

end;

procedure TFrmTXLine.HOOK_TXLineCustomButtonClick(Sender: TObject);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    if TWincontrol(Sender).Visible and TradeCustomisation.GotEvent(twiTransactionLine, TWincontrol(Sender).Tag) then begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransactionLine, TWincontrol(Sender).Tag
      , TXRec, FrmTXHeader.lvLines, TKLocationRecord, TXLineRec, TKPayLines, FrmTXHeader);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      with TradeCustomisation.EventDataO do begin
        if DataChanged then begin
          // Update form with changes
          TXLineRec := LCurrentTXLineRec;
        end;{if}
      end;{with}
    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TFrmTXLine.WMFormCloseMsg(var Message : TMessage);
{Receive WMFormCloseMsg message}
begin
  with Message do begin
    case WParam of
      {Close Form on Form Show}
      0 : begin
        btnOKClick(btnOK);
      end;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmTXLine.HOOK_TXLineEnterQuantity(Sender: TObject);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    if TradeCustomisation.GotEvent(twiTransactionLine, hpTXLineEnterQuantity) then begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransactionLine, hpTXLineEnterQuantity
      , TXRec, FrmTXHeader.lvLines, TKLocationRecord, TXLineRec, TKPayLines, FrmTXHeader);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      with TradeCustomisation.EventDataO do begin
        if DataChanged then begin
          // Update form with changes
          TXLineRec := LCurrentTXLineRec;
          edQuantity.Value := TXLineRec.TKTLRec.Qty;
        end;{if}
      end;{with}
    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TFrmTXLine.btnBinsClick(Sender: TObject);
begin
  if btnBins.enabled then begin
    ActiveControl := btnBins;
    AskForBinNumbers(TXLineRec);
  end;{if}
end;

procedure TFrmTXLine.lInclusiveClick(Sender: TObject);
begin
  cbInclusive.Checked := not cbInclusive.Checked;
  cbInclusive.SetFocus;
end;

procedure TFrmTXLine.FormDestroy(Sender: TObject);
begin
  Close_File(F[MultiBuyF]);
  ExLocal.Destroy;
  FreeAndNil(MBDFrames);
end;

procedure TFrmTXLine.btnMultiBuyClick(Sender: TObject);
begin
  bShowMultiBuy := not bShowMultiBuy;
  ResizeWindow;
end;


procedure TFrmTXLine.MBDChanged(Sender: TObject);
begin
  FillFormFromRec(FALSE, FALSE);
end;

procedure TFrmTXLine.CreateMBDFrameController;
begin
  MBDFrames := TMBDFramesController.Create;
  MBDFrames.OnValueChanged := MBDChanged;
  MBDFrames.ScrollBox := sbMBD;
  MBDFrames.IsSales := TRUE;
  MBDFrames.ExLocal := @ExLocal;
end;

procedure TFrmTXLine.PopulateMBDs;
var
  iPos : integer;
begin{PopulateMBDs}

  FreeAndNil(MBDFrames);
  CreateMBDFrameController;

  // Add Frames for MBDs
//  PopulateIDRec;
  PopulateIDRecFromTXLineRec(TXLineRec, ExLocal);
  MBDFrames.StockCode := TXLineRec.TKTLRec.StockCode;
  iMBDFrames := MBDFrames.AddMBDLineFrames(TXRec.TKTXHeader.CustCode, TXLineRec.TKTLRec.StockCode
  , DateToStr8(Date), SetupRecord.TillCurrency);

  // Fix colors on frames for TCM
  For iPos := 0 to sbMBD.ComponentCount-1 do
  begin
    if (sbMBD.Components[iPos] is TMultiBuyDiscountLineFrame)
    then TMultiBuyDiscountLineFrame(sbMBD.Components[iPos]).edtMBDQty.Font.Color := clBlack;
  end;{for}

  // Show/Hide MDBs
  if ((iMBDFrames > 0) and (not bShowMultiBuy))
  or ((iMBDFrames = 0) and (bShowMultiBuy)) then
  begin
    btnMultiBuyclick(btnMultiBuy);
  end;{if}
end;{PopulateMBDs}


end.
