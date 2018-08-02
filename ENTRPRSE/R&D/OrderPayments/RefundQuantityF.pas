unit RefundQuantityF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OrderPaymentsInterfaces, ComCtrls, Math, TEditVal,
  EnterToTab, ExtCtrls;

type
  TfrmOrderPaymentRefundLineQty = class(TForm)
    panRefund: TPanel;
    Label3: TLabel;
    lblOutstanding: TLabel;
    Label4: TLabel;
    radNoRefund: TRadioButton;
    radFullRefund: TRadioButton;
    radPartRefundByValue: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    lvPaymentLines: TListView;
    ccyPartRefundValue: TCurrencyEdit;
    ccyPartPaymentOutstanding: TCurrencyEdit;
    EnterToTab1: TEnterToTab;
    panManualVATWarning: TPanel;
    Procedure DoCheckyChecky(Sender: TObject);
    procedure ccyPartRefundValueChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FManualVAT : Boolean;
    FPaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
	// MH 13/01/2015 v7.1 ABSEXCH-16022: Rewrite so that Order Refunds show Outstanding and SIN's show matched payments
    FMaxRefundValue : Double;
    Procedure SetManualVAT(Value : Boolean);
    Procedure SetPaymentLine(Value : IOrderPaymentsTransactionPaymentInfoPaymentLine);
    Function ValidatePartRefundByValue : Boolean;
  public
    { Public declarations }
    // MH 16/12/2014 ABSEXCH-15940: Show the Manual VAT warning for transactions with Manual VAT enabled
    Property ManualVAT : Boolean Read FManualVAT Write SetManualVAT;
    Property PaymentLine : IOrderPaymentsTransactionPaymentInfoPaymentLine Read FPaymentLineIntf Write SetPaymentLine;
    Procedure SetColours(Const MasterFont : TFont; Const MasterColour : TColor);
  end;

implementation

{$R *.dfm}

Uses GlobVar, VarConst, ETStrU, ETMiscU;

//=========================================================================

Procedure TfrmOrderPaymentRefundLineQty.SetColours(Const MasterFont : TFont; Const MasterColour : TColor);
Begin // SetColours
  lvPaymentLines.Color := MasterColour;
  lvPaymentLines.Font.Assign(MasterFont);

  ccyPartRefundValue.Color := MasterColour;
  ccyPartRefundValue.Font.Assign(MasterFont);
End; // SetColours

//-------------------------------------------------------------------------

Procedure TfrmOrderPaymentRefundLineQty.SetManualVAT(Value : Boolean);
Begin // SetManualVAT
  FManualVAT := Value;

  // MH 16/12/2014 ABSEXCH-15940: Show the Manual VAT warning for transactions with Manual VAT enabled
  panManualVATWarning.Caption := 'Warning: This transaction has ' + CCVATName^ + ' Content Amended set, please check figures';
  panManualVATWarning.Visible := FManualVAT;
  ClientHeight := panRefund.Top + panRefund.Height;
End; // SetManualVAT

//------------------------------

