unit NonStock;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, ExtCtrls, TEditVal, IAeverButton, EPOSProc, {NeilProc,} DLLInc
  , TXRecs, MiscUtil;

type
  TFrmNonStockItem = class(TForm)
    Label2: TLabel;
    Shape1: TShape;
    Label5: TLabel;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    btnDiscount: TIAeverButton;
    edQuantity: TCurrencyEdit;
    Panel1: TPanel;
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
    edDescription1: TEdit;
    edDescription2: TEdit;
    edDescription3: TEdit;
    edDescription4: TEdit;
    edDescription5: TEdit;
    edDescription6: TEdit;
    edPrice: TCurrencyEdit;
    Label1: TLabel;
    cmbVatRate: TComboBox;
    lVATRate: TLabel;
    cbInclusive: TCheckBox;
    btnCustom2: TIAeverButton;
    btnCustom1: TIAeverButton;
    lInclusive: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edDescription1Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDiscountClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JustRecalc(Sender: TObject);
    procedure HOOK_NonStockCustomButtonClick(Sender: TObject);
    procedure DescriptionLineExit(Sender: TObject);
    procedure HOOK_NonStockEnterQuantity(Sender: TObject);
    procedure lInclusiveClick(Sender: TObject);
  private
    bRecalc : boolean;
    procedure FillFormFromRec;
  public
    { Public declarations }
    NonStockLineRec : TTXLineRec;
    FormMode : TFormMode;
    procedure FillNonStockDescs(var TheTKStockRec : TBatchSKRec);
  end;

var
  FrmNonStockItem: TFrmNonStockItem;

implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  CalcPric, UseDLLU, TKUtil, StrUtil, EPOSKey, LineDisc, EPOSCnst, GfxUtil, TXHead;

{$R *.DFM}

procedure TFrmNonStockItem.FormShow(Sender: TObject);
begin
  cbInclusive.Caption := sVATText + ' Inclusive';
  lInclusive.Caption := cbInclusive.Caption;
  lVATRate.Caption := sVATText + ' Rate';
  lVATAmountTit.Caption := sVATText + ' Amount';
  lPriceIncVAT.Caption := 'Price (inc. ' + sVATText + ')';
  lTotalPriceincVAT.Caption  := 'Total Price (inc. ' + sVATText + ')';

  FillVatCombo(cmbVatRate);
  bRecalc := FormMode = fmAdd;
  if FormMode = fmAdd then begin

    InitialiseTXLine(NonStockLineRec);

    with NonStockLineRec, TKStockRec do begin
      bStockOK := TRUE;
      SellUnit := 1;
      SetNonStockFields(NonStockLineRec, TRUE);
    end;{with}
  end;{if}
  FillFormFromRec;
  edDescription1Change(nil);
  edQuantity.displayformat := '###0.' + StringOfChar('0',TKSysRec.QuantityDP); {cos this gets reset @ run-time - nice}
  edPrice.displayformat := '#########0.' + StringOfChar('0',TKSysRec.PriceDP); {cos this gets reset @ run-time - nice}
  btnDiscount.Visible := aAllowedTo[atDoDiscounts];
end;

procedure TFrmNonStockItem.FillFormFromRec;
{fills the form's fields from the transaction line record}
begin
  with NonStockLineRec, TKStockRec do begin
    bRecalc := FALSE;
    edQuantity.Value := TKTLRec.Qty;

//    if bVATInclusive then edPrice.Value := rPreEPOSDiscount + rTotalLineVATAmount
    if bVATInclusive then edPrice.Value := rOrigVatIncPrice
    else edPrice.Value := rPreEPOSDiscount;

    cbInclusive.Checked := bVATInclusive;
    bRecalc := TRUE;

    if bVATInclusive then HighlightVATRate(TKTLRec.VATIncFlg, cmbVATRate)
    else HighlightVATRate(TKTLRec.VATCode, cmbVATRate);

    edDescription1.Text := Desc[1];
    edDescription2.Text := Desc[2];
    edDescription3.Text := Desc[3];
    edDescription4.Text := Desc[4];
    edDescription5.Text := Desc[5];
    edDescription6.Text := Desc[6];

    lNetPrice.Caption := sCurrencySym + ' ' + FloatToStrF(rNetPrice, ffFixed, 15, TKSysRec.PriceDP);

    {.310}
//    lVATAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rTotalLineVATAmount);
    lVATAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rPrice - rNetPrice);

    lPrice.Caption := sCurrencySym + ' ' + MoneyToStr(rPrice);
    lQuantity.Caption  := FloatToStrF(TKTLRec.Qty, ffFixed, 15, TKSysRec.QuantityDP);
    lTotalPrice.Caption  := sCurrencySym + ' ' + MoneyToStr(rLineTotal);
  end;{with}
end;


