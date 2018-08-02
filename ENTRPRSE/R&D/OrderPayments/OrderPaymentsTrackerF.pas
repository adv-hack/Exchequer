unit OrderPaymentsTrackerF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvListV, StdCtrls, TEditVal, ExtCtrls, StrUtils, Math,
  GlobVar, VarConst, oOrderPaymentsTransactionInfo, OrderPaymentsInterfaces;

type
  TfrmObjectNorbert = class(TForm)
    panHeader: TPanel;
    panBody: TPanel;
    panFooter: TPanel;
    lblOrdered: Label8;
    Label81: Label8;
    lblDelivered: Label8;
    lblWrittenOff: Label8;
    lblOutstanding: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    ccyOrderedQty: TCurrencyEdit;
    ccyDeliveredQty: TCurrencyEdit;
    ccyWrittenOffQty: TCurrencyEdit;
    ccyOutstandingQty: TCurrencyEdit;
    ccyOrderedPaymentTotal: TCurrencyEdit;
    ccyDeliveredPaymentTotal: TCurrencyEdit;
    ccyOutstandingPaymentTotal: TCurrencyEdit;
    ccyOrderedPaymentQty: TCurrencyEdit;
    ccyDeliveredPaymentQty: TCurrencyEdit;
    ccyOutstandingPaymentQty: TCurrencyEdit;
    ccyOrderedGrossTotal: TCurrencyEdit;
    ccyDeliveredGrossTotal: TCurrencyEdit;
    ccyOutstandingGrossTotal: TCurrencyEdit;
    ccyWrittenOffGrossTotal: TCurrencyEdit;
    btnClose: TButton;
    lblUnpaidTotal: TLabel;
    lblTotalPaid: TLabel;
    lblGrossTotal: TLabel;
    Bevel1: TBevel;
    lvTransactionLines: TListView;
    ccyUnpaidTotal: TCurrencyEdit;
    ccyTotalPaid: TCurrencyEdit;
    ccyGrossTotal: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure lvTransactionLinesSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
  private
    { Private declarations }
    OrderPaymentsTransactionIntf : IOrderPaymentsTransactionInfo;

    // Records original Y position of the ccyDeliveredXXX fields so that they can be dynamically moved
    OrigDeliveredYPos : Integer;

    // Blank out the currency edit
    Procedure BlankCurrencyEditValue (Var ccyEdit : TCurrencyEdit);
    // Force the Currency Edit to display the specified value
    Procedure SetCurrencyEditValue (Var ccyEdit : TCurrencyEdit; Const CurrencySymbol : String; Const FieldValue : Double);

    // Clears down the Order Payment Payment Details
    Procedure ClearHeaderDetails;
    // Clears down the Line Totals fields
    Procedure ClearLineTotals;

    // Populates the Line Totals for the specified optTransactionLines Index
    Procedure LoadLineTotals(Const LineIndex : Integer);
  public
    { Public declarations }
    // Loads the Order Payment Payment Details for the supplied transaction
    Procedure LoadPaymentDetails(Const Transaction : InvRec);
  end;


// Displays the Order Payments Tracker window
Procedure DisplayOrderPaymentsTracker;

// Updates the Order Payments Tracker window for the specified transaction
Procedure UpdateOrderPaymentsTracker(Const Transaction : InvRec);

implementation

{$R *.dfm}

Uses ETStrU, ETMiscU,
     FormatFloatFuncs,  // FormatCurFloat
     BTSupU1;           // GenRealMask

Const
  BaseCaption = 'Order Payments Tracker';

//=========================================================================

// Looks for an existing instance of the Order Payments Tracker form
Function FindOrderPaymentsTracker : TfrmObjectNorbert;
var
  frmOrderPaymentsTracker : TfrmObjectNorbert;
  I : Integer;
