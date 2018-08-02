Unit OrderPaymentsInterfaces;

Interface

Uses GlobVar, VarConst, ExBtTH1U, oOPVATPayBtrieveFile;

Type
  // MH 13/01/2015 v7.1 ABSEXCH-16022: Added TOrderPaymentsTransactionPaymentInfoMode so Refund objects knows what behaviour to implement
  TOrderPaymentsTransactionPaymentInfoMode = (pimAuto=0,           // App automatically uses pimOrder or pimInvoice based on Transaction InvDocHed
                                              pimOrder=1,          // Refund against SOR
                                              pimOrderWriteOff=2,  // Refund SOR due to Write Offs
                                              pimInvoice=3);       // Refund against SIN

  //------------------------------

  // Base Interface for common functionality required by the Payment and Refund objects
  IOrderPaymentsBaseTransactionInfo = Interface
    ['{E7FC5031-2DAF-490A-8263-84BF8B37883D}']
    // --- Internal Methods to implement Public Properties ---
    Function GetExLocal : TdPostExLocalPtr;
    Function GetTransaction : InvRec;
    Function GetTransactionCurrency : Byte;
    Function GetTransactionCurrencySymbol : String;

    // ------------------ Public Properties ------------------
    Property ExLocal : TdPostExLocalPtr Read GetExLocal;

    Property optTransaction : InvRec Read GetTransaction;

    Property optCurrency : Byte Read GetTransactionCurrency;
    Property optCurrencySymbol : String Read GetTransactionCurrencySymbol;

    // ------------------- Public Methods --------------------

    // Applies a record lock to the Transaction (SOR/SDN/SIN) to prevent multi-user whoopsie's happening
    Function LockTransaction : Boolean;
  End; // IOrderPaymentsBaseTransactionInfo

  //------------------------------

  IOrderPaymentsTransactionPaymentInfoOrderLine = Interface
    ['{01675760-75FD-41A0-B4AC-449DCC01D82D}']
    // --- Internal Methods to implement Public Properties ---
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

    // ------------------ Public Properties ------------------
    Property opolLine : IDetail Read GetLine;
    Property opolVATType : VATType Read GetVATType;
    // Unit price after discounts applied
    Property opolUnitPrice : Double Read GetUnitPrice;
    Property opolLineTotal : Double Read GetLineTotal;

    Property opolNetPaymentTotal : Double Read GetNetPaymentTotal;
    Property opolNetPaymentGoods : Double Read GetNetPaymentGoods;
    Property opolNetPaymentVAT : Double Read GetNetPaymentVAT;

    // ------------------- Public Methods --------------------
    // CJS 2014-09-03 - T039 - Detect refund requirement
    // Calculate values excluding write-offs
    Procedure CalculateValuesExcludingWriteOffs(IncludePicked: Boolean);
  End; // IOrderPaymentsTransactionRefundOrderLine

  //------------------------------

  // Contains details about a specific line within a payment SRC
  IOrderPaymentsTransactionPaymentInfoPaymentLine = Interface
    ['{2A1F7A0A-0C47-46AA-A598-6750C199D1E9}']
    // --- Internal Methods to implement Public Properties ---
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

    // ------------------ Public Properties ------------------
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Property opplPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode Read GetPaymentInfoMode;

    // Link to the original order line for this payment line
    Property opplOrderLine : IOrderPaymentsTransactionPaymentInfoOrderLine Read GetOrderLine;
    Property opplCurrencySymbol : ShortString Read GetCurrencySymbol;

    // Surfaces field properties from OPVatPay
    Property opplDescription: ShortString read GetDescription;
    Property opplReceiptReference: ShortString read GetReceiptReference;

    // Net payment (Original Value - Refunds To Date)
    Property opplNetPaymentValue : Double Read GetNetPaymentValue;
    Property opplNetPaymentGoods : Double Read GetNetPaymentGoods;
    Property opplNetPaymentVAT : Double Read GetNetPaymentVAT;

    // Total of previous refunds
    Property opplRefundToDateValue : Double Read GetRefundToDateValue;

    Property opplRefundSelected : Boolean Read GetRefundSelected Write SetRefundSelected;
    Property opplRefundValue : Double Read GetRefundValue Write SetRefundValue;
    Property opplRefundGoods : Double Read GetRefundGoods;
    Property opplRefundVAT : Double Read GetRefundVAT;

    // Matched value
    Property opplMatchedValue : Double Read GetMatchedValue;
    Property opplMatchedGoods : Double Read GetMatchedGoods;
    Property opplMatchedVAT : Double Read GetMatchedVAT;

    // Unmatched Value (opplNetPaymentXXX - opplMatchedXXX)
    Property opplUnmatchedValue : Double Read GetUnmatchedValue;
    Property opplUnmatchedGoods : Double Read GetUnmatchedGoods;
    Property opplUnmatchedVAT : Double Read GetUnmatchedVAT;

    // ------------------- Public Methods --------------------
  End; // IOrderPaymentsTransactionPaymentInfoPaymentLine

  //------------------------------

  // Contains details about a specific payment (SRC)
  IOrderPaymentsTransactionPaymentInfoPaymentHeader = Interface
    ['{69445FF1-F6C8-451E-8B24-0DBEBB4D7A92}']
    // --- Internal Methods to implement Public Properties ---
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

    // ------------------ Public Properties ------------------
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Property opphPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode Read GetPaymentInfoMode;

    Property opphPayment : InvRec Read GetPayment;
    Property opphOurRef : ShortString Read GetOurRef;
    // The OurRef of the Transaction that this payment originated from
    Property opphPaymentOurRef: ShortString Read GetPaymentOurRef;
    // The Payment Type of this payment
    Property opphPaymentType: enumOrderPaymentsVATPayDetailsType read GetPaymentType;
    Property opphCurrencySymbol : ShortString Read GetCurrencySymbol;
    Property opphUser : ShortString Read GetUser;
    Property opphCreatedDate : ShortString Read GetCreatedDate;  // YYYYMMDD format
    Property opphCreatedTime : ShortString Read GetCreatedTime;  // HHMMSS format
    Property opphCreditCardType : ShortString Read GetCreditCardType;
    Property opphCreditCardNumber : ShortString Read GetCreditCardNumber;
    Property opphCreditCardExpiry : ShortString Read GetCreditCardExpiry;

    // Original payment value
    Property opphOriginalValue : Double Read GetOriginalValue;
    // Total of previous refunds
    Property opphRefundToDateValue : Double Read GetRefundToDateValue;

    // Total of refunds defined by the user against this payment
    Property opphRefundValue : Double Read GetRefundValue;
    // Net Value (Original Value - Total Refunds)
    Property opphNetValue : Double Read GetNetValue;

    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added Outstanding/Matched totals for Refund dialog
    // Outstanding Value (Original Value - Total Refunds - Matched Value)
    Property opphOutstandingValue : Double Read GetOutstandingValue;
    // Matched Value
    Property opphMatchedValue : Double Read GetMatchedValue;

    Property opphPaymentLineCount : Integer Read GetPaymentLineCount;
    Property opphPaymentLines [Index : Integer] : IOrderPaymentsTransactionPaymentInfoPaymentLine Read GetPaymentLine;

    // ------------------- Public Methods --------------------
  End; // IOrderPaymentsTransactionPaymentInfoPaymentHeader

  //------------------------------

  // Reports the payment situation for a specific SOR/SIN
  IOrderPaymentsTransactionPaymentInfo = Interface(IOrderPaymentsBaseTransactionInfo)
    ['{5E84707F-48C4-4543-95C4-810BEEDF9AF6}']
    // --- Internal Methods to implement Public Properties ---
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Function GetPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode;

    Function GetOrderLineCount : Integer;
    Function GetOrderLines (Index : Integer) : IOrderPaymentsTransactionPaymentInfoOrderLine;

    Function GetPaymentCount : Integer;
    Function GetPayment (Index : Integer) : IOrderPaymentsTransactionPaymentInfoPaymentHeader;

    // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
    Function GetOrder : InvRec;

    // ------------------ Public Properties ------------------
    // MH 13/01/2015 v7.1 ABSEXCH-16022: Added PaymentInfoMode so Refund objects knows what behaviour to implement
    Property oppiPaymentInfoMode : TOrderPaymentsTransactionPaymentInfoMode Read GetPaymentInfoMode;

    Property oppiOrderLineCount : Integer Read GetOrderLineCount;
    Property oppiOrderLines [Index : Integer] : IOrderPaymentsTransactionPaymentInfoOrderLine Read GetOrderLines;

    Property oppiPaymentCount : Integer Read GetPaymentCount;
    Property oppiPayments [Index : Integer] : IOrderPaymentsTransactionPaymentInfoPaymentHeader Read GetPayment;

    // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
    Property oppiOrder : InvRec Read GetOrder;

    // ------------------- Public Methods --------------------
    // Returns TRUE if a refund can be given against the current transaction
    Function CanGiveRefund : Boolean;

    // CJS 2014-09-03 - T039 - Detect refund requirement
    // Returns TRUE if the current value of the transaction is less than the
    // payment value against it. If IncludePicked is True it will also include
    // lines which are Picked Written-Off, as opposed to only including lines
    // which are actually written-off.
    Function NeedsRefund(IncludePicked: Boolean): Boolean;

    // Applies any refund amounts (detected by NeedRefund) to the Payment
    // Lines, ready for use by the Refund dialog. Only used as a support
    // function for NeedsRefund.
    Procedure AssignRefundToLines(
      PaymentHeader: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
      OrderLine: IOrderPaymentsTransactionPaymentInfoOrderLine;
      var RefundGoods: Double;
      var RefundVAT: Double
    );

  End; // IOrderPaymentsTransactionPaymentInfo

  //-------------------------------------------------------------------------


Implementation

End.