procedure TFrmNonStockItem.btnOKClick(Sender: TObject);

  Procedure HOOK_NonStockBeforeStore;
  begin{HOOK_NonStockBeforeStore}
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiNonStock, hpNonStockBeforeStore) then begin
        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign (Self.Handle, twiNonStock, hpNonStockBeforeStore
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, NonStockLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin
          if DataChanged then begin
            // Update form with changes
            NonStockLineRec := LCurrentTXLineRec;
          end;{if}
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_NonStockBeforeStore}

begin{btnOKClick}
  if (NonStockLineRec.TKTLRec.Qty > 0) or ((NonStockLineRec.TKTLRec.Qty < 0) and AllowedTo(atEnterNegQty)) then begin
    if (NonStockLineRec.rNetPrice >= 0) or ((NonStockLineRec.rNetPrice < 0) and AllowedTo(atEnterNegValue)) then begin
      if btnOK.Enabled then begin
        ActiveControl := btnOK;
        FillNonStockDescs(NonStockLineRec.TKStockRec);
        NonStockLineRec.sDesc := edDescription1.Text;
        NonStockLineRec.bNonStock := TRUE;

        HOOK_NonStockBeforeStore;

        ModalResult := mrOk;
      end;{if}
    end;{if}
  end;{if}
end;

procedure TFrmNonStockItem.edDescription1Change(Sender: TObject);
begin
  btnOK.Enabled := (Trim(edDescription1.Text) <> '') and (NonStockLineRec.TKTLRec.Qty <> 0);
end;

procedure TFrmNonStockItem.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmNonStockItem.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F4 : btnDiscountClick(nil);
        VK_F9 : btnOKClick(nil);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmNonStockItem.btnDiscountClick(Sender: TObject);
begin
  if btnDiscount.visible then begin
    FillNonStockDescs(NonStockLineRec.TKStockRec);
    with TFrmLineDiscount.Create(Self) do begin
      try
        with NonStockLineRec do begin
         {Fill form from TXLineRec discount fields}
          case cDiscount of
            DT_PERCENTAGE : rbPercent.Checked := TRUE;
            DT_DISCOUNT_AMOUNT  : rbAmount.Checked := TRUE;
            DT_OVERRIDE_PRICE : rbOverride.Checked := TRUE;
          end;{case}
          edDiscount.Value := rDiscount;

          {.258}
//          if bVATInclusive then rbOverride.Enabled := FALSE;

          // NF: 21/04/2008 {.287}
          // No point allowing the user to override the price, as they enter it manually anyway.
          // Change approved by Mark Roke
          rbOverride.Visible := FALSE;
          lOverride.Visible := FALSE;

          if ShowModal = mrOK then begin
            {Fill TXLineRec discount fields from form}
            if rbPercent.Checked then cDiscount := DT_PERCENTAGE
            else if rbAmount.Checked then cDiscount := DT_DISCOUNT_AMOUNT;