Begin // FindOrderPaymentsTracker
  Result := NIL;

  // Look for an existing instance
  Try
    // Run through all the open MDI Children within EParentU
    For I := 0 To (Application.MainForm.MDIChildCount - 1) Do
    Begin
      // Look for an instance of the Order Payments Tracker window
      If (Application.MainForm.MDIChildren[I].ClassName = 'TfrmObjectNorbert') Then
      Begin
        frmOrderPaymentsTracker := TfrmObjectNorbert(Application.MainForm.MDIChildren[I]);
        If (Not (csDestroying In frmOrderPaymentsTracker.ComponentState)) Then
          Result := frmOrderPaymentsTracker;
      End; // If (Application.MainForm.MDIChildren[I].ClassName = 'TDaybk1')
    End; // For I
  Except
    // Bury any exceptions
    On e:Exception Do
      ;
  End; // Try..ExceptTry
End; // FindOrderPaymentsTracker

//-------------------------------------------------------------------------

// Displays the Order Payments Tracker window
Procedure DisplayOrderPaymentsTracker;
var
  frmOrderPaymentsTracker : TfrmObjectNorbert;
  CurrentForm : TForm;
Begin // DisplayOrderPaymentsTracker
  // Save a reference to the current active window
  CurrentForm := Application.MainForm.ActiveMDIChild;
  Try
    // Try to find an existing instance
    frmOrderPaymentsTracker := FindOrderPaymentsTracker;

    // If found then bring it to the front as it may be hidden
    If Assigned(frmOrderPaymentsTracker) Then
    Begin
      // If minimised then restore the window
      If (frmOrderPaymentsTracker.WindowState = wsMinimized) Then
        frmOrderPaymentsTracker.WindowState := wsNormal;

      // Bring it to the front as it may be behind another window
      If frmOrderPaymentsTracker.CanFocus Then
      Begin
        frmOrderPaymentsTracker.SetFocus;
        frmOrderPaymentsTracker.BringToFront;
      End; // If frmOrderPaymentsTracker.CanFocus
    End // If Assigned(frmOrderPaymentsTracker)
    Else
    Begin
      // If not found then create a new Order Payments Tracker window
      TfrmObjectNorbert.Create(Application.MainForm);    // MDI window so it will automatically show

      // See if the current global transaction qualifies for the tracker, if so automatically
      // show it
      If (Inv.InvDocHed In [SOR, SDN]) Then
        UpdateOrderPaymentsTracker(Inv);
    End; // Else
  Finally
    // Return focus back to where the user was at the start
    If Assigned(CurrentForm) Then
    Begin
      CurrentForm.SetFocus;
      CurrentForm.BringToFront;
    End; // If Assigned(CurrentForm)
  End; // Try..Finally
End; // DisplayOrderPaymentsTracker

//-------------------------------------------------------------------------

// Updates the Order Payments Tracker window for the specified transaction
Procedure UpdateOrderPaymentsTracker(Const Transaction : InvRec);
var
  frmOrderPaymentsTracker : TfrmObjectNorbert;
Begin // UpdateOrderPaymentsTracker
  // Try to find an existing instance
  frmOrderPaymentsTracker := FindOrderPaymentsTracker;
  If Assigned(frmOrderPaymentsTracker) Then
  Begin
    // Update the Tracker window for Order Payments Orders and Delivery Notes
    // clear down for anything else
    If (Transaction.thOrderPaymentElement In [opeOrder, opeDeliveryNote]) Then
      frmOrderPaymentsTracker.LoadPaymentDetails(Transaction)
    Else
    Begin
      frmOrderPaymentsTracker.ClearHeaderDetails;
      frmOrderPaymentsTracker.ClearLineTotals;
    End; // Else
  End; // If Assigned(frmOrderPaymentsTracker)
End; // UpdateOrderPaymentsTracker

//=========================================================================

