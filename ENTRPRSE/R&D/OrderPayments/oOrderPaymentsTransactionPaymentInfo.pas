Unit oOrderPaymentsTransactionPaymentInfo;

Interface

Uses OrderPaymentsInterfaces, GlobVar, VarConst;

// Creates and returns a new instance of the IOrderPaymentsTransactionPaymentInfo which details
// the transactions payments position in the Order Payments subsystem
// MH 13/01/2015 v7.1 ABSEXCH-16022: Added RefundMode so objects knows what behaviour to implement
Function OPTransactionPaymentInfo (Const Transaction : InvRec; Const Mode : TOrderPaymentsTransactionPaymentInfoMode = pimAuto) : IOrderPaymentsTransactionPaymentInfo;

Implementation

Uses Types, Classes, SysUtils, DB, Dialogs, SQLUtils,
     oOrderPaymentsBaseTransactionInfo,
     oOPVATPayBtrieveFile,
     oOPVATPayMemoryList,
     BtrvU2, ExBTTH1U, BTKeys1U,
     SQLCallerU,
     SQLTransactionLines,
     BTSupU1,                // GetVATNo
     MiscU,                  // InvLTotal
     CurrncyU,               // SSymb
     ComnUnit,               // ITotal
     Math,
     MathUtil,
     ETMiscU,
     ETStrU,
     SysU2,
     ADOConnect;