//                 else if rbOverride.Checked then cDiscount := DT_OVERRIDE_PRICE;

            rDiscount := edDiscount.Value;

            {.258}
            // Botch VAT inclusive price override
{            if bVATInclusive and rbOverride.Checked then
            begin
              cDiscount := DT_DISCOUNT_AMOUNT;
              if not bOrigVatIncPriceStored then rOrigVatIncPrice := rPrice;
              bOrigVatIncPriceStored := TRUE;
              rDiscount := rOrigVatIncPrice - edDiscount.Value;
            end;{if}

            // set discount string
{            case cDiscount of
              DT_PERCENTAGE : sDiscount := MoneyToStr(rDiscount) + ' %';
              DT_DISCOUNT_AMOUNT  : sDiscount := sCurrencySym + ' ' + MoneyToStr(rDiscount);
//              DT_OVERRIDE_PRICE : sDiscount := 'override';
            end;{case}
            SetDiscountStr(NonStockLineRec);

            {Recalculate and show new price}
            JustRecalc(nil);
            FillFormFromRec;
          end;{if}
        end;{with}
      finally
        Release;
      end;{try}
    end;{with}
  end;{if}
end;

procedure TFrmNonStockItem.FillNonStockDescs(var TheTKStockRec : TBatchSKRec);
begin
  with TheTKStockRec do begin
    Desc[1] := edDescription1.Text;
    Desc[2] := edDescription2.Text;
    Desc[3] := edDescription3.Text;
    Desc[4] := edDescription4.Text;
    Desc[5] := edDescription5.Text;
    Desc[6] := edDescription6.Text;
  end;{with}
end;


procedure TFrmNonStockItem.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);

  {$IFDEF TCCU}  // Trade Counter Customisation

    // Check to see if the Custom Buttons have been enabled by a Plug-In
    btnCustom1.Visible := TradeCustomisation.GotEvent (twiNonStock, hpNonStockCustom1);
    If btnCustom1.Visible Then btnCustom1.Caption := TradeCustomisation.CustomText (twiNonStock, hpNonStockCustom1, btnCustom1.Caption);
    SendMessage(btnCustom1.Handle,CM_MOUSEENTER,0,0); {redraw button}

    // Check to see if the Custom Buttons have been enabled by a Plug-In
    btnCustom2.Visible := TradeCustomisation.GotEvent (twiNonStock, hpNonStockCustom2);
    If btnCustom2.Visible Then btnCustom2.Caption := TradeCustomisation.CustomText (twiNonStock, hpNonStockCustom2, btnCustom2.Caption);
    SendMessage(btnCustom2.Handle,CM_MOUSEENTER,0,0); {redraw button}

  {$ENDIF}

end;

procedure TFrmNonStockItem.JustRecalc(Sender: TObject);{.166}
begin

  // update original vat inc price
  with NonStockLineRec do begin
    if cbInclusive.Checked then
    begin
      if (not bOrigVatIncPriceStored) or (rOrigVatIncPrice <> edPrice.Value)
      then rOrigVatIncPrice := edPrice.Value;
      bOrigVatIncPriceStored := TRUE;
    end else
    begin
//      rOrigVatIncPrice := 0;
//      bOrigVatIncPriceStored := FALSE;
    end;{if}
  end;{with}

  
  if bRecalc then begin

    with NonStockLineRec do begin

      bVATInclusive := cbInclusive.Checked;

      if bVATInclusive then
        begin
          TKTLRec.VATCode := 'I';
          TKTLRec.VATIncFlg := TVATInfo(cmbVATRate.Items.Objects[cmbVATRate.ItemIndex]).cCode;

          {.226}
          if cDiscount = DT_OVERRIDE_PRICE then begin
            cDiscount := DT_DISCOUNT_AMOUNT;
            rDiscount := 0;
          end;{if}
        end
      else begin
        TKTLRec.VATCode := TVATInfo(cmbVATRate.Items.Objects[cmbVATRate.ItemIndex]).cCode;
        TKTLRec.VATIncFlg := #0;
      end;{if}

      rNetPrice := StrToFloatDef(edPrice.Text, 0);
      rPrice := StrToFloatDef(edPrice.Text, 0);
      TKTLRec.Qty := StrToFloatDef(edQuantity.Text, 0);

      CalcStockPrice(TXRec, NonStockLineRec);

      lNetPrice.Caption := sCurrencySym + ' ' + FloatToStrF(rNetPrice, ffFixed, 15, TKSysRec.PriceDP);

      {.310}
//      lVATAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rTotalLineVATAmount);
      lVATAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rPrice - rNetPrice);

      lPrice.Caption := sCurrencySym + ' ' + MoneyToStr(rPrice);
      lQuantity.Caption := FloatToStrF(TKTLRec.Qty, ffFixed, 15, TKSysRec.QuantityDP);
      lTotalPrice.Caption := sCurrencySym + ' ' + MoneyToStr(rLineTotal);
      edDescription1Change(nil);

      cbInclusive.Checked := bVATInclusive; {Added to fix problem with VAT Inclusive Plug-In}

    end;{with}

  end;{if}
end;

procedure TFrmNonStockItem.HOOK_NonStockCustomButtonClick(Sender: TObject);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    If TWincontrol(Sender).Visible And TradeCustomisation.GotEvent(twiNonStock, TWincontrol(Sender).Tag) Then Begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiNonStock, TWincontrol(Sender).Tag
      , TXRec, FrmTXHeader.lvLines, TKLocationRecord, NonStockLineRec, TKPayLines, FrmTXHeader);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      with TradeCustomisation.EventDataO do begin
        if DataChanged Then Begin
          // Update form with changes
          NonStockLineRec := LCurrentTXLineRec;
        end;{if}
      end;{with}
    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TFrmNonStockItem.DescriptionLineExit(Sender: TObject);
begin
  FillNonStockDescs(NonStockLineRec.TKStockRec);
  NonStockLineRec.sDesc := edDescription1.Text;
  NonStockLineRec.bNonStock := TRUE;
end;


procedure TFrmNonStockItem.HOOK_NonStockEnterQuantity(Sender: TObject);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    if TradeCustomisation.GotEvent(twiNonStock, hpNonStockEnterQuantity) then begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiNonStock, hpNonStockEnterQuantity
      , TXRec, FrmTXHeader.lvLines, TKLocationRecord, NonStockLineRec, TKPayLines, FrmTXHeader);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      with TradeCustomisation.EventDataO do begin
        if DataChanged then begin
          // Update form with changes
          NonStockLineRec := LCurrentTXLineRec;
          edQuantity.Value := NonStockLineRec.TKTLRec.Qty;
        end;{if}
      end;{with}
    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TFrmNonStockItem.lInclusiveClick(Sender: TObject);
begin
  cbInclusive.checked := not cbInclusive.checked;
  cbInclusive.SetFocus;
end;

end.