procedure TfrmObjectNorbert.FormCreate(Sender: TObject);
begin
  ClientHeight := 322;
  ClientWidth := 569;

  // Position in top-right corner as default
  Top := 1;
  Left := Application.MainForm.ClientWidth - (Width + GetSystemMetrics(SM_CXHTHUMB) + 4);

  // Records original Y position of the ccyDeliveredXXX fields so that they can be dynamically moved
  OrigDeliveredYPos := ccyDeliveredQty.Top;

  // Set the Qty decimal places
  ccyOrderedQty.DecPlaces := Syss.NoQtyDec;
  ccyWrittenOffQty.DecPlaces := ccyOrderedQty.DecPlaces;
  ccyDeliveredQty.DecPlaces := ccyOrderedQty.DecPlaces;
  ccyOutstandingQty.DecPlaces := ccyOrderedQty.DecPlaces;

  // Clear out any design time values
  ClearHeaderDetails;
  ClearLineTotals;
end;

//------------------------------

procedure TfrmObjectNorbert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------

procedure TfrmObjectNorbert.FormDestroy(Sender: TObject);
begin
  OrderPaymentsTransactionIntf := NIL;
end;

//-------------------------------------------------------------------------

procedure TfrmObjectNorbert.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmObjectNorbert.lvTransactionLinesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  If Selected And Assigned(OrderPaymentsTransactionIntf) Then
    LoadLineTotals(Item.Index);
end;

//-------------------------------------------------------------------------

// Force the Currency Edit to display the specified value
Procedure TfrmObjectNorbert.SetCurrencyEditValue (Var ccyEdit : TCurrencyEdit; Const CurrencySymbol : String; Const FieldValue : Double);
Begin // SetCurrencyEditValue
  ccyEdit.BlankOnZero := False;
  ccyEdit.CurrencySymb := CurrencySymbol;
  ccyEdit.Value := FieldValue;
  If (ccyEdit.Text = '') Then
    // Force it to populate the text - required if FieldValue equals the previous value
    ccyEdit.FormatText;
End; // SetCurrencyEditValue

//------------------------------

// Blank out the currency edit
Procedure TfrmObjectNorbert.BlankCurrencyEditValue (Var ccyEdit : TCurrencyEdit);
Begin // SetCurrencyEditValue
  ccyEdit.BlankOnZero := True;
  ccyEdit.Value := 0.0;
  // Force it to populate the text - required if FieldValue equals the previous value
  ccyEdit.FormatText;
End; // SetCurrencyEditValue

//------------------------------

// Loads the Order Payment Payment Details for the supplied transaction
Procedure TfrmObjectNorbert.LoadPaymentDetails(Const Transaction : InvRec);
Var
  iLine : IOrderPaymentsTransactionLineInfo;
  Q : Double;
  I : Integer;
