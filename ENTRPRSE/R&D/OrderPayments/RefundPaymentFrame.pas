unit RefundPaymentFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, StrUtils, ComCtrls, CommCtrl, OrderPaymentsInterfaces, ExtCtrls, SBSPanel;

type
  TframePaymentDetails = class(TFrame)
    chkPayRef: TCheckBox;
    lblUserName: TLabel;
    lblDateTime: TLabel;
    lblCreditCardDetails: TLabel;
    lblOriginalPaymentValue: TLabel;
    lvPaymentLines: TListView;
    btnEditRefund: TButton;
    lblPaymentOurRef: TLabel;
    lblTotalRefundValue: TLabel;
    lblNetPaymentValue: TLabel;
    procedure lblPaymentOurRefClick(Sender: TObject);
    procedure chkPayRefClick(Sender: TObject);
    procedure btnEditRefundClick(Sender: TObject);
  private
    { Private declarations }
    FOnUpdateTotals : TNotifyEvent;

    OriginalListViewWindowProc : TWndMethod;
    FPaymentInfo : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
    FManualVAT : Boolean;

    Procedure SetManualVAT(Value : Boolean);
    Procedure SetPaymentInfo (Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);
    Function GetRefundGoods : Double;
    Function GetRefundVAT : Double;
    Function GetRefundRequired : Boolean;

    procedure ListViewWindowProcEx(var Message: TMessage);
    // Updates the Refund values on the row as the checked state is toggled
    Procedure UpdateRowForCheckedState (Const ListItem : TListItem);
  public
    { Public declarations }
    Property ManualVAT : Boolean Read FManualVAT Write SetManualVAT;
    Property PaymentInfo : IOrderPaymentsTransactionPaymentInfoPaymentHeader Read FPaymentInfo Write SetPaymentInfo;
    Property RefundRequired : Boolean Read GetRefundRequired;
    Property RefundGoods : Double Read GetRefundGoods;
    Property RefundVAT : Double Read GetRefundVAT;
    // Event to allow to parent form to update totals when the user enables or disables refunds
    Property OnUpdateTotals : TNotifyEvent Read FOnUpdateTotals Write FOnUpdateTotals;

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; Override;

    Procedure SetColours(Const MasterFont : TFont; Const MasterColour : TColor);

    // Performs any required validation of the frame details
    Function Validate : Boolean;
  end;

implementation

{$R *.dfm}

Uses GlobVar, VarConst, ETStrU, ETMiscU, RefundQuantityF;

//=========================================================================

Constructor TframePaymentDetails.Create (AOwner : TComponent);
Begin // Create
  Inherited Create(AOwner);

  // MH 16/12/2014 ABSEXCH-15940: Show the Manual VAT warning for transactions with Manual VAT enabled
  FManualVAT := False;
End; // Create

Destructor TframePaymentDetails.Destroy;
Begin // Destroy
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TframePaymentDetails.SetColours(Const MasterFont : TFont; Const MasterColour : TColor);
Begin // SetColours
  Self.Color := MasterColour;
  Self.Font.Assign (MasterFont);

  lblPaymentOurRef.Font.Assign(MasterFont);
  lblPaymentOurRef.Font.Style := lblPaymentOurRef.Font.Style + [fsBold];
  lblUserName.Font.Assign(lblPaymentOurRef.Font);
  lblDateTime.Font.Assign(lblPaymentOurRef.Font);
  lblCreditCardDetails.Font.Assign(lblPaymentOurRef.Font);
  lblOriginalPaymentValue.Font.Assign(lblPaymentOurRef.Font);
  lblTotalRefundValue.Font.Assign(lblPaymentOurRef.Font);
  lblNetPaymentValue.Font.Assign(lblPaymentOurRef.Font);

  lvPaymentLines.Color := Self.Color;
  lvPaymentLines.Font.Assign (Self.Font);
End; // SetColours

//-------------------------------------------------------------------------

procedure TframePaymentDetails.ListViewWindowProcEx(var Message: TMessage);
//Var
//  hdn: ^THDNotify;
begin
  // Complicated Windows API/Messaging stuff to detect the clicking of a checkbox in a listview
  // row - copied from http://delphi.about.com/od/delphitips2007/qt/listviewchecked.htm
  if Message.Msg = CN_NOTIFY then
  begin
    if PNMHdr(Message.LParam)^.Code = LVN_ITEMCHANGED then
    begin
      with PNMListView(Message.LParam)^ do
      begin
        if (uChanged and LVIF_STATE) <> 0 then
        begin
          if ((uNewState and LVIS_STATEIMAGEMASK) shr 12) <> ((uOldState and LVIS_STATEIMAGEMASK) shr 12) then
          begin
            // MH 03/06/2015 2015-R1 ABSEXCH-16422: Select row when the checkbox is ticked/unticked
            lvPaymentLines.Items[iItem].Selected := True;
            UpdateRowForCheckedState (lvPaymentLines.Items[iItem]);
          end;
        end;
      end;
    end;

    //original ListView message handling
    OriginalListViewWindowProc(Message) ;
  end