Procedure TfrmOrderPaymentRefundLineQty.SetPaymentLine(Value : IOrderPaymentsTransactionPaymentInfoPaymentLine);
Begin // SetPaymentLine
  // Configure Currency Edit fields --------------------
  ccyPartRefundValue.CurrencySymb := Value.opplCurrencySymbol;
  ccyPartRefundValue.Value := 0.0; // Forces control to repaint
  ccyPartPaymentOutstanding.CurrencySymb := Value.opplCurrencySymbol;
  ccyPartPaymentOutstanding.Value := 0.0; // Forces control to repaint

  // Have to do this after formatting the fields to avoid the validation kicking in
  FPaymentLineIntf := Value;

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Rewrite so that Order Refunds show Outstanding and SIN's show matched payments
  If (FPaymentLineIntf.opplPaymentInfoMode = pimInvoice) Then
    // Invoice - Show Matched Value
    FMaxRefundValue := FPaymentLineIntf.opplMatchedValue
  Else
    // Order - Show Outstanding Value
    FMaxRefundValue := FPaymentLineIntf.opplUnmatchedValue;

  // Display line details ------------------------------
  lvPaymentLines.Items.Clear;
  With lvPaymentLines.Items.Add Do
  Begin
    // Stock Code
    Caption := FPaymentLineIntf.opplOrderLine.opolLine.StockCode;
    // Quantity
    SubItems.Add (Form_Real(FPaymentLineIntf.opplOrderLine.opolLine.Qty, 0, Syss.NoQtyDec));
    // Description
    SubItems.Add (FPaymentLineIntf.opplOrderLine.opolLine.Desc);
    // Unit Price - 2dp as it includes discounts so it isn't really a unit value any more so Sale Decs don't apply (Roger agreed)
    SubItems.Add (FPaymentLineIntf.opplCurrencySymbol + Form_Real(FPaymentLineIntf.opplOrderLine.opolUnitPrice, 0, 2));
    // Gross Line Total (Goods + VAT)
    SubItems.Add (FPaymentLineIntf.opplCurrencySymbol + Form_Real(FPaymentLineIntf.opplOrderLine.opolLineTotal, 0, 2));
    // Payment Value
    //SubItems.Add (FPaymentLineIntf.opplCurrencySymbol + Form_Real(FPaymentLineIntf.opplNetPaymentValue, 0, 2));
    SubItems.Add (FPaymentLineIntf.opplCurrencySymbol + Form_Real(FMaxRefundValue, 0, 2));
  End; // With lvPaymentLines.Items.Add
  radFullRefund.Caption := radFullRefund.Caption + ' (' + FPaymentLineIntf.opplCurrencySymbol + Form_Real(FMaxRefundValue, 0, 2) + ')';

  // Work out what refund is already assigned ----------
  If FPaymentLineIntf.opplRefundSelected Then
  Begin
    If (FPaymentLineIntf.opplRefundValue = FMaxRefundValue) Then
      radFullRefund.Checked := True
    Else
    Begin
      radPartRefundByValue.Checked := True;
      ccyPartRefundValue.Value := FPaymentLineIntf.opplRefundValue;
      ccyPartRefundValueChange(Self);
    End; // Else
  End // If FPaymentLineIntf.opplRefundSelected
  Else
    radNoRefund.Checked := True;

  // Update fields based on radio button selection
  DoCheckyChecky(Self);
End; // SetPaymentLine

//-------------------------------------------------------------------------

// Update fields based on radio button selection
Procedure TfrmOrderPaymentRefundLineQty.DoCheckyChecky(Sender: TObject);
Begin // DoCheckyChecky
  ccyPartRefundValue.Enabled := radPartRefundByValue.Checked;
End; // DoCheckyChecky

//-------------------------------------------------------------------------

Function TfrmOrderPaymentRefundLineQty.ValidatePartRefundByValue : Boolean;
Var
  V : Double;
Begin // ValidatePartRefundByValue
  // Call UnformatText to force it to process the entered text and update the Value property
  ccyPartRefundValue.UnFormatText;
  V := Round_Up(ccyPartRefundValue.Value, 2);
  Result := (V > 0) And (V <= FMaxRefundValue);
End; // ValidatePartRefundByValue

//------------------------------

procedure TfrmOrderPaymentRefundLineQty.ccyPartRefundValueChange(Sender: TObject);
begin
  If Assigned(FPaymentLineIntf) Then
  Begin
    If ValidatePartRefundByValue Then
    Begin
      ccyPartPaymentOutstanding.Font.Color := clBlack;
      ccyPartPaymentOutstanding.Value := Round_Up (FMaxRefundValue - ccyPartRefundValue.Value, 2);
      ccyPartPaymentOutstanding.FormatText;
    End // If ValidatePartRefundByValue
    Else
    Begin
      ccyPartPaymentOutstanding.Font.Color := clRed;
      ccyPartPaymentOutstanding.Text := 'ERROR';
    End; // Else
  End; // If Assigned(FPaymentLineIntf)
end;

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentRefundLineQty.btnOKClick(Sender: TObject);
begin
  If radNoRefund.Checked Then
  Begin
    FPaymentLineIntf.opplRefundSelected := False;
    ModalResult := mrOK;
  End // If radNoRefund.Checked
  Else If radFullRefund.Checked Then
  Begin
    FPaymentLineIntf.opplRefundSelected := True;
    FPaymentLineIntf.opplRefundValue := FMaxRefundValue;
    ModalResult := mrOK;
  End // If radFullRefund.Checked
  Else If radPartRefundByValue.Checked Then
  Begin
    If ValidatePartRefundByValue Then
    Begin
      FPaymentLineIntf.opplRefundSelected := True;
      FPaymentLineIntf.opplRefundValue := ccyPartRefundValue.Value;
      ModalResult := mrOK;
    End // If ValidatePartRefundByValue
    Else
    Begin
      If ccyPartRefundValue.CanFocus Then
        ccyPartRefundValue.SetFocus;
      // MH 29/09/2014 Order Payments ABSEXCH-15676: Changed wording
      MessageDlg ('The Part Refund Value must be greater than zero and cannot exceed the Payment Value', mtWarning, [mbOK], 0);
    End; // Else
  End; // If radPartRefundByValue.Checked
end;

//=========================================================================

end.