Begin // LoadPaymentDetails
  LockWindowUpdate(Self.Handle);
  Try
    // Create an Order Payments Transaction Info object for the current transaction
    OrderPaymentsTransactionIntf := OPTransactionInfo (Transaction);

    // Put the OurRef into the caption so the user can see which transaction the details are for
    Caption := BaseCaption + ': ' + Transaction.OurRef;

    // Check whether any warnings / notifications need to be shown
    If ((Transaction.thOrderPaymentFlags And thopfCreditCardAuthorisationTaken) = thopfCreditCardAuthorisationTaken) Then
    Begin
      panHeader.Caption := '*** Credit Card Payment Authentication was taken against this Order ***';
      panHeader.Visible := True;
    End // If (Transaction.thOrderPaymentFlags And thopfCreditCardAuthorisationTaken) = thopfCreditCardAuthorisationTaken)
    Else
      panHeader.Visible := False;

    // Update transaction level totals
    lblGrossTotal.Caption := IfThen(Transaction.InvDocHed = SOR, 'Order', 'Delivery') + ' Gross Total';
    SetCurrencyEditValue (ccyGrossTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(OrderPaymentsTransactionIntf.optTransactionTotal - OrderPaymentsTransactionIntf.optWriteOffTotal, 2));
    SetCurrencyEditValue (ccyTotalPaid, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyGrossTotal.Value - OrderPaymentsTransactionIntf.optOutstandingTotal, 2));
    SetCurrencyEditValue (ccyUnpaidTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, OrderPaymentsTransactionIntf.optOutstandingTotal);

    // Load lines from transaction
    lvTransactionLines.Items.Clear;
    For I := 0 To (OrderPaymentsTransactionIntf.optTransactionLineCount - 1) Do
    Begin
      iLine := OrderPaymentsTransactionIntf.optTransactionLines[I];

      With lvTransactionLines.Items.Add Do
      Begin
        // Stock Code
        Caption := Trim(iLine.optlTransactionLine.StockCode);
        // Quantity
        // MH 18/08/2015 2015-R1 ABSEXCH-16766: Don't populate the Qty/Value fields for description only lines
        Q := Round_Up(iLine.optlTransactionLine.Qty - iLine.optlTransactionLine.QtyWOff, Syss.NoQtyDec);
        SubItems.Add (IfThen (Q <> 0.0, Form_Real(Q, 0, Syss.NoQtyDec), ''));
        // Description
        SubItems.Add (Trim(iLine.optlTransactionLine.Desc));
        // Line Gross Total
        // MH 18/08/2015 2015-R1 ABSEXCH-16766: Don't populate the Qty/Value fields for description only lines
        SubItems.Add (IfThen (Q <> 0.0, FormatCurFloat(GenRealMask, iLine.optlLineTotal - iLine.optlWriteOffTotal, BOff, iLine.optlTransactionLine.Currency), ''));
        // Line Gross Payment Total
        // MH 18/08/2015 2015-R1 ABSEXCH-16766: Don't populate the Qty/Value fields for description only lines
        SubItems.Add (IfThen (Q <> 0.0, FormatCurFloat(GenRealMask, iLine.optlNetPaymentTotal, BOff, iLine.optlTransactionLine.Currency), ''));
      End; // With lvTransactionLines.Items.Add
    End; // For iLine
    iLine := NIL;

    // Show/Hide the fields that only apply to Orders
    lblOrdered.Visible := (OrderPaymentsTransactionIntf.optTransaction.InvDocHed = SOR);
    ccyOrderedQty.Visible := lblOrdered.Visible;
    ccyOrderedGrossTotal.Visible := lblOrdered.Visible;
    ccyOrderedPaymentTotal.Visible := lblOrdered.Visible;
    ccyOrderedPaymentQty.Visible := lblOrdered.Visible;

    lblWrittenOff.Visible := lblOrdered.Visible;
    ccyWrittenOffQty.Visible := lblOrdered.Visible;
    ccyWrittenOffGrossTotal.Visible := lblOrdered.Visible;

    lblOutstanding.Visible := lblOrdered.Visible;
    ccyOutstandingQty.Visible := lblOrdered.Visible;
    ccyOutstandingGrossTotal.Visible := lblOrdered.Visible;
    ccyOutstandingPaymentTotal.Visible := lblOrdered.Visible;
    ccyOutstandingPaymentQty.Visible := lblOrdered.Visible;

    // Move the Delivered fields up for Delivery Notes so we don't have a horrible gap between the titles and fields
    lblDelivered.Top := IfThen(lblOrdered.Visible, OrigDeliveredYPos + 3, lblOrdered.Top);
    ccyDeliveredQty.Top := lblDelivered.Top - 3;
    ccyDeliveredGrossTotal.Top := ccyDeliveredQty.Top;
    ccyDeliveredPaymentTotal.Top := ccyDeliveredQty.Top;
    ccyDeliveredPaymentQty.Top := ccyDeliveredQty.Top;

    // Resize the footer panel for Delivery Notes so we don't have a horrible gap below the Delivered fields
    panFooter.Height := IfThen(lblOrdered.Visible, ccyOutstandingQty.Top + ccyOutstandingQty.Height, ccyDeliveredQty.Top + ccyDeliveredQty.Height) + 6;

    // Automatically select the first line if we have any
    If (lvTransactionLines.Items.Count > 0) Then
    Begin
      lvTransactionLines.ItemIndex := 0;
      LoadLineTotals(0);
    End // If (lvTransactionLines.Items.Count > 0)
    Else
      // Remove any pre-existing line totals
      ClearLineTotals;
  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
End; // LoadPaymentDetails