(*
  // Suppress column resizing
  // http://delphi.cjcsoft.net/viewthread.php?tid=43034
  Else If (Message.Msg = WM_NOTIFY) Then
  Begin
    hdn := Pointer(Message.lParam);
    //Abfangen und löschen der HDN_BeginTrack Botschaft
    if (hdn.hdr.code = HDN_BeginTrackW) or (hdn.hdr.code = HDN_BeginTrackA) then
      Message.Result := 1
    else
      OriginalListViewWindowProc(Message);
  End // If (Message.Msg = WM_NOTIFY)
*)
  Else
    //original ListView message handling
    OriginalListViewWindowProc(Message) ;
end;

//-------------------------------------------------------------------------

// Updates the Refund values on the row as the checked state is toggled
Procedure TframePaymentDetails.UpdateRowForCheckedState (Const ListItem : TListItem);
Var
  PaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  OnClickHandler : TNotifyEvent;
  I : Integer;
Begin // UpdateRowForCheckedState
  // Reconcile ListItem back to the payment line
  If (ListItem.Index < FPaymentInfo.opphPaymentLineCount) Then
  Begin
    PaymentLineIntf := FPaymentInfo.opphPaymentLines[ListItem.Index];

    // Update the selected status on the line
    PaymentLineIntf.opplRefundSelected := ListItem.Checked;

    // Refund Value = SubItems[5]
    ListItem.SubItems[5] := IfThen (ListItem.Checked And (PaymentLineIntf.opplRefundValue <> 0.0), FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplRefundValue, 0, 2), '');

    // Force parent SRC to be checked if the line item is checked - don't set Checked as that will
    // trigger the event handler causing all the lines to be checked
    If ListItem.Checked And (Not chkPayRef.Checked) Then
    Begin
      OnClickHandler := chkPayRef.OnClick;
      chkPayRef.OnClick := NIL;
      Try
        chkPayRef.Checked := True;
      Finally
        chkPayRef.OnClick := OnClickHandler;
      End; // Try..Finally
    End; // If ListItem.Checked And (Not chkPayRef.Checked)

    PaymentLineIntf := NIL;
  End; // If (ListItem.Index < FPaymentInfo.opphPaymentLineCount)

  If chkPayRef.Checked Then
  Begin
    // Check to see if the SRC should be unticked
    For I := 0 To (lvPaymentLines.Items.Count - 1) Do
    Begin
      If lvPaymentLines.Items[I].Checked Then
        // line item is checked so we can break out of the loop
        Break
      Else
        // Line Item not checked, so if it is the last item we can untick the SRC
        If (I = (lvPaymentLines.Items.Count - 1)) Then
          // No sub-items ticked so we can reset the SRC checkbox without worrying about the handler
          chkPayRef.Checked := False;
    End; // For I
  End; // If chkPayRef.Checked

  // Update Totals
  If Assigned(FOnUpdateTotals) Then
    FOnUpdateTotals (Self);
End; // UpdateRowForCheckedState

//-------------------------------------------------------------------------

Procedure TframePaymentDetails.SetManualVAT(Value : Boolean);
Begin // SetManualVAT
  FManualVAT := Value;
End; // SetManualVAT

//------------------------------

Procedure TframePaymentDetails.SetPaymentInfo (Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);
Var
  PaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  I : Integer;
  Item: TListItem;