Type
  pInvRec = ^InvRec;

  ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal = Interface
    ['{0B27C06F-0F39-4423-8C9E-7E9AA145679C}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    Procedure RegisterPayment(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
    Procedure RegisterRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
  End; // ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal

  //------------------------------

  TOrderPaymentsTransactionPaymentInfoOrderLine = Class(TInterfacedObject, IOrderPaymentsTransactionPaymentInfoOrderLine, ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal)
  Private
    FOrderHeader : pInvRec;
    FOrderLine : IDetail;

    // Running total of payment position for this order line
    FPaymentGoods : Double;
    FPaymentVAT : Double;

    // CJS 2014-09-03 - T039 - Detect refund requirement
    FOrderGoodsExcludingWriteOffs: Double;
    FOrderVATExcludingWriteOffs: Double;

    // ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal methods -----------------------
    Procedure RegisterPayment(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
    Procedure RegisterRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);

    // IOrderPaymentsTransactionPaymentInfoOrderLine methods ---------------------------------
    Function GetLine : IDetail;
    Function GetVATType : VATType;
    Function GetUnitPrice : Double;
    Function GetLineTotal : Double;

    Function GetNetPaymentTotal : Double;
    Function GetNetPaymentGoods : Double;
    Function GetNetPaymentVAT : Double;

    // CJS 2014-09-03 - T039 - Detect refund requirement
    Function GetOrderGoodsExcludingWriteOffs: Double;
    Function GetOrderVATExcludingWriteOffs: Double;
    Procedure CalculateValuesExcludingWriteOffs(IncludePicked: Boolean);

  Public
    Constructor Create (Const OrderHeader : pInvRec; Const OrderLine : IDetail);
  End; // TOrderPaymentsTransactionPaymentInfoOrderLine

  //------------------------------

  // Private interface for accessing non-public functionality in the TOrderPaymentsTransactionPaymentInfoPaymentLine class
  ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal = Interface
    ['{9C0B1C24-3054-4951-8D32-3D829C3986B5}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    Procedure ApplyRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
    Procedure ApplyMatching(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
    // Methods to update the internal RefundGoods and RefundVAT values
    Procedure SetRefundGoods(Value: Double);
    Procedure SetRefundVAT(Value: Double);
  End; // ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal

  //------------------------------

  TOrderPaymentsTransactionPaymentInfoPaymentLine = Class(TInterfacedObject, IOrderPaymentsTransactionPaymentInfoPaymentLine, ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal)
  Private
    FVATPayDetails : OrderPaymentsVATPayDetailsRecType;
    FOrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine;

    FRefundsToDateGoods : Double;
    FRefundsToDateVAT : Double;

    FRefundSelected : Boolean;
    FRefundGoods : Double;
    FRefundVAT : Double;

    FMatchedGoods : Double;
    FMatchedVAT : Double;

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
    FPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;

    // ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal methods -----------------------
    Procedure ApplyRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
    Procedure ApplyMatching(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);

    // Methods to update the internal RefundGoods and RefundVAT values
    Procedure SetRefundGoods(Value: Double);
    Procedure SetRefundVAT(Value: Double);

    // IOrderPaymentsTransactionPaymentInfoPaymentLine methods ---------------------------------
    Function GetOrderLine : IOrderPaymentsTransactionPaymentInfoOrderLine;
    Function GetCurrencySymbol : ShortString;

    Function GetDescription: ShortString;
    Function GetReceiptReference: ShortString;

    Function GetNetPaymentValue : Double;
    Function GetNetPaymentGoods : Double;
    Function GetNetPaymentVAT : Double;

    Function GetRefundToDateValue : Double;

    Function GetRefundSelected : Boolean;
    Procedure SetRefundSelected(Value : Boolean);
    Function GetRefundValue : Double;
    Procedure SetRefundValue (Value : Double);
    Function GetRefundGoods : Double;
    Function GetRefundVAT : Double;

    Function GetMatchedValue : Double;
    Function GetMatchedGoods : Double;
    Function GetMatchedVAT : Double;
    Function GetUnmatchedValue : Double;
    Function GetUnmatchedGoods : Double;
    Function GetUnmatchedVAT : Double;

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Function GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
  Public
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Constructor Create (Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                        Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine;
                        Const PaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode);
  End; // TOrderPaymentsTransactionPaymentInfoPaymentLine

  //------------------------------

  // Private interface for accessing non-public functionality in the TOrderPaymentsTransactionPaymentInfoPaymentHeader class
  ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal = Interface
    ['{194D4B55-270A-435A-992B-09F94A1FF927}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    Procedure AddPaymentDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
    Function CullPaymentLines : Boolean;
    Procedure ProcessRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                            Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
      Procedure ProcessMatching(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                              Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
  End; // ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal

  //------------------------------

  TOrderPaymentsTransactionPaymentInfoPaymentHeader = Class(TInterfacedObject, IOrderPaymentsTransactionPaymentInfoPaymentHeader, ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal)
  Private
    FExLocal : TdPostExLocalPtr;
    FPaymentSRC : InvRec;
    FVATPayDetails : OrderPaymentsVATPayDetailsRecType;
    FPaymentLines : TInterfaceList;

    // MH 27/10/2014 ABSEXCH-15769: Added header level total of Refunds To Date
    FRefundGoodsToDate : Double;
    FRefundVATToDate : Double;

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
    FPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;

    // Load SRC Details
    Procedure LoadSRC;

    // ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal methods -----------------------
    Procedure AddPaymentDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
    Function CullPaymentLines : Boolean;
    Procedure ProcessRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                            Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
    Procedure ProcessMatching(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                              Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);

    // IOrderPaymentsTransactionPaymentInfoPaymentHeader methods ---------------------------------
    Function GetPayment : InvRec;
    Function GetOurRef : ShortString;
    Function GetPaymentOurRef: ShortString;
    Function GetPaymentType: enumOrderPaymentsVATPayDetailsType;
    Function GetCurrencySymbol : ShortString;
    Function GetUser : ShortString;
    Function GetCreatedDate : ShortString;
    Function GetCreatedTime : ShortString;
    Function GetCreditCardType : ShortString;
    Function GetCreditCardNumber : ShortString;
    Function GetCreditCardExpiry : ShortString;

    Function GetOriginalValue : Double;
    Function GetRefundToDateValue : Double;
    Function GetRefundValue : Double;
    Function GetNetValue : Double;
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added Outstanding/Matched totals for Refund dialog
    Function GetOutstandingValue : Double;
    Function GetMatchedValue : Double;

    Function GetPaymentLineCount : Integer;
    Function GetPaymentLine (Index : Integer) : IOrderPaymentsTransactionPaymentInfoPaymentLine;

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Function GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
  Public
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
    Constructor Create(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                       Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine;
                       Const PaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
                       Const ExLocal :  TdPostExLocalPtr);
    Destructor Destroy; Override;
  End; // TOrderPaymentsTransactionPaymentInfoPaymentHeader

  //------------------------------

  TOrderPaymentsTransactionPaymentInfo = Class(TOrderPaymentsBaseTransactionInfo, IOrderPaymentsTransactionPaymentInfo)
  Private
    FOrderLines : TInterfaceList;
    FPayments : TInterfaceList;

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
    FPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;

    // Returns the index of the specified Line, -1 if not found
    Function FindOrderLineByABSLineNo (Const ABSLineNo : Integer) : Integer;

    // Returns the index of the specified payment, -1 if not found
    Function FindPaymentByOurRef (Const PaymentRef : ShortString) : Integer;

    // Runs through OpVATPay and loads any payments against the SOR / SIN
    Procedure LoadPayments; Virtual; Abstract;

    // Adds a payment into the internal payments list
    Procedure AddPaymentDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);

    // Remove any zero value payments/lines, i.e. lines which have been refunded already
    Procedure CullPayments;

    // TOrderPaymentsBaseTransactionInfo methods ---------------------------------
    // Processes an Order Line loaded by LoadTransactionLines
    Procedure ProcessOrderLine (Const OrderLine : IDetail); Override;


    // IOrderPaymentsTransactionPaymentInfo methods -------------------------------
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Function GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;

    Function GetOrderLineCount : Integer;
    Function GetOrderLines (Index : Integer) : IOrderPaymentsTransactionPaymentInfoOrderLine;

    Function GetPaymentCount : Integer;
    Function GetPayment (Index : Integer) : IOrderPaymentsTransactionPaymentInfoPaymentHeader;

    // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
    Function GetOrder : InvRec;

    // Returns TRUE if a refund can be given against the current transaction
    Function CanGiveRefund : Boolean;

    // CJS 2014-09-03 - T039 - Detect refund requirement
    // Returns TRUE if the current value of the transaction is less than the
    // payment value against it. If IncludePicked is True it will also include
    // lines which are Picked Written-Off, as opposed to only including lines
    // which are actually written-off.
    Function NeedsRefund(IncludePicked: Boolean): Boolean;

    function FindPaymentFromRefundMatch(const SRCRef : string) : string; virtual; abstract;

    // Applies any refund amounts (detected by NeedRefund) to the Payment
    // Lines, ready for use by the Refund dialog.
    Procedure AssignRefundToLines(
      PaymentHeader: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
      OrderLine: IOrderPaymentsTransactionPaymentInfoOrderLine;
      var RefundGoods: Double;
      var RefundVAT: Double
    );

  Public
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
    Constructor Create (Const Transaction : InvRec; Const Mode : TOrderPaymentsTransactionPaymentInfoMode);
    Destructor Destroy; Override;
  End; // TOrderPaymentsTransactionPaymentInfo

  //------------------------------

  TOrderPaymentsTransactionPaymentInfo_MSSQL = Class(TOrderPaymentsTransactionPaymentInfo)
  Private
    // TOrderPaymentsTransactionPaymentInfo methods ----------------
    // Runs through OpVATPay and loads any payments against the SOR / SIN
    Procedure LoadPayments; Override;

    // TOrderPaymentsBaseTransactionInfo methods ------------------
    // Loads the Transaction Lines for optTransaction and calculates the Goods values
    Procedure LoadTransactionLines; Override;

    //From the refund SRC on a refund matching record, find the SRC which it refunds
    function FindPaymentFromRefundMatch(const SRCRef : string) : string; override;
  End; // TOrderPaymentsTransactionPaymentInfo_MSSQL

  //------------------------------

  TOrderPaymentsTransactionPaymentInfo_Pervasive = Class(TOrderPaymentsTransactionPaymentInfo)
  Private
    // TOrderPaymentsTransactionPaymentInfo methods ----------------
    // Runs through OpVATPay and loads any payments against the SOR / SIN
    Procedure LoadPayments; Override;

    // TOrderPaymentsBaseTransactionInfo methods ------------------
    // Loads the Transaction Lines for optTransaction and calculates the Goods values
    Procedure LoadTransactionLines; Override;


    //From the refund SRC on a refund matching record, find the SRC which it refunds
    function FindPaymentFromRefundMatch(const SRCRef : string) : string; override;
  End; // TOrderPaymentsTransactionPaymentInfo_Pervasive


//=========================================================================

// Creates and returns a new instance of the IOrderPaymentsTransactionRefundInfo which details
// the transactions payments position in the Order Payments subsystem
// MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
Function OPTransactionPaymentInfo (Const Transaction : InvRec; Const Mode : TOrderPaymentsTransactionPaymentInfoMode = pimAuto) : IOrderPaymentsTransactionPaymentInfo;
Var
  LocalMode : TOrderPaymentsTransactionPaymentInfoMode;
Begin // OPTransactionPaymentInfo
  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so objects knows what behaviour to implement
  If (Mode = pimAuto) Then
  Begin
    If (Transaction.InvDocHed = SIN) Then
      LocalMode := pimInvoice
    Else
      LocalMode := pimOrder;
  End // If (Mode = pimAuto)
  Else
    LocalMode := Mode;

  If SQLUtils.UsingSQL Then
    Result := TOrderPaymentsTransactionPaymentInfo_MSSQL.Create (Transaction, LocalMode)
  Else
    Result := TOrderPaymentsTransactionPaymentInfo_Pervasive.Create (Transaction, LocalMode);
End; // OPTransactionPaymentInfo

//=========================================================================

Constructor TOrderPaymentsTransactionPaymentInfoOrderLine.Create (Const OrderHeader : pInvRec; Const OrderLine : IDetail);
Begin // Create
  Inherited Create;
  FOrderHeader := OrderHeader;
  FOrderLine := OrderLine;

  FPaymentGoods := 0.0;
  FPaymentVAT := 0.0;
End; // Create

//-------------------------------------------------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoOrderLine.RegisterPayment(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
Begin // RegisterPayment
  FPaymentGoods := FPaymentGoods + VATPayDetails.vpGoodsValue;
  FPaymentVAT := FPaymentVAT + VATPayDetails.vpVATValue;
End; // RegisterPayment

//------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoOrderLine.RegisterRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
Begin // RegisterRefund
  FPaymentGoods := FPaymentGoods - VATPayDetails.vpGoodsValue;
  FPaymentVAT := FPaymentVAT - VATPayDetails.vpVATValue;
End; // RegisterRefund

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetNetPaymentTotal : Double;
Begin // GetNetPaymentTotal
  Result := GetNetPaymentGoods + GetNetPaymentVAT
End; // GetNetPaymentTotal

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetNetPaymentGoods : Double;
Begin // GetNetPaymentGoods
  Result := FPaymentGoods;
End; // GetNetPaymentGoods

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetNetPaymentVAT : Double;
Begin // GetNetPaymentVAT
  Result := FPaymentVAT;
End; // GetNetPaymentVAT

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetLine : IDetail;
Begin // GetLine
  Result := FOrderLine;
End; // GetLine

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetVATType : VATType;
Begin // GetVATType
  Result := GetVATNo(FOrderLine.VATCode, FOrderLine.VATIncFlg);
End; // GetVATType

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetUnitPrice : Double;
Var
  LocalLine : IDetail;
Begin // GetUnitPrice
  // To calculate the Unit Price after discounts we calculate the line total using the
  // standard routine, but with a line quantity of 1.0
  LocalLine := FOrderLine;
  LocalLine.Qty := 1.0;
  Result := Round_Up (InvLTotal (LocalLine, BOn, (FOrderHeader^.DiscSetl * Ord(FOrderHeader^.DiscTaken))), 2)
End; // GetUnitPrice

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoOrderLine.GetLineTotal : Double;
Begin // GetLineTotal
  Result := Round_Up (InvLTotal (FOrderLine, BOn, (FOrderHeader^.DiscSetl * Ord(FOrderHeader^.DiscTaken))) + FOrderLine.VAT, 2)
End; // GetLineTotal

//------------------------------

// CJS 2014-09-03 - T039 - Detect refund requirement
procedure TOrderPaymentsTransactionPaymentInfoOrderLine.CalculateValuesExcludingWriteOffs(IncludePicked: Boolean);
Var
  TempLine : IDetail;
Begin
//  If (FOrderLine.QtyWOFF <> 0.0) Then
  Begin
    // Create a fake line for the Written Off quantity and recalculate the totals
    TempLine := FOrderLine;

    // CJS 2015-07-06 - ABSEXCH-16357 - Auto Write function not detecting refunds
    if IncludePicked and (Cust.SOPAutoWOff) then
    begin
      with TempLine do
      begin
        QtyDel  := QtyDel + QtyPick;
        QtyWOff := QtyWOff + QtyPWOff;

        If (Qty_OS(TempLine) <> 0) then
          // Write-off remaining quantity
          QtyWOff := QtyWOff + Qty_OS(TempLine);
      end;
    end;

    if (IncludePicked and (TempLine.QtyPWoff > 0)) then
      // MH 16/12/2014 ABSEXCH-15938: Modified to include Written Off Qty
      TempLine.Qty := TempLine.Qty - TempLine.QtyWOff - TempLine.QtyPWOff
    else
      TempLine.Qty := TempLine.Qty - TempLine.QtyWOff;
    FOrderGoodsExcludingWriteOffs := Round_Up (InvLTotal (TempLine, True, (FOrderHeader.DiscSetl * Ord(FOrderHeader.DiscTaken))), 2);

    CalcVAT(TempLine, FOrderHeader.DiscSetl);
    FOrderVATExcludingWriteOffs := TempLine.VAT;
  End;
end;

//------------------------------

function TOrderPaymentsTransactionPaymentInfoOrderLine.GetOrderGoodsExcludingWriteOffs: Double;
begin
  Result := FOrderGoodsExcludingWriteOffs;
end;

//------------------------------

function TOrderPaymentsTransactionPaymentInfoOrderLine.GetOrderVATExcludingWriteOffs: Double;
begin
  Result := FOrderVATExcludingWriteOffs;
end;

//=========================================================================

Constructor TOrderPaymentsTransactionPaymentInfoPaymentLine.Create (Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                                                    Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine;
                                                                    Const PaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode);
Begin // Create
  Inherited Create;

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  FPaymentInfoMode := PaymentInfoMode;

  FVATPayDetails := VATPayDetails;
  FOrderLineIntf := OrderLineIntf;

  // running total of existing refunds against this payment line
  FRefundsToDateGoods := 0.0;
  FRefundsToDateVAT := 0.0;

  FRefundSelected := False;
  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  If (FPaymentInfoMode = pimOrder) Then
  Begin
    // Default to full refund
    FRefundGoods := FVATPayDetails.vpGoodsValue;
    FRefundVAT := FVATPayDetails.vpVATValue;
  End // If (FPaymentInfoMode = pimOrder)
  Else
  Begin
    // Order Write-Offs will be driven externally
	// Invoice Refunds will be driven by matching
    FRefundGoods := 0.0;
    FRefundVAT := 0.0;
  End; // Else

  // Matched value running totals
  FMatchedGoods := 0.0;
  FMatchedVAT := 0.0;
End; // Create

//-------------------------------------------------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoPaymentLine.ApplyRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
Begin // ApplyRefund
  // Update running total of refunds against this payment line
  FRefundsToDateGoods := Round_Up(FRefundsToDateGoods + VATPayDetails.vpGoodsValue, 2);
  FRefundsToDateVAT := Round_Up(FRefundsToDateVAT + VATPayDetails.vpVATValue, 2);

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  If (FPaymentInfoMode = pimOrder) Then
  Begin
    // MH 26/09/2014 ABSEXCH-15675: Corrected RefundGoods/VAT calculation as it was previously using
    //                              the Goods/VAT from each refund record instead of the running total
    //                              which was causing the default refund value to only take into account
    //                              the last refund.
    // Update default refund values to take the refund details into account
    FRefundGoods := Round_Up(FVATPayDetails.vpGoodsValue - FRefundsToDateGoods - FMatchedGoods, 2);
    FRefundVAT := Round_Up(FVATPayDetails.vpVATValue - FRefundsToDateVAT - FMatchedVAT, 2);
  End; // If (FPaymentInfoMode = pimOrder)
End; // ApplyRefund

//-------------------------------------------------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoPaymentLine.ApplyMatching(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
Begin // ApplyMatching
  // Update running totals of matched value
  FMatchedGoods := Round_Up(FMatchedGoods + VATPayDetails.vpGoodsValue, 2);
  FMatchedVAT := Round_Up(FMatchedVAT + VATPayDetails.vpVATValue, 2);

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  If (FPaymentInfoMode = pimOrder) Then
  Begin
    // Default to refunding the outstanding value
    FRefundGoods := Round_Up(FVATPayDetails.vpGoodsValue - FRefundsToDateGoods - FMatchedGoods, 2);
    FRefundVAT := Round_Up(FVATPayDetails.vpVATValue - FRefundsToDateVAT - FMatchedVAT, 2);
  End // If (FPaymentInfoMode = pimOrder)
  Else If (FPaymentInfoMode = pimInvoice) Then
  Begin
    // Default to refunding the matched value for invoices
    FRefundGoods := FMatchedGoods;
    FRefundVAT := FMatchedVAT;
  End; // If (FPaymentInfoMode = pimInvoice)
End; // ApplyMatching

//-------------------------------------------------------------------------

procedure TOrderPaymentsTransactionPaymentInfoPaymentLine.SetRefundGoods(
  Value: Double);
begin
  FRefundGoods := Value;
end;

//-------------------------------------------------------------------------

procedure TOrderPaymentsTransactionPaymentInfoPaymentLine.SetRefundVAT(
  Value: Double);
begin
  FRefundVAT := Value;
end;

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetOrderLine : IOrderPaymentsTransactionPaymentInfoOrderLine;
Begin // GetOrderLine
  Result := FOrderLineIntf;
End; // GetOrderLine

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetCurrencySymbol : ShortString;
Begin // GetCurrencySymbol
  Result := SSymb(FVATPayDetails.vpCurrency);
End; // GetCurrencySymbol

//------------------------------

function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetDescription: ShortString;
begin
  Result := FVATPayDetails.vpDescription;
end;

//------------------------------

function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetReceiptReference: ShortString;
begin
  Result := FVATPayDetails.vpReceiptRef;
end;

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetNetPaymentValue : Double;
Begin // GetNetPaymentValue
  Result := Round_Up(GetNetPaymentGoods + GetNetPaymentVAT, 2);
End; // GetNetPaymentValue

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetNetPaymentGoods : Double;
Begin // GetNetPaymentGoods
  Result := Round_Up(FVATPayDetails.vpGoodsValue - FRefundsToDateGoods, 2);
End; // GetNetPaymentGoods

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetNetPaymentVAT : Double;
Begin // GetNetPaymentVAT
  Result := Round_Up(FVATPayDetails.vpVATValue - FRefundsToDateVAT, 2);
End; // GetNetPaymentVAT

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetRefundToDateValue : Double;
Begin // GetRefundToDateValue
  Result := Round_Up(FRefundsToDateGoods + FRefundsToDateVAT, 2);
End; // GetRefundToDateValue

//------------------------------

(*
// Calculates the Maximum Quantity of items that can be refunded (Net Payment / (Unit Price + Unit VAT) to Qty Decs)
Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetMaxRefundQuantity : Double;
Var
  GrossUnitPrice, QtyDivisor : Double;
  I : Integer;
Begin // GetMaxRefundQuantity
  // ABSEXCH-15600: If the line is fully paid then return the line Qty as a Refund Quantity
  // to avoid rounding errors caused by the Gross Unit Price rounding differences
  If (GetNetPaymentValue = FOrderLineIntf.opolLineTotal) Then
    Result := FOrderLineIntf.opolLine.Qty
  Else
  Begin
    // Calculate maximum Refund Qty available
    QtyDivisor := 1;
    For I := 1 To Syss.NoQtyDec Do
      QtyDivisor := QtyDivisor * 10;

    // Calculate Gross unit price
    GrossUnitPrice := Round_Up(FOrderLineIntf.opolUnitPrice + FOrderLineIntf.opolUnitVAT, 2);

    // Divide the Net Payment value (Goods + VAT) by the Gross Unit Price (Goods + VAT) and TRUNC to work out how many can be refunded
    Result := Round_Up(Trunc((GetNetPaymentValue / GrossUnitPrice) * QtyDivisor) / QtyDivisor, Syss.NoQtyDec);
  End; // Else
End; // GetMaxRefundQuantity
*)

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetRefundSelected : Boolean;
Begin // GetRefundSelected
  Result := FRefundSelected
End; // GetRefundSelected
Procedure TOrderPaymentsTransactionPaymentInfoPaymentLine.SetRefundSelected(Value : Boolean);
Begin // SetRefundSelected
  FRefundSelected := Value;
End; // SetRefundSelected

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetRefundValue : Double;
Begin // GetRefundValue
  Result := Round_Up(FRefundGoods + FRefundVAT, 2);
End; // GetRefundValue
Procedure TOrderPaymentsTransactionPaymentInfoPaymentLine.SetRefundValue (Value : Double);
Var
  VATRate : Double;
Begin // SetRefundValue
  // The Payment Total consists of payment for Goods + VAT - we need to split that out into
  // separate Goods + VAT fields as we need to know exactly how much VAT to declare for the payments.
  If (Value >= GetNetPaymentValue) Then
  Begin
    // Full Payment - use Line Goods/VAT figure
    FRefundGoods := GetNetPaymentGoods;
    FRefundVAT := GetNetPaymentVAT;
  End // If (Value >= GetNetPaymentValue)
  Else
  Begin
    // Part payment - work out VAT included in the payment using the VAT Rate

    // Get VAT Rate for VAT Code/Inclusive VAT Code, e.g. 'S' = 0.2
    VATRate := SyssVAT^.VATRates.VAT[GetVATNo(FVATPayDetails.vpVATCode, #0)].Rate;

    // Calculate the inclusive VAT Element
    FRefundVAT := Round_Up((Value / (1 + VATRate)) * VATRate, 2);
    If (FRefundVAT > GetNetPaymentVAT) Then
      FRefundVAT := GetNetPaymentVAT;

    // Treat remainder of payment as the Goods value to ensure it adds up
    FRefundGoods := Round_Up(Value - FRefundVAT, 2);
    If (FRefundGoods > GetNetPaymentGoods) Then
      FRefundGoods := GetNetPaymentGoods;
  End; // Else
End; // SetRefundValue

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetRefundGoods : Double;
Begin // GetRefundGoods
  Result := FRefundGoods;
End; // GetRefundGoods

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetRefundVAT : Double;
Begin // GetRefundVAT
  Result := FRefundVAT;
End; // GetRefundVAT

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetMatchedValue : Double;
Begin // GetMatchedValue
  Result := Round_Up(GetMatchedGoods + GetMatchedVAT, 2);
End; // GetMatchedValue

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetMatchedGoods : Double;
Begin // GetMatchedGoods
  Result := FMatchedGoods;
End; // GetMatchedGoods

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetMatchedVAT : Double;
Begin // GetMatchedVAT
  Result := FMatchedVAT;
End; // GetMatchedVAT

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetUnmatchedValue : Double;
Begin // GetUnmatchedValue
  Result := Round_Up(GetNetPaymentValue - GetMatchedValue, 2);
End; // GetUnmatchedValue

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetUnmatchedGoods : Double;
Begin // GetUnmatchedGoods
  Result := Round_Up(GetNetPaymentGoods - GetMatchedGoods, 2);
End; // GetUnmatchedGoods

Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetUnmatchedVAT : Double;
Begin // GetUnmatchedVAT
  Result := Round_Up(GetNetPaymentVAT - GetMatchedVAT, 2);
End; // GetUnmatchedVAT

//-------------------------------------------------------------------------

// MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
Function TOrderPaymentsTransactionPaymentInfoPaymentLine.GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
Begin // GetPaymentInfoMode
  Result := FPaymentInfoMode;
End; // GetPaymentInfoMode

//=========================================================================

Constructor TOrderPaymentsTransactionPaymentInfoPaymentHeader.Create(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                                                     Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine;
                                                                     Const PaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
                                                                     Const ExLocal :  TdPostExLocalPtr);
Begin // Create
  Inherited Create;

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  FPaymentInfoMode := PaymentInfoMode;

  FExLocal := ExLocal;

  FPaymentLines := TInterfaceList.Create;

  // Record initial details for commonproperties
  FVATPayDetails := VATPayDetails;
  AddPaymentDetails(VATPayDetails, OrderLineIntf);

  // Load SRC Details
  FillChar(FPaymentSRC, SizeOf(FPaymentSRC), #0);
  LoadSRC;

  // MH 27/10/2014 ABSEXCH-15769: Added header level total of Refunds To Date
  FRefundGoodsToDate := 0.0;
  FRefundVATToDate := 0.0;
End; // Create

Destructor TOrderPaymentsTransactionPaymentInfoPaymentHeader.Destroy;
Begin // Destroy
  FPaymentLines.Clear;
  FreeAndNIL(FPaymentLines);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Load SRC Details
Procedure TOrderPaymentsTransactionPaymentInfoPaymentHeader.LoadSRC;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadSRC
  sKey := FullOurRefKey (FVATPayDetails.vpReceiptRef);
  iStatus := FExLocal.LFind_Rec (B_GetEq, InvF, InvOurRefK, sKey);
  If (iStatus = 0) Then
    FPaymentSRC := FExLocal.LInv;

  // Error Handling? It shouldn't ever fail to find the order, unless the data is borked

End; // LoadSRC

//-------------------------------------------------------------------------

// MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
Begin // GetPaymentInfoMode
  Result := FPaymentInfoMode
End; // GetPaymentInfoMode

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPaymentLineCount : Integer;
Begin // GetPaymentLineCount
  Result := FPaymentLines.Count;
End; // GetPaymentLineCount

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPaymentLine (Index : Integer) : IOrderPaymentsTransactionPaymentInfoPaymentLine;
Begin // GetPaymentLine
  If (Index >= 0) And (Index < FPaymentLines.Count) Then
    Result := FPaymentLines.Items[Index] As IOrderPaymentsTransactionPaymentInfoPaymentLine
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPaymentLine: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FPaymentLines.Count) + ')');
End; // GetPaymentLine

//------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoPaymentHeader.AddPaymentDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                                                              Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
Begin // AddPaymentDetails
  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  FPaymentLines.Add (TOrderPaymentsTransactionPaymentInfoPaymentLine.Create(VATPayDetails, OrderLineIntf, FPaymentInfoMode));
End; // AddPaymentDetails

//-------------------------------------------------------------------------

// Removes any zero value lines from the Payment and Returns TRUE if the entire payment
// should be removed
Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.CullPaymentLines : Boolean;
Var
  Index, I : Integer;
Begin // CullPaymentLines
  // Check the Payment SRC could be loaded
  If (Trim(FPaymentSRC.OurRef) = Trim(FVATPayDetails.vpReceiptRef)) Then
  Begin
    // Use a seperate index variable as we may be deleting payment lines which have no value
    Index := 0;
    For I := 0 To (FPaymentLines.Count - 1) Do
    Begin
      If ((FPaymentInfoMode <> pimInvoice) And (GetPaymentLine(Index).opplUnmatchedValue <= 0.0)) Or
         ((FPaymentInfoMode = pimInvoice) And (GetPaymentLine(Index).opplMatchedValue <= 0.0)) Then
        // Delete the payment line
        FPaymentLines.Delete(Index)
      Else
        // Move to the next array element
        Index := Index + 1;
    End; // For I

    Result := (FPaymentLines.Count = 0);
  End // If (Trim(FPaymentSRC.OurRef) = Trim(FVATPayDetails.vpReceiptRef))
  Else
    // #FAIL - could not load the SRC so remove the payment from the list
    Result := TRUE;
End; // CullPaymentLines

//-------------------------------------------------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoPaymentHeader.ProcessRefund(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                                                          Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
Var
  PaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  I : Integer;
Begin // ProcessRefund
  For I := 0 To (FPaymentLines.Count - 1) Do
  Begin
    PaymentLineIntf := GetPaymentLine(I);
    If (PaymentLineIntf.opplOrderLine = OrderLineIntf) Then
    Begin
      // MH 27/10/2014 ABSEXCH-15769: Added header level total of Refunds To Date as lines get
      // removed when fully refunded making it impossible to show the correct total refunds on
      // the Refund dialog
      FRefundGoodsToDate := Round_Up(FRefundGoodsToDate + VATPayDetails.vpGoodsValue, 2);
      FRefundVATToDate := Round_Up(FRefundVATToDate + VATPayDetails.vpVATValue, 2);

      // Update the payment line with the refund details
      (PaymentLineIntf As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).ApplyRefund (VATPayDetails);

      Break;
    End; // If (PaymentLineIntf.opplOrderLine = OrderLineIntf)
  End; // For I
  PaymentLineIntf := NIL;
End; // ProcessRefund

//-------------------------------------------------------------------------

Procedure TOrderPaymentsTransactionPaymentInfoPaymentHeader.ProcessMatching(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType;
                                                                            Const OrderLineIntf : IOrderPaymentsTransactionPaymentInfoOrderLine);
Var
  PaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  I : Integer;
Begin // ProcessMatching
  For I := 0 To (FPaymentLines.Count - 1) Do
  Begin
    PaymentLineIntf := GetPaymentLine(I);
    If (PaymentLineIntf.opplOrderLine = OrderLineIntf) Then
    Begin
      (PaymentLineIntf As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).ApplyMatching (VATPayDetails);
    End; // If (PaymentLineIntf.opplOrderLine = OrderLineIntf)
  End; // For I
  PaymentLineIntf := NIL;
End; // ProcessMatching

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPayment : InvRec;
Begin // GetPayment
  Result := FPaymentSRC;
End; // GetPayment

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetOurRef : ShortString;
Begin // GetOurRef
  Result := FPaymentSRC.OurRef;
End; // GetOurRef

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPaymentOurRef: ShortString;
begin
  Result := FVATPayDetails.vpTransRef;
end;

//------------------------------

function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetPaymentType: enumOrderPaymentsVATPayDetailsType;
begin
  Result := FVATPayDetails.vpType;
end;

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetCurrencySymbol : ShortString;
Begin // GetCurrencySymbol
  Result := SSymb(FPaymentSRC.Currency);
End; // GetCurrencySymbol

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetUser : ShortString;
Begin // GetUser
  Result := FVATPayDetails.vpUserName
End; // GetUser

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetCreatedDate : ShortString;
Begin // GetCreatedDate
  Result := FVATPayDetails.vpDateCreated
End; // GetCreatedDate

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetCreatedTime : ShortString;
Begin // GetCreatedTime
  Result := FVATPayDetails.vpTimeCreated
End; // GetCreatedTime

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetCreditCardType : ShortString;
Begin // GetCreditCardType
  Result := FPaymentSRC.thCreditCardType
End; // GetCreditCardType

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetCreditCardNumber : ShortString;
Begin // GetCreditCardNumber
  Result := FPaymentSRC.thCreditCardNumber
End; // GetCreditCardNumber

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetCreditCardExpiry : ShortString;
Begin // GetCreditCardExpiry
  Result := FPaymentSRC.thCreditCardExpiry
End; // GetCreditCardExpiry

//------------------------------

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetOriginalValue : Double;
Begin // GetOriginalValue

  // Conundrum - to take the Original Value from the payment lines or the transaction
  // itself - the payment lines are less likely to have been molested, but the transaction
  // is what affects the balances

  Result := Round_Up(ITotal(FPaymentSRC),2);
End; // GetOriginalValue

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetRefundToDateValue : Double;
//Var
//  I : Integer;
Begin // GetRefundToDateValue
//  Result := 0.0;
//
//  // Run through lines adding up the refunds to date
//  For I := 0 To (FPaymentLines.Count - 1) Do
//  Begin
//    Result := Result + GetPaymentLine(I).opplRefundToDateValue;
//  End; // For I

  // MH 27/10/2014 ABSEXCH-15769: Added header level total of Refunds To Date as lines get
  // removed when fully refunded making it impossible to show the correct total refunds on
  // the Refund dialog
  Result := Round_Up(FRefundGoodsToDate + FRefundVATToDate, 2);
End; // GetRefundToDateValue

Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetRefundValue : Double;
Var
  I : Integer;
Begin // GetRefundValue
  Result := 0.0;

  // Run through lines adding up the opplRefundValue
  For I := 0 To (FPaymentLines.Count - 1) Do
  Begin
    If GetPaymentLine(I).opplRefundSelected Then
      Result := Result + GetPaymentLine(I).opplRefundValue;
  End; // For I
End; // GetRefundValue

// Net Value = Original Value - Refunds To Date  (ignore any refunds the customer is currently defining)
Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetNetValue : Double;
Begin // GetNetValue
  Result := Round_Up(GetOriginalValue - GetRefundToDateValue, 2);
End; // GetNetValue

// MH 13/01/2015 v7.1 ABSEXCH-16022: Added Outstanding/Matched totals for Refund dialog
Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetOutstandingValue : Double;
Var
  I : Integer;
Begin // GetOutstandingValue
  Result := 0.0;
  For I := 0 To (FPaymentLines.Count - 1) Do
    Result := Result + GetPaymentLine(I).opplUnmatchedValue;
End; // GetOutstandingValue

// MH 13/01/2015 v7.1 ABSEXCH-16022: Added Outstanding/Matched totals for Refund dialog
Function TOrderPaymentsTransactionPaymentInfoPaymentHeader.GetMatchedValue : Double;
Var
  I : Integer;
Begin // GetMatchedValue
  Result := 0.0;
  For I := 0 To (FPaymentLines.Count - 1) Do
    Result := Result + GetPaymentLine(I).opplMatchedValue;
End; // GetMatchedValue

//=========================================================================

Constructor TOrderPaymentsTransactionPaymentInfo.Create (Const Transaction : InvRec; Const Mode : TOrderPaymentsTransactionPaymentInfoMode);
Begin // Create
  Inherited Create (Transaction);

  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so dialog knows what behaviour to implement
  FPaymentInfoMode := Mode;

  FOrderLines := TInterfaceList.Create;
  FPayments := TInterfaceList.Create;

  // CJS 2015-02-04 - ABSEXCH-16068 - Order Payments delay in opening SINs
  if FHasLines then
    LoadTransactionLines;

  // Load any payments against the transaction
  LoadPayments;

  // Remove any zero value payments/lines, i.e. lines which have been refunded already
  CullPayments;

  // Sanity check the actual payment outstanding value against the OPVATPay details
  // TODO: Implement payment sanity check - what to do if there is a mismatch though?
End; // Create

Destructor TOrderPaymentsTransactionPaymentInfo.Destroy;
Begin // Destroy
  FOrderLines.Clear;
  FreeAndNIL(FOrderLines);
  FPayments.Clear;
  FreeAndNIL(FPayments);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Returns TRUE if a refund can be given against the current transaction
Function TOrderPaymentsTransactionPaymentInfo.CanGiveRefund : Boolean;
Begin // CanGiveRefund
  // Any zero value payments will have been removed at this point, so if there are payments
  // listed then we can perform a refund
  Result := (FCurrentTransaction.InvDocHed In [SOR, SIN]) And (FPayments.Count > 0);
End; // CanGiveRefund

//---------------------------------------------------------------------

// CJS 2014-09-03 - T039 - Detect refund requirement
Function TOrderPaymentsTransactionPaymentInfo.NeedsRefund(IncludePicked: Boolean): Boolean;
Var
  OrderLine: IOrderPaymentsTransactionPaymentInfoOrderLine;
  PaymentHeader: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
  PaymentLine: IOrderPaymentsTransactionPaymentInfoPaymentLine;
  i, j: Integer;
  RefundGoods: Double;
  RefundVAT: Double;
  bContinueChecks : Boolean;
  TotalTransactionGoods, TotalPaymentGoods, TotalPaymentVAT : Array[VATType] Of Double;
  VATCode : VATType;
Begin
  Result := False;

  // MH 16/12/2014 ABSEXCH-15828: Modified check for Manual VAT
  If FCurrentTransaction.ManVAT Then
  Begin
    bContinueChecks := False;

    // If manual VAT is turned on then add up the payment totals (Goods / VAT) by VAT Code
    // and if they match the Footer Totals then we don't need a refund.
    FillChar (TotalPaymentGoods, SizeOf(TotalPaymentGoods), 0);
    FillChar (TotalPaymentVAT, SizeOf(TotalPaymentVAT), 0);
    For I := 0 To (GetPaymentCount - 1) Do
    Begin
      // Run through the Payment Lines adding up the Goods/VAT by VAT Code
      PaymentHeader := GetPayment(I);
      For J := 0 To (PaymentHeader.opphPaymentLineCount - 1) Do
      Begin
        PaymentLine := PaymentHeader.opphPaymentLines[j];
        TotalPaymentGoods[PaymentLine.opplOrderLine.opolVATType] := Round_Up(TotalPaymentGoods[PaymentLine.opplOrderLine.opolVATType] + PaymentLine.opplNetPaymentGoods, 2);
        TotalPaymentVAT[PaymentLine.opplOrderLine.opolVATType] := Round_Up(TotalPaymentVAT[PaymentLine.opplOrderLine.opolVATType] + PaymentLine.opplNetPaymentVAT, 2);
      End; // For J
    End; // For I

    // Run through the Order lines calculating the Goods Value excluding Written Off items - EL didn't store this info in the header
    FillChar (TotalTransactionGoods, SizeOf(TotalTransactionGoods), 0);
    For I := 0 To (GetOrderLineCount - 1) Do
    Begin
      OrderLine := GetOrderLines(I);
      OrderLine.CalculateValuesExcludingWriteOffs(IncludePicked);
      TotalTransactionGoods[OrderLine.opolVATType] := Round_Up(TotalTransactionGoods[OrderLine.opolVATType] + OrderLine.GetOrderGoodsExcludingWriteOffs, 2);
    End; // For I

    // Compare the Goods and VAT Totals to the current transactions Footer Totals
    For VATCode := Low(VATType) To High(VATType) Do
    Begin
      // Note: Need to round InvVATAnal to avoid issues
      If (TotalPaymentGoods[VATCode] <> TotalTransactionGoods[VATCode]) Or (TotalPaymentVAT[VATCode] <> Round_Up(FCurrentTransaction.InvVatAnal[VATCode], 2)) Then
      Begin
        bContinueChecks := True;
        Break;
      End; // If (TotalPaymentGoods[VATCode] <> ...
    End; // For VATCode
  End // If FCurrentTransaction.ManVAT
  Else
    bContinueChecks := True;

  If bContinueChecks Then
  Begin
    // Reset the refund amounts on the payment lines
    for i := 0 to GetPaymentCount - 1 do
    begin
      PaymentHeader := GetPayment(i);
      for j := 0 to PaymentHeader.opphPaymentLineCount - 1 do
      begin
        PaymentLine := PaymentHeader.opphPaymentLines[j];
        PaymentLine.opplRefundValue := 0.0;
      end;
    end;

    // If there are any payments, check each order line for any refunds required
    if (FCurrentTransaction.InvDocHed In [SOR, SIN]) And (FPayments.Count > 0) then
    begin
      For i := 0 To (FOrderLines.Count - 1) Do
      Begin
        // Calculate the Goods and VAT values on the Order Line, excluding
        // write-offs
        OrderLine := GetOrderLines(i);
        OrderLine.CalculateValuesExcludingWriteOffs(IncludePicked);

        // Compare the payment values with the current values -- if the payment
        // exceeds the current values, a refund is needed
        if (CompareValue(OrderLine.opolNetPaymentGoods, OrderLine.GetOrderGoodsExcludingWriteOffs) = GreaterThanValue) or
           (CompareValue(OrderLine.opolNetPaymentVAT, OrderLine.GetOrderVATExcludingWriteOffs) = GreaterThanValue) then
        begin
          Result := True;

          RefundGoods := (OrderLine.opolNetPaymentGoods - OrderLine.GetOrderGoodsExcludingWriteOffs);
          RefundVAT   := (OrderLine.opolNetPaymentVAT - OrderLine.GetOrderVATExcludingWriteOffs);

          // Assign the refund to the matching payment lines
          for j := GetPaymentCount - 1 downto 0 do
          begin
            PaymentHeader := GetPayment(j);
            AssignRefundToLines(PaymentHeader, OrderLine, RefundGoods, RefundVAT);
            // If the refund amounts are now zero, there is no more to apply, so
            // exit the loop
            if ZeroFloat(RefundGoods + RefundVAT) then
              break;
          end;
        end;
      End;
    end; // if (FCurrentTransaction.InvDocHed...
  End; // If bContinueChecks
End;

//---------------------------------------------------------------------

Procedure TOrderPaymentsTransactionPaymentInfo.AssignRefundToLines(
  PaymentHeader: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
  OrderLine: IOrderPaymentsTransactionPaymentInfoOrderLine;
  var RefundGoods: Double;
  var RefundVAT: Double);
Var
  j: Integer;
  PaymentLine: IOrderPaymentsTransactionPaymentInfoPaymentLine;
Begin
  // If a refund was required, go through the payment transactions for
  // this order
  if (RefundGoods > 0.0) or (RefundVAT > 0.0) then
  begin
    // For each line on the payment, if any refund is still outstanding...
    for j := 0 to PaymentHeader.opphPaymentLineCount - 1 do
    begin
      // ...get the line and calculate how much of the value could be
      // refunded
      PaymentLine := PaymentHeader.opphPaymentLines[j];
      if (PaymentLine.opplOrderLine = OrderLine) then
      begin
        if (RefundGoods = 0.0) then
        begin
          // Nothing more to refund
          (PaymentLine As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).SetRefundGoods(0.0)
        end
        else if (PaymentLine.opplNetPaymentGoods > RefundGoods) then
        begin
          // We can refund the whole value
          (PaymentLine As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).SetRefundGoods(RefundGoods);
          RefundGoods := 0.0;
          // Automatically mark the line as selected for refund
          PaymentLine.opplRefundSelected := True;
        end
        else
        begin
          // Refund the outstanding amount
          (PaymentLine As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).SetRefundGoods(PaymentLine.opplNetPaymentGoods);
          // Reduce the outstanding refund by the same amount
          RefundGoods := RefundGoods - PaymentLine.opplNetPaymentGoods;
          // Automatically mark the line as selected for refund
          PaymentLine.opplRefundSelected := True;
        end;

        if (RefundVAT = 0.0) then
        begin
          // Nothing more to refund
          (PaymentLine As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).SetRefundVAT(0.0)
        end
        else if (PaymentLine.opplNetPaymentGoods > RefundGoods) then
        begin
          // We can refund the whole value
          (PaymentLine As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).SetRefundVAT(RefundVAT);
          RefundVAT := 0.0;
          // Automatically mark the line as selected for refund
          PaymentLine.opplRefundSelected := True;
        end
        else
        begin
          // Refund the outstanding amount
          (PaymentLine As ITOrderPaymentsTransactionPaymentInfoPaymentLine_Internal).SetRefundVAT(PaymentLine.opplNetPaymentVAT);
          // Reduce the outstanding refund by the same amount
          RefundVAT := RefundVAT - PaymentLine.opplNetPaymentVAT;
          // Automatically mark the line as selected for refund
          PaymentLine.opplRefundSelected := True;
        end;
      end; // if (PaymentLine.opplOrderLine = OrderLine) then...
    end; // for j := 0 to PaymentHeader.opphPaymentLineCount - 1 do
  end; // if (RefundGoods > 0.0) or (RefundVAT > 0.0) then
End;

//---------------------------------------------------------------------

// MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
Function TOrderPaymentsTransactionPaymentInfo.GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;
Begin // GetPaymentInfoMode
  Result := FPaymentInfoMode
End; // GetPaymentInfoMode

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfo.GetOrderLineCount : Integer;
Begin // GetOrderLineCount
  Result := FOrderLines.Count;
End; // GetOrderLineCount

//---------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfo.GetOrderLines (Index : Integer) : IOrderPaymentsTransactionPaymentInfoOrderLine;
Begin // GetOrderLines
  If (Index >= 0) And (Index < FOrderLines.Count) Then
    Result := FOrderLines.Items[Index] As IOrderPaymentsTransactionPaymentInfoOrderLine
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionPaymentInfo.GetOrderLines: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FOrderLines.Count) + ')');
End; // GetOrderLines

//---------------------------------------------------------------------

// Returns the index of the specified Line, -1 if not found
Function TOrderPaymentsTransactionPaymentInfo.FindOrderLineByABSLineNo (Const ABSLineNo : Integer) : Integer;
Var
  I : Integer;
Begin // FindOrderLineByABSLineNo
  Result := -1;
  For I := 0 To (FOrderLines.Count - 1) Do
  Begin
    If (GetOrderLines(I).opolLine.ABSLineNo = ABSLineNo) Then
    Begin
      Result := I;
      Break;
    End; // If (GetOrderLines(I).optlLine.ABSLineNo = ABSLineNo)
  End; // For I
End; // FindOrderLineByABSLineNo

//------------------------------

// Processes an Order Line loaded by LoadTransactionLines
Procedure TOrderPaymentsTransactionPaymentInfo.ProcessOrderLine (Const OrderLine : IDetail);
Begin // ProcessOrderLine
  // Just store the order lines for later reference by the refund dialog
  FOrderLines.Add(TOrderPaymentsTransactionPaymentInfoOrderLine.Create(@FOriginalOrder, OrderLine));
End; // ProcessOrderLine

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionPaymentInfo.GetPaymentCount : Integer;
Begin // GetPaymentCount
  Result := FPayments.Count;
End; // GetPaymentCount

Function TOrderPaymentsTransactionPaymentInfo.GetPayment (Index : Integer) : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
Begin // GetPayment
  If (Index >= 0) And (Index < FPayments.Count) Then
    Result := FPayments.Items[Index] As IOrderPaymentsTransactionPaymentInfoPaymentHeader
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionPaymentInfo.GetPayment: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FPayments.Count) + ')');
End; // GetPayment

// Returns the index of the specified payment, -1 if not found
Function TOrderPaymentsTransactionPaymentInfo.FindPaymentByOurRef (Const PaymentRef : ShortString) : Integer;
Var
  I : Integer;
Begin // FindPaymentByOurRef
  Result := -1;
  For I := 0 To (FPayments.Count - 1) Do
  Begin
    If (GetPayment(I).opphOurRef = Trim(PaymentRef)) Then
    Begin
      Result := I;
      Break;
    End; // If (GetPayment(I).opphOurRef = Trim(PaymentRef))
  End; // For I
End; // FindPaymentByOurRef

// MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
Function TOrderPaymentsTransactionPaymentInfo.GetOrder : InvRec;
Begin // GetOrder
  Result := FOriginalOrder
End; // GetOrder

//------------------------------

// Adds a payment into the internal payments list
Procedure TOrderPaymentsTransactionPaymentInfo.AddPaymentDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
Var
  oPayment : ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal;
  oOrderLine : IOrderPaymentsTransactionPaymentInfoOrderLine;
  Idx : Integer;
Begin // AddPaymentDetails
  // Find the corresponding order line - skip any lines that don't map onto an order line
  Idx := FindOrderLineByABSLineNo (VATPayDetails.vpSORABSLineNo);
  If (Idx >= 0) Then
  Begin
    oOrderLine := GetOrderLines (Idx);

    If (VATPayDetails.vpType In VATPayDetailsTypePaymentSet) Then
    Begin
      // Payment ------------------------------

      // Update the running totals on the Order Line
      (oOrderLine As ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal).RegisterPayment(VATPayDetails);

      // Look to see if the Payment already exists in the Payments list
      Idx := FindPaymentByOurRef(VATPayDetails.vpReceiptRef);
      If (Idx >= 0) Then
      Begin
        // Get existing PaymentHeader object and add the Payment details
        oPayment := (GetPayment(Idx) As ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal);
        oPayment.AddPaymentDetails(VATPayDetails, oOrderLine);
      End // If (Idx >= 0)
      Else
      Begin
        // Create a new payment object and add it into the list
        oPayment := TOrderPaymentsTransactionPaymentInfoPaymentHeader.Create(VATPayDetails, oOrderLine, FPaymentInfoMode, @FExLocal);
        FPayments.Add(oPayment);
      End; // Else
    End // If (VATPayDetails.vpType In VATPayDetailsTypePaymentSet)
    Else If (VATPayDetails.vpType In VATPayDetailsTypeRefundSet) Then
    Begin
      // Refund -------------------------------

      // Update the running totals on the Order Line
      (oOrderLine As ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal).RegisterRefund(VATPayDetails);

      // Look to see if the Payment being refunded already exists in the Payments list
      Idx := FindPaymentByOurRef(VATPayDetails.vpTransRef);
      If (Idx >= 0) Then
      Begin
        // Get existing PaymentHeader object and add the Payment details
        oPayment := (GetPayment(Idx) As ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal);
        oPayment.ProcessRefund(VATPayDetails, oOrderLine);
      End; // If (Idx >= 0)
    End // If (VATPayDetails.vpType In VATPayDetailsTypeRefundSet)
    Else If (VATPayDetails.vpType In [vptMatching]) Then
    Begin
      // Matching -----------------------------

      // Update the running totals on the Order Line
      //(oOrderLine As ITOrderPaymentsTransactionPaymentInfoOrderLine_Internal).RegisterMatching(VATPayDetails);

      // Look to see if the Payment being refunded already exists in the Payments list
      Idx := FindPaymentByOurRef(VATPayDetails.vpReceiptRef);

      //Refund matches have the refund SRC in vpReceiptRef, so we need to go and find the reference fo
      //the payment that they are refunding - this is done in FindPaymentFromRefundMatch
      if (Idx < 0) and ((Round_Up(VATPayDetails.vpGoodsValue, 2) < 0) or (Round_Up(VATPayDetails.vpVATValue, 2) < 0)) then
        Idx := FindPaymentByOurRef(FindPaymentFromRefundMatch(VATPayDetails.vpReceiptRef));
      If (Idx >= 0) Then
      Begin
        // Get existing PaymentHeader object and add the Payment details
        oPayment := (GetPayment(Idx) As ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal);
        oPayment.ProcessMatching(VATPayDetails, oOrderLine);
      End; // If (Idx >= 0)
    End; // If (VATPayDetails.vpType In [vptMatching])
  End; // If (Idx >= 0)

  oPayment := NIL;
  oOrderLine := NIL;
End; // AddPaymentDetails

//-------------------------------------------------------------------------

// Remove any zero value payments/lines, i.e. lines which have been refunded already
Procedure TOrderPaymentsTransactionPaymentInfo.CullPayments;
Var
  bDelete : Boolean;
  Index, I : Integer;
Begin // CullPayments
  // Use a seperate index variable as we may be deleting payments which have been refunded
  Index := 0;
  For I := 0 To (FPayments.Count - 1) Do
  Begin
    // Call CullPaymentLines to weed out any zero-value payment lines, returns TRUE if the
    // entire payment should be removed
    bDelete := (GetPayment(Index) As ITOrderPaymentsTransactionPaymentInfoPaymentHeader_Internal).CullPaymentLines;

    If bDelete Then
      // Delete the payment
      FPayments.Delete(Index)
    Else
      // Move to the next array element
      Index := Index + 1;
  End; // For I
End; // CullPayments

//=========================================================================
//From the refund SRC on a refund matching record, find the SRC which it refunds
function TOrderPaymentsTransactionPaymentInfo_MSSQL.FindPaymentFromRefundMatch(
  const SRCRef : string): string;
var
 oRes : Variant;
 sQuery, sCompanyCode, sConnection : AnsiString;
 SQLCaller : TSQLCaller;
begin
  Result := '';
  sQuery := 'Select Distinct vpTransRef from [COMPANY].OPVATPay where vpReceiptRef = ' + QuotedStr(Trim(SRCRef)) +
              'and vpType = ' + IntToStr(Ord(vptSINValueRefund));

  //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
  SQLCaller := TSQLCaller.Create(GlobalAdoConnection);
  Try
    sCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    SQLCaller.Select(sQuery, sCompanyCode);
    If (SQLCaller.ErrorMsg = '') Then
    Begin
      If (sqlCaller.Records.RecordCount > 0) Then
      Begin
        sqlCaller.Records.First;
        Result := sqlCaller.Records.FieldByName('vpTransRef').AsString;
      end;
    End;
  Finally
    SQLCaller.Free;
  End;
end;

//=========================================================================
// Runs through OpVATPay and loads any payments against the SOR / SIN
Procedure TOrderPaymentsTransactionPaymentInfo_MSSQL.LoadPayments;
Var
  fldOrderRef, fldReceiptRef, fldTransRef, fldDescription,
  fldVATCode, fldUserName, fldDateCreated, fldTimeCreated : TStringField;
  fldLineOrderNo, fldSORABSLineNo, fldType, fldCurrency : TIntegerField;
  fldGoodsValue, fldVATValue : TFloatField;
  SQLCaller : TSQLCaller;
  sCompanyCode, sConnection, sQuery, sOrderRef : AnsiString;
  PayDetsRec : OrderPaymentsVATPayDetailsRecType;
Begin // LoadPayments
  //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
  SQLCaller := TSQLCaller.Create(GlobalADOConnection);
  Try
    sCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Rewrite so that Order Refunds show Outstanding and SIN's show matched payments
    If (FCurrentTransaction.InvDocHed In [SOR, SDN]) Then
    Begin
      If (FCurrentTransaction.InvDocHed = SOR) Then
        sOrderRef := FCurrentTransaction.OurRef
      Else
        sOrderRef := FCurrentTransaction.thOrderPaymentOrderRef;

      // Pull back OPVATPAY rows for a SOR
      sQuery := 'Select vpOrderRef, vpReceiptRef, vpTransRef, vpLineOrderNo, vpSORABSLineNo, vpType, vpCurrency, vpDescription, vpVATCode, vpGoodsValue, vpVATValue, vpUserName, vpDateCreated, vpTimeCreated ' +
                  'From [COMPANY].OPVATPay ' +
                 'Where (vpOrderRef=' + QuotedStr(sOrderRef) + ') ' +
                   'And (' +
                          // Payments against SOR/SDN
                          '(vpType In (' + IntToStr(Ord(vptSORPayment)) + ', ' + IntToStr(Ord(vptSDNPayment)) + ', ' + IntToStr(Ord(vptSORValueRefund)) + ')) ' +
                          'Or ' +
                          // Matching/Unmatching against SOR/SDN Payments
                          '(' +
                            '(vpType In (' + IntToStr(Ord(vptMatching)) + ')) ' +
                            'And ' +
                            // Check it was a payment against a SOR/SDN
                            '(vpReceiptRef In (' +
                                               'Select Distinct vpReceiptRef ' +
                                                 'From [COMPANY].OPVATPay ' +
                                                'Where (vpOrderRef=' + QuotedStr(sOrderRef) + ') ' +
                                                  'And (vpType In (' + IntToStr(Ord(vptSORPayment)) + ', ' + IntToStr(Ord(vptSDNPayment)) + '))))' +
                          ')' +
                       ') ' +
                   // Skip zero value lines to reduce cruft
                   'And ((vpGoodsValue <> 0.0) or (vpVATValue <> 0.0)) ' +
                // Order by Date/Time to ensure matching rows appear after receipt rows - even after a P.SQL -> MSSQL migration which can screwup the PositionId order
                'Order By vpDateCreated, vpTimeCreated, vpType, vpReceiptRef, vpLineOrderNo';
    End // If (FCurrentTransaction.InvDocHed In [SOR, SDN])
    Else If (FCurrentTransaction.InvDocHed = SIN) Then
    Begin
      // Pull back the OPVATPAY rows for a SIN - a summary of payments matched against the sin with matched values
      sQuery := 'Select vpOrderRef, vpReceiptRef, vpTransRef, vpLineOrderNo, vpSORABSLineNo, vpType, vpCurrency, vpDescription, vpVATCode, vpGoodsValue, vpVATValue, vpUserName, vpDateCreated, vpTimeCreated ' +
                  'From [COMPANY].OPVATPay ' +
                 'Where (vpOrderRef=' + QuotedStr(FCurrentTransaction.thOrderPaymentOrderRef) + ') ' +
                   'And (' +
                         '(' +
                           // Payment details for payments matched against the SIN
                           '(vpReceiptRef In (' +
                                              'Select Distinct vpReceiptRef ' +
		  			        'From [COMPANY].OPVATPay ' +
                                               'Where (vpTransRef=' + QuotedStr(FCurrentTransaction.OurRef) + ') ' +
                                                 'And (vpType = ' + IntToStr(Ord(vptMatching)) + '))) ' +
                           'And ' +
                           //PR: 15/01/2015 Added vptSINValueRefund as otherwise previous refunds weren't showing on refund form
                           '(vpType In (' + IntToStr(Ord(vptSORPayment)) + ', ' + IntToStr(Ord(vptSDNPayment)) + ', ' +
                                          IntToStr(Ord(vptSINPayment)) + ', ' + IntToStr(Ord(vptSINValueRefund)) + '))' +
                         ') ' +
                         'Or ' +
                         '(' +
                           // Matching/Unmatching details between SIN and Payments
                           '(vpTransRef=' + QuotedStr(FCurrentTransaction.OurRef) + ') ' +
                           'And ' +
                           '(vpType = ' + IntToStr(Ord(vptMatching)) + ')' +
                         ')' +
	               ') ' +
                   // Skip zero value lines to reduce cruft
                   'And ((vpGoodsValue <> 0.0) or (vpVATValue <> 0.0)) ' +
                   // Order by Date/Time to ensure matching rows appear after receipt rows - even after a P.SQL -> MSSQL migration which can screwup the PositionId order
                'Order By vpDateCreated, vpTimeCreated, vpType, vpReceiptRef, vpLineOrderNo';
    End; // If (FCurrentTransaction.InvDocHed = SIN)

    SQLCaller.Select(sQuery, sCompanyCode);
    If (SQLCaller.ErrorMsg = '') Then
    Begin
      If (sqlCaller.Records.RecordCount > 0) Then
      Begin
        // Disable the link to the UI to improve performance when iterating through the dataset
        sqlCaller.Records.DisableControls;
        Try
          // Prepare fields
          fldOrderRef := sqlCaller.Records.FieldByName('vpOrderRef') As TStringField;
          fldReceiptRef := sqlCaller.Records.FieldByName('vpReceiptRef') As TStringField;
          fldTransRef := sqlCaller.Records.FieldByName('vpTransRef') As TStringField;
          fldLineOrderNo := sqlCaller.Records.FieldByName('vpLineOrderNo') As TIntegerField;
          fldSORABSLineNo := sqlCaller.Records.FieldByName('vpSORABSLineNo') As TIntegerField;
          fldType := sqlCaller.Records.FieldByName('vpType') As TIntegerField;
          fldCurrency := sqlCaller.Records.FieldByName('vpCurrency') As TIntegerField;
          fldDescription := sqlCaller.Records.FieldByName('vpDescription') As TStringField;
          fldVATCode := sqlCaller.Records.FieldByName('vpVATCode') As TStringField;
          fldGoodsValue := sqlCaller.Records.FieldByName('vpGoodsValue') As TFloatField;
          fldVATValue := sqlCaller.Records.FieldByName('vpVATValue') As TFloatField;
          fldUserName := sqlCaller.Records.FieldByName('vpUserName') As TStringField;
          fldDateCreated := sqlCaller.Records.FieldByName('vpDateCreated') As TStringField;
          fldTimeCreated := sqlCaller.Records.FieldByName('vpTimeCreated') As TStringField;

          sqlCaller.Records.First;
          While (Not sqlCaller.Records.EOF)  Do
          Begin
            FillChar(PayDetsRec, SizeOf(PayDetsRec), #0);
            PayDetsRec.vpOrderRef     := fldOrderRef.Value;
            PayDetsRec.vpReceiptRef   := fldReceiptRef.Value;
            PayDetsRec.vpTransRef     := fldTransRef.Value;
            PayDetsRec.vpLineOrderNo  := fldLineOrderNo.Value;
           PayDetsRec.vpSORABSLineNo := fldSORABSLineNo.Value;
            PayDetsRec.vpType         := enumOrderPaymentsVATPayDetailsType(fldType.Value);
            PayDetsRec.vpCurrency     := fldCurrency.Value;
            PayDetsRec.vpDescription  := fldDescription.Value;
            PayDetsRec.vpVATCode      := (fldVATCode.Value + #0)[1];
            PayDetsRec.vpGoodsValue   := fldGoodsValue.Value;
            PayDetsRec.vpVATValue     := fldVATValue.Value;
            PayDetsRec.vpUserName     := fldUserName.Value;
            PayDetsRec.vpDateCreated  := fldDateCreated.Value;
            PayDetsRec.vpTimeCreated  := fldTimeCreated.Value;
            AddPaymentDetails(PayDetsRec);

            sqlCaller.Records.Next;
          End; // While (Not sqlCaller.Records.EOF) And (Status = 0) And KeepRun
        Finally
          sqlCaller.Records.EnableControls;
        End; // Try..Finally
      End; // If (sqlCaller.Records.RecordCount > 0)
    End; // If (SQLCaller.ErrorMsg = '')
    sqlCaller.Close;
  Finally
    SQLCaller.Free;
  End; // Try..Finally
End; // LoadPayments

//-------------------------------------------------------------------------

// Loads the Transaction Lines for the current transaction and order as required
Procedure TOrderPaymentsTransactionPaymentInfo_MSSQL.LoadTransactionLines;
Var
  oSQLSelectTransactionLines : TSQLSelectTransactionLines;
Begin // LoadTransactionLines
  // Load the SOR lines
  oSQLSelectTransactionLines := TSQLSelectTransactionLines.Create;
  Try
    oSQLSelectTransactionLines.CompanyCode   := SQLUtils.GetCompanyCode(SetDrive);
    oSQLSelectTransactionLines.FromClause    := 'FROM [COMPANY].DETAILS';
    oSQLSelectTransactionLines.WhereClause   := 'WHERE (tlFolioNum=' + IntToStr(FOriginalOrder.FolioNum) + ') And (tlLineNo > 0)';
    oSQLSelectTransactionLines.OrderByClause := 'ORDER BY tlFolioNum, tlLineNo';

    // Access using SQL navigation
    oSQLSelectTransactionLines.OpenFile;
    oSQLSelectTransactionLines.First;
    While (Not oSQLSelectTransactionLines.EOF) Do
    Begin
      ProcessOrderLine (oSQLSelectTransactionLines.ReadRecord);
      oSQLSelectTransactionLines.Next;
    End; // While (Not oSQLSelectTransactionLines.EOF)
  Finally
    oSQLSelectTransactionLines.Free;
  End; // Try..Finally
End; // LoadTransactionLines

//=========================================================================

// Runs through OpVATPay and loads any payments against the SOR / SIN
function TOrderPaymentsTransactionPaymentInfo_Pervasive.FindPaymentFromRefundMatch(
  const SRCRef: string): string;
var
  VATPayBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;
  sKey : Str255;
  I, iStatus : Integer;
  Found : Boolean;
begin
  Result := '';

  VATPayBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
  Try
    iStatus := VATPayBtrieveFile.OpenFile(SetDrive + OrderPaymentsVATPayDetailsFilePath);
    If (iStatus = 0) Then
    Begin
      VATPayBtrieveFile.Index := vpIdxReceiptRef;

      sKey := VATPayBtrieveFile.BuildReceiptRefKey(FCurrentTransaction.thOrderPaymentOrderRef, SRCRef);

      //Find first record for this SIN refund
      iStatus := VATPayBtrieveFile.GetGreaterThanOrEqual(sKey);

      Found := False;
      while (iStatus = 0) and (Trim(SRCRef) = Trim(VATPayBtrieveFile.VATPayDetails.vpReceiptRef)) and not Found do
      begin
         Found := VATPayBtrieveFile.VATPayDetails.vpType = vptSINValueRefund;

         if Found then
           Result := VATPayBtrieveFile.VATPayDetails.vpTransRef
         else
           iStatus := VATPayBtrieveFile.GetNext;
      end; //While iStatus = 0 etc

    end;
  Finally
    VATPayBtrieveFile.Free;
  End;
end;

Procedure TOrderPaymentsTransactionPaymentInfo_Pervasive.LoadPayments;
Var
  VATPayBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;
  oVATDetMatchingCache : TOrderPaymentsVATPayDetailsList;
  // MH 12/08/2015 2015-R1 ABSEXCH-16744: Refunds against SIN's showing payments not allocated to SIN
  oVATDetPaymentCache : TOrderPaymentsVATPayDetailsList;
  PaymentRec : OrderPaymentsVATPayDetailsRecType;
  sKey : Str255;
  I, J, iStatus : Integer;
Begin // LoadPayments
  VATPayBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
  oVATDetMatchingCache := TOrderPaymentsVATPayDetailsList.Create;
  // MH 12/08/2015 2015-R1 ABSEXCH-16744: Refunds against SIN's showing payments not allocated to SIN
  oVATDetPaymentCache := TOrderPaymentsVATPayDetailsList.Create;
  Try
    iStatus := VATPayBtrieveFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
    If (iStatus = 0) Then
    Begin
      VATPayBtrieveFile.Index := vpIdxReceiptRef;

      If (FCurrentTransaction.InvDocHed = SOR) Then
        sKey := VATPayBtrieveFile.BuildReceiptRefKey (FCurrentTransaction.OurRef)
      Else
        sKey := VATPayBtrieveFile.BuildReceiptRefKey (FCurrentTransaction.thOrderPaymentOrderRef);
      iStatus := VATPayBtrieveFile.GetGreaterThanOrEqual(sKey);
      While (iStatus = 0) And (VATPayBtrieveFile.VATPayDetails.vpOrderRef = sKey) Do
      Begin
        // MH 12/08/2015 2015-R1 ABSEXCH-16744: Refunds against SIN's showing payments not allocated to SIN
        (*
        If (VATPayBtrieveFile.VATPayDetails.vpType <> vptMatching) Then
          AddPaymentDetails(VATPayBtrieveFile.VATPayDetails)
        Else
          // Cache matching rows up until the end to ensure the Payment details have been processed
          oVATDetMatchingCache.Add(VATPayBtrieveFile.VATPayDetails);
        *)

        // Filter out zero value description lines
        If (VATPayBtrieveFile.VATPayDetails.vpGoodsValue <> 0.0) Or (VATPayBtrieveFile.VATPayDetails.vpVATValue <> 0.0) Then
        Begin
          If (FCurrentTransaction.InvDocHed = SOR) Then
          Begin
            // SOR
            If (VATPayBtrieveFile.VATPayDetails.vpType In [vptSORPayment, vptSDNPayment, vptSORValueRefund]) Then
              // Include Payments/Refunds against the SOR and any subsequent SDN's
              AddPaymentDetails(VATPayBtrieveFile.VATPayDetails)
            Else If (VATPayBtrieveFile.VATPayDetails.vpType = vptMatching) Then
              // Cache matching rows up until the end to ensure the Payment details have been processed
              oVATDetMatchingCache.Add(VATPayBtrieveFile.VATPayDetails);
          End // If (FCurrentTransaction.InvDocHed = SOR)
          Else
          Begin
            // SIN
            If (VATPayBtrieveFile.VATPayDetails.vpType = vptMatching) Then
            Begin
              // Cache matching rows against the SIN - not interested in Matching against any
              // other transactions
              If (Trim(VATPayBtrieveFile.VATPayDetails.vpTransRef) = FCurrentTransaction.OurRef) Then
                oVATDetMatchingCache.Add(VATPayBtrieveFile.VATPayDetails);
            End // If (VATPayBtrieveFile.VATPayDetails.vpType = vptMatching)
            Else If (VATPayBtrieveFile.VATPayDetails.vpType In [vptSORPayment,
                                                                vptSDNPayment,
                                                                vptSINPayment,
                                                                vptSINValueRefund]) Then
            Begin
              // Cache the payment/refund details until the end and the process any
              // that are matched against the SIN
              oVATDetPaymentCache.Add(VATPayBtrieveFile.VATPayDetails);
            End; // If (VATPayBtrieveFile.VATPayDetails.vpType In [
          End; // Else
        End; // If (VATPayBtrieveFile.VATPayDetails.vpGoodsValue <> 0.0) Or (VATPayBtrieveFile.VATPayDetails.vpVATValue <> 0.0)

        iStatus := VATPayBtrieveFile.GetNext;
      End; // While (iStatus = 0) And (VATPayBtrieveFile.VATPayDetails.vpOrderRef = sKey)

      // MH 12/08/2015 2015-R1 ABSEXCH-16744: Refunds against SIN's showing payments not allocated to SIN
      If (FCurrentTransaction.InvDocHed = SIN) And (oVATDetPaymentCache.Count > 0) And (oVATDetMatchingCache.Count > 0) Then
      Begin
        // Run through the cached payment details and process any paymens/refunds
        // that are matched to the SIN
        For I := 0 To (oVATDetPaymentCache.Count - 1) Do
        Begin
          // Lookup Payment in Matching Cache to see if it is matched to the SIN
          PaymentRec := oVATDetPaymentCache.Records[I];
          For J := 0 To (oVATDetMatchingCache.Count - 1) Do
          Begin
            If (Trim(PaymentRec.vpReceiptRef) = Trim(oVATDetMatchingCache.Records[J].vpReceiptRef)) Then
            Begin
              AddPaymentDetails(PaymentRec);
              Break;
            End; // If (Trim(PaymentRec.vpReceiptRef) = Trim(oVATDetMatchingCache.Records[J].vpReceiptRef)) 
          End; // For J
        End; // For I
      End; // If (FCurrentTransaction.InvDocHed = SIN) And (oVATDetPaymentCache.Count > 0) And (oVATDetMatchingCache.Count > 0) 

      // Pull out any cached Matching rows and apply them to the Payments
      For I := 0 To (oVATDetMatchingCache.Count - 1) Do
        AddPaymentDetails(oVATDetMatchingCache.Records[I]);

      VATPayBtrieveFile.CloseFile;
    End; // If (iStatus = 0)
  Finally
    // MH 12/08/2015 2015-R1 ABSEXCH-16744: Refunds against SIN's showing payments not allocated to SIN
    oVATDetPaymentCache.Free;
    oVATDetMatchingCache.Free;
    VATPayBtrieveFile.Free;
  End; // Try..Finally
End; // LoadPayments

//-------------------------------------------------------------------------

// Loads the Transaction Lines for the current transaction and order as required
Procedure TOrderPaymentsTransactionPaymentInfo_Pervasive.LoadTransactionLines;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadTransactionLines
  sKey := FullNomKey(FOriginalOrder.FolioNum) + FullNomKey(0);
  iStatus := FExLocal.LFind_Rec (B_GetGEq, IDetailF, IdFolioK, sKey);
  While (iStatus = 0) And (FExLocal.LId.FolioRef = FOriginalOrder.FolioNum) Do
  Begin
    ProcessOrderLine (FExLocal.LId);
    iStatus := FExLocal.LFind_Rec (B_GetNext, IDetailF, IdFolioK, sKey);
  End; // While (iStatus = 0) And (FExLocal.LId.FolioRef = FOriginalOrder.FolioNum)
End; // LoadTransactionLines

//=========================================================================

End.