//-------------------------------------------------------------------------

// Populates the Line Totals for the specified optTransactionLines Index
Procedure TfrmObjectNorbert.LoadLineTotals(Const LineIndex : Integer);
Var
  iLine : IOrderPaymentsTransactionLineInfo;
  DeliveryPayment, UnitPrice : Double;
Begin // LoadLineTotals
  iLine := OrderPaymentsTransactionIntf.optTransactionLines[LineIndex];
  Try
    // MH 18/08/2015 2015-R1 ABSEXCH-16766: Check to see if the line has a value before calculating
    // the totals - otherwise it crashes - clear out the totals if there is no value 
    If (iLine.optlLineTotal <> 0.0) And (iLine.optlTransactionLine.Qty <> 0.0) Then
    Begin
      // Calculate a Unit Price for calculating the Payment Qty
      UnitPrice := Round_Up(iLine.optlLineTotal / iLine.optlTransactionLine.Qty, 6);

      // Delivered totals
      DeliveryPayment := 0.0;
      If (OrderPaymentsTransactionIntf.optTransaction.InvDocHed = SOR) Then
      Begin
        // Order
        SetCurrencyEditValue (ccyDeliveredQty, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlTransactionLine.QtyDel);
        SetCurrencyEditValue (ccyDeliveredGrossTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyDeliveredQty.Value * UnitPrice, ccyDeliveredGrossTotal.DecPlaces));

        // Calculate the payment value which will be allocated to the Delivered Items
        If (ccyDeliveredQty.Value <> 0) Then
        Begin
          // Calculate the payment value required to cover all delivered items on this line, and then
          // check to see if that exceeds the payment made and reduce accordingly
          DeliveryPayment := Round_Up(ccyDeliveredQty.Value * UnitPrice, 2);
          If (DeliveryPayment > iLine.optlNetPaymentTotal) Then
            DeliveryPayment := iLine.optlNetPaymentTotal;
        End; // If (ccyDeliveredQty.Value <> 0)
        SetCurrencyEditValue (ccyDeliveredPaymentTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, DeliveryPayment);
      End // If (OrderPaymentsTransactionIntf.optTransaction.InvDocHed = SOR)
      Else
      Begin
        // Delivery Note - Line Qty
        SetCurrencyEditValue (ccyDeliveredQty, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlTransactionLine.Qty);
        SetCurrencyEditValue (ccyDeliveredGrossTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlLineTotal);
        SetCurrencyEditValue (ccyDeliveredPaymentTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlNetPaymentTotal);
      End; // Else
      If (ccyDeliveredPaymentTotal.Value <> 0.0) Then
        SetCurrencyEditValue (ccyDeliveredPaymentQty, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyDeliveredPaymentTotal.Value / UnitPrice, ccyDeliveredPaymentQty.DecPlaces))
      Else
        SetCurrencyEditValue (ccyDeliveredPaymentQty, OrderPaymentsTransactionIntf.optCurrencySymbol, 0.0);

      // Ordered totals
      If ccyOrderedQty.Visible Then
      Begin
        SetCurrencyEditValue (ccyOrderedQty, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlTransactionLine.Qty);
        SetCurrencyEditValue (ccyOrderedGrossTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlOrderLineTotal);
        SetCurrencyEditValue (ccyOrderedPaymentTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(iLine.optlNetPaymentTotal - DeliveryPayment, 2));
        If (ccyOrderedPaymentTotal.Value <> 0.0) Then
          SetCurrencyEditValue (ccyOrderedPaymentQty, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyOrderedPaymentTotal.Value / UnitPrice, ccyOrderedPaymentQty.DecPlaces))
        Else
          SetCurrencyEditValue (ccyOrderedPaymentQty, OrderPaymentsTransactionIntf.optCurrencySymbol, 0.0);
      End; // If ccyOrderedQty.Visible

      // Written Off totals
      If ccyWrittenOffQty.Visible Then
      Begin
        SetCurrencyEditValue (ccyWrittenOffQty, OrderPaymentsTransactionIntf.optCurrencySymbol, iLine.optlTransactionLine.QtyWOff);
        SetCurrencyEditValue (ccyWrittenOffGrossTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyWrittenOffQty.Value * UnitPrice, ccyWrittenOffGrossTotal.DecPlaces));
      End; // If ccyWrittenOffQty.Visible

      // Outstanding Totals
      If ccyOutstandingQty.Visible Then
      Begin
        SetCurrencyEditValue (ccyOutstandingQty, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyOrderedQty.Value - ccyDeliveredQty.Value - ccyWrittenOffQty.Value, ccyOutstandingQty.DecPlaces));
        SetCurrencyEditValue (ccyOutstandingGrossTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyOrderedGrossTotal.Value - ccyDeliveredGrossTotal.Value - ccyWrittenOffGrossTotal.Value, ccyOutstandingGrossTotal.DecPlaces));
        // Outstanding Payment Value = Line Total - Ordered Payment Total - Delivered Payment Total
        SetCurrencyEditValue (ccyOutstandingPaymentTotal, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyOrderedGrossTotal.Value - ccyOrderedPaymentTotal.Value - ccyDeliveredPaymentTotal.Value, 2));
        If (ccyOutstandingPaymentTotal.Value <> 0.0) Then
          SetCurrencyEditValue (ccyOutstandingPaymentQty, OrderPaymentsTransactionIntf.optCurrencySymbol, Round_Up(ccyOutstandingPaymentTotal.Value / UnitPrice, ccyOutstandingPaymentQty.DecPlaces))
        Else
          SetCurrencyEditValue (ccyOutstandingPaymentQty, OrderPaymentsTransactionIntf.optCurrencySymbol, 0.0);
      End; // If ccyOutstandingQty.Visible
    End // iLine.optlTransactionLine.Qty
    Else
      ClearLineTotals;
  Finally
    iLine := NIL;
  End; // Try..Finallytry