Begin // SetPaymentInfo
  FPaymentInfo := Value;

  // Increase the height of the Listview until it can display the required number of lines - the
  // design time height is too short to display any rows
  While (lvPaymentLines.VisibleRowCount < FPaymentInfo.opphPaymentLineCount) Do
    lvPaymentLines.Height := lvPaymentLines.Height + 1;
  // ABSEXCH-15681: Add in height of horizontal scrollbar
  lvPaymentLines.Height := lvPaymentLines.Height + GetSystemMetrics(SM_CXHSCROLL);

  // Adjust the height of the frame based on the new listview height
  Self.Height := lvPaymentLines.Top + lvPaymentLines.Height + 3;  // 3 = a number I picked

  // Note: The caption of the checkbox is done as a label because Windows theming was overriding
  // the colour of the CheckBox caption so it wasn't showing as the standard Navy Blue

  // Set the SRC fields
  lblPaymentOurRef.Caption := FPaymentInfo.opphOurRef;
  lblUserName.Caption := FPaymentInfo.opphUser;
  lblDateTime.Caption := Copy (FPaymentInfo.opphCreatedDate, 7, 2) + '/' +        // DD
                         Copy (FPaymentInfo.opphCreatedDate, 5, 2) + '/' +        // MM
                         Copy (FPaymentInfo.opphCreatedDate, 1, 4) + '  ' +       // YYYY
                         Copy (FPaymentInfo.opphCreatedTime, 1, 2) + ':' +        // HH
                         Copy (FPaymentInfo.opphCreatedDate, 3, 2);               // MM
  // Check for Credit Card Details before populating field
  If (FPaymentInfo.opphCreditCardType <> '') Or (FPaymentInfo.opphCreditCardNumber <> '') Or (FPaymentInfo.opphCreditCardExpiry <> '') Then
  Begin
    lblCreditCardDetails.Caption := FPaymentInfo.opphCreditCardType + ' ' +
                                    FPaymentInfo.opphCreditCardNumber + ' Exp ' +
                                    Copy (FPaymentInfo.opphCreditCardExpiry, 1, 2) + '/' +  // MM
                                    Copy (FPaymentInfo.opphCreditCardExpiry, 3, 2);         // YY
  End // If (FPaymentInfo.opphCreditCardType <> '') Or (FPaymentInfo.opphCreditCardNumber <> '') Or (FPaymentInfo.opphCreditCardExpiry <> '')
  Else
    lblCreditCardDetails.Caption := '';
  lblOriginalPaymentValue.Caption := FPaymentInfo.opphCurrencySymbol + Form_Real (FPaymentInfo.opphOriginalValue, 0, 2);
  lblTotalRefundValue.Caption := FPaymentInfo.opphCurrencySymbol + Form_Real (FPaymentInfo.opphRefundToDateValue, 0, 2);

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added RefundMode so dialog knows what behaviour to implement
  //lblNetPaymentValue.Caption := FPaymentInfo.opphCurrencySymbol + Form_Real (FPaymentInfo.opphNetValue, 0, 2);
  If (FPaymentInfo.opphPaymentInfoMode = pimInvoice) Then
    // Invoice - Show Matched Value
    lblNetPaymentValue.Caption := FPaymentInfo.opphCurrencySymbol + Form_Real (FPaymentInfo.opphMatchedValue, 0, 2)
  Else
    // Order - Show Outstanding Value
    lblNetPaymentValue.Caption := FPaymentInfo.opphCurrencySymbol + Form_Real (FPaymentInfo.opphOutstandingValue, 0, 2);

  // Load the payment lines into the listview
  For I := 0 To (FPaymentInfo.opphPaymentLineCount - 1) Do
  Begin
    PaymentLineIntf := FPaymentInfo.opphPaymentLines[I];

    Item := lvPaymentLines.Items.Add;
    With Item Do
    Begin
      //Checked := True;

      // Stock Code
      Caption := PaymentLineIntf.opplOrderLine.opolLine.StockCode;
      // Quantity
      SubItems.Add (Form_Real(PaymentLineIntf.opplOrderLine.opolLine.Qty, 0, Syss.NoQtyDec));
      // Description
      SubItems.Add (PaymentLineIntf.opplOrderLine.opolLine.Desc);
      // Unit Price - 2dp as it includes discounts so it isn't really a unit value any more so Sale Decs don't apply (Roger agreed)
      SubItems.Add (FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplOrderLine.opolUnitPrice, 0, 2));
      // Gross Line Total (Goods + VAT)
      SubItems.Add (FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplOrderLine.opolLineTotal, 0, 2));
      // Payment Value
      // MH 13/01/2015 v7.1 ABSEXCH-16022: Added RefundMode so dialog knows what behaviour to implement
      //SubItems.Add (FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplNetPaymentValue, 0, 2));
      // MH 28/01/2015 v7.1 ABSEXCH-16078: Modified to use the line fields instead of the header fields
      If (FPaymentInfo.opphPaymentInfoMode = pimInvoice) Then
        // Invoice - Show Matched Value
        SubItems.Add (FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplMatchedValue, 0, 2))
      Else
        // Order - Show Outstanding Value
        SubItems.Add (FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplUnmatchedValue, 0, 2));

      // Refund Value
      SubItems.Add (FPaymentInfo.opphCurrencySymbol + Form_Real(PaymentLineIntf.opplRefundValue, 0, 2));

      // Refund check-box
      Checked := PaymentLineIntf.opplRefundSelected;
    End;
  End; // For I

  // Force the totals to be updated
  For I := 0 to lvPaymentLines.Items.Count - 1 do
  begin
    Item := lvPaymentLines.Items[I];
    UpdateRowForCheckedState(Item);
  end;

  // Auto-select the first payment line
  If (lvPaymentLines.Items.Count > 0) Then
    lvPaymentLines.Selected := lvPaymentLines.Items[0];

  // Redirect the list view's WindowProc so we can detect the checkbox being changed
  OriginalListViewWindowProc := lvPaymentLines.WindowProc;
  lvPaymentLines.WindowProc := ListViewWindowProcEx;
End; // SetPaymentInfo

//-------------------------------------------------------------------------

procedure TframePaymentDetails.lblPaymentOurRefClick(Sender: TObject);
begin
  If (chkPayRef.State = cbUnchecked) Then
    chkPayRef.State := cbChecked
  Else
    chkPayRef.State := cbUnchecked;
end;

//-------------------------------------------------------------------------

procedure TframePaymentDetails.chkPayRefClick(Sender: TObject);
Var
  I : Integer;
begin
  // Run through the lines changing their state appropriately
  For I := 0 To (lvPaymentLines.Items.Count - 1) Do
  Begin
    If (chkPayRef.State = cbUnchecked) Then
      lvPaymentLines.Items[I].Checked := False
    Else If (chkPayRef.State = cbChecked) Then
      lvPaymentLines.Items[I].Checked := True;
    // Ignore gray state
  End; // For I
end;

//-------------------------------------------------------------------------

Function TframePaymentDetails.GetRefundRequired : Boolean;
Begin // GetRefundRequired
  Result := chkPayRef.Checked
End; // GetRefundRequired

//------------------------------

Function TframePaymentDetails.GetRefundGoods : Double;
Var
  I : Integer;
Begin // GetRefundGoods
  Result := 0.0;

  // Check the SRC is selected for refund
  If chkPayRef.Checked Then
  Begin
    // Run through the rows adding up the values
    For I := 0 To (FPaymentInfo.opphPaymentLineCount - 1) Do
    Begin
      If lvPaymentLines.Items[I].Checked Then
      Begin
        Result := Result + FPaymentInfo.opphPaymentLines[I].opplRefundGoods;
      End; // If lvPaymentLines.Items[I].Checked
    End; // For I
  End; // If chkPayRef.Checked
End; // GetRefundGoods

Function TframePaymentDetails.GetRefundVAT : Double;
Var
  I : Integer;
Begin // GetRefundVAT
  Result := 0.0;

  // Check the SRC is selected for refund
  If chkPayRef.Checked Then
  Begin
    // Run through the rows adding up the values
    For I := 0 To (FPaymentInfo.opphPaymentLineCount - 1) Do
    Begin
      If lvPaymentLines.Items[I].Checked Then
      Begin
        Result := Result + FPaymentInfo.opphPaymentLines[I].opplRefundVAT;
      End; // If lvPaymentLines.Items[I].Checked
    End; // For I
  End; // If chkPayRef.Checked
End; // GetRefundVAT

//-------------------------------------------------------------------------

procedure TframePaymentDetails.btnEditRefundClick(Sender: TObject);
Var
  frmOrderPaymentRefundLineQty : TfrmOrderPaymentRefundLineQty;
begin
  If Assigned(lvPaymentLines.Selected) Then
  Begin
    frmOrderPaymentRefundLineQty := TfrmOrderPaymentRefundLineQty.Create(Owner);
    Try
      // MH 16/12/2014 ABSEXCH-15940: Show the Manual VAT warning for transactions with Manual VAT enabled
      frmOrderPaymentRefundLineQty.ManualVAT := FManualVAT;
      frmOrderPaymentRefundLineQty.PaymentLine := FPaymentInfo.opphPaymentLines[lvPaymentLines.Selected.Index];
      frmOrderPaymentRefundLineQty.SetColours(lvPaymentLines.Font, lvPaymentLines.Color);

      If (frmOrderPaymentRefundLineQty.ShowModal = mrOK) Then
      Begin
        // Update the row
        lvPaymentLines.Selected.Checked := frmOrderPaymentRefundLineQty.PaymentLine.opplRefundSelected;
        UpdateRowForCheckedState (lvPaymentLines.Selected);
      End; // If (frmOrderPaymentRefundLineQty.ShowModal = mrOK)
    Finally
      frmOrderPaymentRefundLineQty.Free
    End; // Try..Finally
  End; // If Assigned(lvPaymentLines.Selected)
end;

//-------------------------------------------------------------------------

// Performs any required validation of the frame details
Function TframePaymentDetails.Validate : Boolean;
Begin // Validate
            // SRC must be selected for refund
  Result := GetRefundRequired And
            // Goods Value or VAT Value must be non-zero - VAT Value can be Zero for Zero Rated VAT - Not sure how Goods Value can be Zero
            ((GetRefundGoods <> 0.0) Or (GetRefundVAT <> 0.0));
End; // Validate

//=========================================================================

end.