End; // LoadLineTotals

//-------------------------------------------------------------------------

// Clears down the Order Payment Payment Details
Procedure TfrmObjectNorbert.ClearHeaderDetails;
Begin // ClearPaymentDetails
  // Remove previous OurRef from caption
  Caption := BaseCaption;

  // Hide any warnings
  panHeader.Visible := False;

  // Remove any previous stock lines
  lvTransactionLines.Items.Clear;

  // Blank out the totals / info to prevent the user mistakenly thinking they apply to a
  // non-Order Payments transaction that they have moved to.
  BlankCurrencyEditValue (ccyGrossTotal);
  BlankCurrencyEditValue (ccyTotalPaid);
  BlankCurrencyEditValue (ccyUnpaidTotal);
End; // ClearPaymentDetails

//------------------------------

// Clears down the Line Totals fields
Procedure TfrmObjectNorbert.ClearLineTotals;
Begin // ClearLineTotals
  // Blank out the totals / info to prevent the user mistakenly thinking they apply to a
  // non-Order Payments transaction that they have moved to.
  BlankCurrencyEditValue (ccyOrderedQty);
  BlankCurrencyEditValue (ccyOrderedGrossTotal);
  BlankCurrencyEditValue (ccyOrderedPaymentTotal);
  BlankCurrencyEditValue (ccyOrderedPaymentQty);

  BlankCurrencyEditValue (ccyWrittenOffQty);
  BlankCurrencyEditValue (ccyWrittenOffGrossTotal);

  BlankCurrencyEditValue (ccyDeliveredQty);
  BlankCurrencyEditValue (ccyDeliveredGrossTotal);
  BlankCurrencyEditValue (ccyDeliveredPaymentTotal);
  BlankCurrencyEditValue (ccyDeliveredPaymentQty);

  BlankCurrencyEditValue (ccyOutstandingQty);
  BlankCurrencyEditValue (ccyOutstandingGrossTotal);
  BlankCurrencyEditValue (ccyOutstandingPaymentTotal);
  BlankCurrencyEditValue (ccyOutstandingPaymentQty);
End; // ClearLineTotals

//=========================================================================

end.
