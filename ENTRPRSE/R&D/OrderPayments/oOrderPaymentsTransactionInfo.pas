Unit oOrderPaymentsTransactionInfo;

Interface

Uses Classes, SysUtils, DB, GlobVar, VarConst, ExBtTH1U, OrderPaymentsInterfaces, oOPVATPayBtrieveFile;

Const
  OPLockOrder = True;

Type
  // Encapsulates a row within the OPVATPay table relating to the current transaction
  IOrderPaymentsPaymentInfo = Interface
    ['{94687BC8-61AC-49FE-AC90-B09499BF1CF3}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOrderRef : ShortString;
    Function GetReceiptRef : ShortString;
    Function GetTransRef : ShortString;
    Function GetLineOrderNo : LongInt;
    Function GetSORABSLineNo : LongInt;
    Function GetType : enumOrderPaymentsVATPayDetailsType;
    Function GetCurrency : Byte;
    Function GetDescription : ShortString;
    Function GetVATCode : Char;
    Function GetGoodsValue : Double;
    Function GetVATValue : Double;
    Function GetUserName : ShortString;
    Function GetDateCreated : ShortString;
    Function GetTimeCreated : ShortString;

    // ------------------ Public Properties ------------------
    // SOR OurRef - originating order that all Order Payment transactions originate from
    Property vpOrderRef : ShortString Read GetOrderRef;
    // Payment OurRef (SRC) for payment taken against SOR/SDN/SIN
    Property vpReceiptRef : ShortString Read GetReceiptRef;
    // OurRef of related transaction, e.g. SDN or SIN a payment was made against
    Property vpTransRef : ShortString Read GetTransRef;
    // Line sequence within OPVATPAY
    Property vpLineOrderNo : LongInt Read GetLineOrderNo;
    // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN
    Property vpSORABSLineNo : LongInt Read GetSORABSLineNo;

    // Operation type / purpose
    Property vpType : enumOrderPaymentsVATPayDetailsType Read GetType;
    // SOR Currency and therefore SDN/SIN/SRC currency
    Property vpCurrency : Byte Read GetCurrency;
    // Text description of SOR line for printing VAT Receipts
    Property vpDescription : ShortString Read GetDescription;
    // SOR Line VAT Code
    Property vpVATCode : Char Read GetVATCode;
    // Goods Value paid/refunded
    Property vpGoodsValue : Double Read GetGoodsValue;
    // VAT Value paid/refunded
    Property vpVATValue : Double Read GetVATValue;
    // Exchequer User at point row inserted
    Property vpUserName : ShortString Read GetUserName;
    // Date row inserted in YYYYMMDD format
    Property vpDateCreated : ShortString Read GetDateCreated;
    // Time row inserted in HHMMSS format
    Property vpTimeCreated : ShortString Read GetTimeCreated;

    // ------------------- Public Methods --------------------

  End; // IOrderPaymentsPaymentInfo

  //------------------------------

  // Encapsulates a Transaction Line within the SOR/SDN/SIN and provides utility properties
  IOrderPaymentsTransactionLineInfo = Interface
    ['{08A0708B-2D88-4338-BBE0-7DC65B0391B7}']
    // --- Internal Methods to implement Public Properties ---
    Function GetTransactionLine : IDetail;
    Function GetVATType : VATType;
    Function GetLineNo : Integer;

    Function GetOrderLineTotal : Double;
    Function GetOrderLineGoods : Double;
    Function GetOrderLineVAT : Double;

    Function GetLineTotal : Double;
    Function GetLineGoods : Double;
    Function GetLineVAT : Double;

    // Net payment position from OPVATPay
    Function GetNetPaymentTotal : Double;
    Function GetNetPaymentGoods : Double;
    Function GetNetPaymentVAT : Double;

    // Outstanding position - Original Value - Net Payments
    Function GetOutstandingTotal : Double;
    Function GetOutstandingGoods : Double;
    Function GetOutstandingVAT : Double;

    Function GetCurrentPaymentTotal : Double;
    Procedure SetCurrentPaymentTotal (Value : Double);
    Function GetCurrentPaymentGoods : Double;
    Function GetCurrentPaymentVAT : Double;

    Function GetHasWriteOffs : Boolean;
    Function GetWriteOffGoods : Double;
    Function GetWriteOffVAT : Double;
    // MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
    Function GetWriteOffTotal : Double;

    // ------------------ Public Properties ------------------
    Property optlTransactionLine : IDetail Read GetTransactionLine;
    Property optlVATType : VATType Read GetVATType;
    // Returns the ABSLineNo for SOR's or the SOPLineNo for SDN/SIN's
    Property optlLineNo : Integer Read GetLineNo;

    // Original Line Value excluding subsequent Payments/Refunds
    Property optlOrderLineTotal : Double Read GetOrderLineTotal;
    Property optlOrderLineGoods : Double Read GetOrderLineGoods;
    Property optlOrderLineVAT : Double Read GetOrderLineVAT;

    // Original Line Value excluding subsequent Payments/Refunds
    Property optlLineTotal : Double Read GetLineTotal;
    Property optlLineGoods : Double Read GetLineGoods;
    Property optlLineVAT : Double Read GetLineVAT;

    // Net payment position from OPVATPay
    Property optlNetPaymentTotal : Double Read GetNetPaymentTotal;
    Property optlNetPaymentGoods : Double Read GetNetPaymentGoods;
    Property optlNetPaymentVAT : Double Read GetNetPaymentVAT;

    // Outstanding position - Original Value - Net Payments
    Property optlOutstandingTotal : Double Read GetOutstandingTotal;
    Property optlOutstandingGoods : Double Read GetOutstandingGoods;
    Property optlOutstandingVAT : Double Read GetOutstandingVAT;

    // Order Written Off Goods/VAT
    Property optlHasWriteOffs : Boolean Read GetHasWriteOffs;
    Property optlWriteOffGoods : Double Read GetWriteOffGoods;
    Property optlWriteOffVAT : Double Read GetWriteOffVAT;
    // MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
    Property optlWriteOffTotal : Double Read GetWriteOffTotal;

    // Value of payment to be made
    Property optlCurrentPaymentTotal : Double Read GetCurrentPaymentTotal Write SetCurrentPaymentTotal;
    Property optlCurrentPaymentGoods : Double Read GetCurrentPaymentGoods;
    Property optlCurrentPaymentVAT : Double Read GetCurrentPaymentVAT;

    // ------------------- Public Methods --------------------
  End; // IOrderPaymentsTransactionLineInfo

  //------------------------------

  IOrderPaymentsTransactionLinePaymentSummaryInfo = Interface
    ['{7AD10EDA-F61E-41DF-808D-47F7673836A8}']
    // --- Internal Methods to implement Public Properties ---
    Function GetLineNo : Integer;
    Function GetNetPayments : Double;
    Function GetNetPaymentGoods : Double;
    Function GetNetPaymentVAT : Double;
    Function GetTotalPayments : Double;
    Function GetTotalPaymentGoods : Double;
    Function GetTotalPaymentVAT : Double;
    Function GetTotalRefunds : Double;
    Function GetTotalRefundGoods : Double;
    Function GetTotalRefundVAT : Double;

    // ------------------ Public Properties ------------------
    Property psLineNo : Integer Read GetLineNo;

    Property psNetPayments : Double Read GetNetPayments;
    Property psNetPaymentGoods : Double Read GetNetPaymentGoods;
    Property psNetPaymentVAT : Double Read GetNetPaymentVAT;

    Property psTotalPayments : Double Read GetTotalPayments;
    Property psTotalPaymentGoods : Double Read GetTotalPaymentGoods;
    Property psTotalPaymentVAT : Double Read GetTotalPaymentVAT;

    Property psTotalRefunds : Double Read GetTotalRefunds;
    Property psTotalRefundGoods : Double Read GetTotalRefundGoods;
    Property psTotalRefundVAT : Double Read GetTotalRefundVAT;

    // ------------------- Public Methods --------------------
  End; // IOrderPaymentsTransactionLinePaymentSummaryInfo

  //------------------------------

  // Provides the payment position for a transaction within the Order Payments subsystem
  IOrderPaymentsTransactionInfo = Interface(IOrderPaymentsBaseTransactionInfo)
    ['{36B9CD1C-FC98-44C7-9A02-32211E242C1F}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOrder : InvRec;
    Function GetOrderLocked : Boolean;
    Function GetOrderLockPos : LongInt;

    Function GetAccount : CustRec;

    Function GetTransactionGoods(Index : VATType) : Double;
    Function GetTransactionLineCount : Integer;
    Function GetTransactionLines(Index : Integer) : IOrderPaymentsTransactionLineInfo;
    Function GetTransactionTotal : Double;
    Function GetTransactionTotalGoods : Double;
    Function GetTransactionTotalVAT : Double;

    Function GetPaymentDetailsCount : Integer;
    Function GetPaymentDetails (Index : Integer) : IOrderPaymentsPaymentInfo;

    Function GetPaymentSummaryCount : Integer;
    Function GetPaymentSummary(Index : Integer) : IOrderPaymentsTransactionLinePaymentSummaryInfo;

    Function GetTotalPayments : Double;
    Function GetTotalPaymentsGoods : Double;
    Function GetTotalPaymentsVAT : Double;
    Function GetTotalRefunds : Double;
    Function GetTotalRefundsGoods : Double;
    Function GetTotalRefundsVAT : Double;
    Function GetNetPayments : Double;
    Function GetNetPaymentsGoods : Double;
    Function GetNetPaymentsVAT : Double;
    Function GetMaxPayment : Double;
    Function GetOutstandingTotal : Double;
    Function GetOutstandingTotalByVATCode (Index : VATType) : Double;
    Function GetOutstandingGoodsByVATCode (Index : VATType) : Double;
    Function GetOutstandingVATByVATCode (Index : VATType) : Double;
    Function GetLineCountByVATCode (Index : VATType) : Integer;
    // MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
    Function GetWriteOffTotal : Double;

    // ------------------ Public Properties ------------------

    Property optOrder : InvRec Read GetOrder;
    Property optOrderLocked : Boolean Read GetOrderLocked;
    Property optOrderLockPos : LongInt Read GetOrderLockPos;

    Property optAccount : CustRec Read GetAccount;
    Property optTransactionGoods[Index : VATType] : Double Read GetTransactionGoods;
    Property optTransactionLineCount : Integer Read GetTransactionLineCount;
    Property optTransactionLines[Index : Integer] : IOrderPaymentsTransactionLineInfo Read GetTransactionLines;

    Property optPaymentDetailsCount : Integer Read GetPaymentDetailsCount;
    Property optPaymentDetails[Index : Integer] : IOrderPaymentsPaymentInfo Read GetPaymentDetails;

    Property optPaymentSummaryCount : Integer Read GetPaymentSummaryCount;
    Property optPaymentSummary[Index : Integer] : IOrderPaymentsTransactionLinePaymentSummaryInfo Read GetPaymentSummary;

    Property optTransactionTotal : Double Read GetTransactionTotal;
    Property optTransactionTotalGoods : Double Read GetTransactionTotalGoods;
    Property optTransactionTotalVAT : Double Read GetTransactionTotalVAT;

    Property optOutstandingTotal : Double Read GetOutstandingTotal;
    Property optOutstandingTotalByVATCode [Index : VATType] : Double Read GetOutstandingTotalByVATCode;
    Property optOutstandingGoodsByVATCode [Index : VATType] : Double Read GetOutstandingGoodsByVATCode;
    Property optOutstandingVATByVATCode [Index : VATType] : Double Read GetOutstandingVATByVATCode;

    // MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
    Property optWriteOffTotal : Double Read GetWriteOffTotal;

    Property optLineCountByVATCode [Index : VATType] : Integer Read GetLineCountByVATCode;

    // Maximum payment that can be taken for this transaction
    Property optMaxPayment : Double Read GetMaxPayment;
    //Property optMaxRefund : Double Read GetMaxRefund;

    // ------------------- Public Methods --------------------
    // CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment
    // Returns TRUE if payments have been allocated to the specified Sales
    // Order outside the Order Payments system
    Function HasManualPayments(SORRef: string): Boolean;

    // Returns TRUE if a payment can be taken for the current transaction
    Function CanTakePayment : Boolean;

    // Applies a record lock to the Transaction (SOR) to prevent multi-user whoopsie's happening
    Function LockTransaction : Boolean;

    // Finds the default Payment GL Code for the Transaction's Account
    Function GetDefaultPaymentGL : LongInt;

    // Returns the index of a Transaction Line with a specified ABS Line No in the
    // optTransactionLines array, returns -1 if not found
    Function FindLineByLineNo (Const LineNo : Integer) : Integer;

    // Returns the index of a Payment Summary Line with a specified ABS Line No in the
    // optPaymentSummary array, returns -1 if not found
    Function FindPaymentSummaryByLineNo (Const LineNo : Integer) : Integer;

    // Writes the details to a cromulent XML string
    Function ToXML : ANSIString;
  End; // IOrderPaymentsTransactionInfo

  //------------------------------

// Creates and returns a new instance of the IOrderPaymentsTransactionInfo which details
// the transactions position in the Order Payments subsystem, optionally puts a record lock
// on the originating Sales Order
Function OPTransactionInfo (Const Transaction : InvRec) : IOrderPaymentsTransactionInfo; Overload;
Function OPTransactionInfo (Const Transaction : InvRec; Const Account : CustRec) : IOrderPaymentsTransactionInfo; Overload;

Implementation

Uses ComnUnit, Contnrs, Dialogs, BtrvU2, BTKeys1U, BTSupU1, CurrncyU, MiscU, ETStrU, ETMiscU,
     SQLUtils, SQLCallerU, SQLTransactionLines, oBtrieveFile, oOrderPaymentsBaseTransactionInfo,
     oOPVATPayMemoryList, ADOConnect;

Type
  // Pointer to Transaction Header record - needed so Transaction Line can pickup Settlement Discount
  // Fields
  pInvRec = ^InvRec;

  //------------------------------

  // Private interface for the transaction line object to support internal only functionality
  IOrderPaymentsTransactionLineInfo_Internal = Interface
    ['{D751AC08-62E5-4DF4-9EB8-4A811C1C4F2B}']
    // --- Internal Methods to implement Public Properties ---
    // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
    Function GetLinePaymentSummaryInfo : IOrderPaymentsTransactionLinePaymentSummaryInfo;
    Procedure SetLinePaymentSummaryInfo (Value : IOrderPaymentsTransactionLinePaymentSummaryInfo);

    // ------------------ Public Properties ------------------
    // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
    Property optlLinePaymentSummaryInfo : IOrderPaymentsTransactionLinePaymentSummaryInfo Read GetLinePaymentSummaryInfo Write SetLinePaymentSummaryInfo;

    // ------------------- Public Methods --------------------
    // Processes a VAT Payment Details row found by the Pervasive/MSSQL descendants
    Procedure AddVATPayDetails(Const VATPayDetails : IOrderPaymentsPaymentInfo);
    // Updates the line with original order values in order to correctly determine the maximum payment values
    Procedure SetOrderDetails(Const OrderLine : IDetail);
  End; // IOrderPaymentsTransactionLineInfo_Internal

  //------------------------------

  // Private interface for the transaction line object to support internal only functionality
  IOrderPaymentsTransactionLinePaymentSummaryInfo_Internal = Interface
    ['{812CE287-791F-4FEB-AEEE-4FDE787FA305}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    Procedure UpdatePaymentSummary(Const PaymentInfo : IOrderPaymentsPaymentInfo);
  End; // IOrderPaymentsTransactionLinePaymentSummaryInfo_Internal

  //------------------------------

  TOrderPaymentsPaymentInfo = Class(TInterfacedObject, IOrderPaymentsPaymentInfo)
  Private
    FPaymentDetails : OrderPaymentsVATPayDetailsRecType;

    // IOrderPaymentsPaymentInfo
    Function GetOrderRef : ShortString;
    Function GetReceiptRef : ShortString;
    Function GetTransRef : ShortString;
    Function GetLineOrderNo : LongInt;
    Function GetSORABSLineNo : LongInt;
    Function GetType : enumOrderPaymentsVATPayDetailsType;
    Function GetCurrency : Byte;
    Function GetDescription : ShortString;
    Function GetVATCode : Char;
    Function GetGoodsValue : Double;
    Function GetVATValue : Double;
    Function GetUserName : ShortString;
    Function GetDateCreated : ShortString;
    Function GetTimeCreated : ShortString;
  Public
    Constructor Create (Const PaymentDetails : OrderPaymentsVATPayDetailsRecType);
    Destructor Destroy; Override;
  End; // TOrderPaymentsPaymentInfo

  //------------------------------

  TOrderPaymentsTransactionLineInfo = Class(TInterfacedObject, IOrderPaymentsTransactionLineInfo, IOrderPaymentsTransactionLineInfo_Internal)
  Private
    FTransaction : pInvRec;
    FTransactionLine : IDetail;

    FPaymentDetails : TInterfaceList;

    // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
    FLinePaymentSummaryIntf : IOrderPaymentsTransactionLinePaymentSummaryInfo;

    // Original Order Value
    FOrder : pInvRec;
    FOriginalOrderGoods : Double;
    FOriginalOrderVAT : Double;
    FOriginalOrderWriteOffGoods : Double;
    FOriginalOrderWriteOffVAT : Double;

    // Net payment position from OPVATPay
    FNetPaymentGoods : Double;
    FNetPaymentVAT : Double;

    // Value of payment currently being generated
    FCurrentPaymentGoods : Double;
    FCurrentPaymentVAT : Double;

    // IOrderPaymentsTransactionLineInfo
    Function GetTransactionLine : IDetail;
    Function GetVATType : VATType;
    Function GetLineNo : Integer;

    Function GetOrderLineTotal : Double;
    Function GetOrderLineGoods : Double;
    Function GetOrderLineVAT : Double;
    Function GetLineTotal : Double;
    Function GetLineGoods : Double;
    Function GetLineVAT : Double;

    // Net payment position from OPVATPay
    Function GetNetPaymentTotal : Double;
    Function GetNetPaymentGoods : Double;
    Function GetNetPaymentVAT : Double;

    // Outstanding position - Original Value - Net Payments
    Function GetOutstandingTotal : Double;
    Function GetOutstandingGoods : Double;
    Function GetOutstandingVAT : Double;

    Function GetCurrentPaymentTotal : Double;
    Procedure SetCurrentPaymentTotal (Value : Double);
    Function GetCurrentPaymentGoods : Double;
    Function GetCurrentPaymentVAT : Double;

    Function GetHasWriteOffs : Boolean;
    Function GetWriteOffGoods : Double;
    Function GetWriteOffVAT : Double;
    // MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
    Function GetWriteOffTotal : Double;

    // IOrderPaymentsTransactionLineInfo_Internal
    // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
    Function GetLinePaymentSummaryInfo : IOrderPaymentsTransactionLinePaymentSummaryInfo;
    Procedure SetLinePaymentSummaryInfo (Value : IOrderPaymentsTransactionLinePaymentSummaryInfo);
    // Processes a VAT Payment Details row found by the Pervasive/MSSQL descendants
    Procedure AddVATPayDetails(Const VATPayDetails : IOrderPaymentsPaymentInfo);
    // Updates the line with original order values in order to correctly determine the maximum payment values
    Procedure SetOrderDetails(Const OrderLine : IDetail);
  Public
    Constructor Create (Const Order, Transaction : pInvRec; Const TransactionLine : IDetail);
    Destructor Destroy; Override;
  End; // TOrderPaymentsTransactionLineInfo

  //------------------------------

  TOrderPaymentsTransactionLinePaymentSummaryInfo = Class(TInterfacedObject, IOrderPaymentsTransactionLinePaymentSummaryInfo, IOrderPaymentsTransactionLinePaymentSummaryInfo_Internal)
  Private
    FPaymentInfo : IOrderPaymentsPaymentInfo;
    FTotalPaymentGoods : Double;
    FTotalPaymentVAT : Double;
    FTotalRefundGoods : Double;
    FTotalRefundVAT : Double;

    // IOrderPaymentsTransactionLinePaymentSummaryInfo
    Function GetLineNo : Integer;
    Function GetNetPayments : Double;
    Function GetNetPaymentGoods : Double;
    Function GetNetPaymentVAT : Double;
    Function GetTotalPayments : Double;
    Function GetTotalPaymentGoods : Double;
    Function GetTotalPaymentVAT : Double;
    Function GetTotalRefunds : Double;
    Function GetTotalRefundGoods : Double;
    Function GetTotalRefundVAT : Double;
    Procedure UpdatePaymentSummary(Const PaymentInfo : IOrderPaymentsPaymentInfo);
  Public
    Constructor Create (Const PaymentInfo : IOrderPaymentsPaymentInfo);
    Destructor Destroy; Override;
  End; // TOrderPaymentsTransactionLinePaymentSummaryInfo

  //------------------------------

  TOrderPaymentsTransactionInfo = Class(TOrderPaymentsBaseTransactionInfo, IOrderPaymentsTransactionInfo)
  Private
    FAccount : CustRec;

    FCurrentTransactionLines : TInterfaceList;
    FCurrentTransactionGoods : Array[VATType] of Double;

    // Contains a list of the references to the payment details objects read from OPVATPay
    FPaymentDetails : TInterfaceList;

    // Contains a summary of the order level payment/refund position for each transaction line
    FPaymentSummary : TInterfaceList;

    FMaxPayment : Double;
    FLineCountByVATCode : Array [VATType] Of Integer;
    FOutstandingGoodsByVATCode : Array [VATType] Of Double;
    FOutstandingVATByVATCode : Array [VATType] Of Double;

    FTotalPaymentsGoods : Double;
    FTotalPaymentsVAT : Double;
    FTotalRefundsGoods : Double;
    FTotalRefundsVAT : Double;
    FNetPaymentsGoods : Double;
    FNetPaymentsVAT : Double;

    // Calculates the totals from the Transaction, Transaction Lines and Payment Details
    Procedure UpdateTotals;
    // Updates the Payment Summary totals
    Procedure UpdatePaymentSummary (Const PaymentInfo : IOrderPaymentsPaymentInfo);
    // Loads the original SOR lines in to determine the order values - this is required to determine
    // maximum payment values when on SDN/SIN transactions
    Procedure LoadOrderLines; Virtual; Abstract;

    // IOrderPaymentsTransactionInfo -----------------------------
    Function GetOrder : InvRec;
    Function GetOrderLocked : Boolean;
    Function GetOrderLockPos : LongInt;
    Function GetAccount : CustRec;
    Function GetTransactionGoods(Index : VATType) : Double;
    Function GetTransactionLineCount : Integer;
    Function GetTransactionLines(Index : Integer) : IOrderPaymentsTransactionLineInfo;
    Function GetTransactionTotal : Double;
    Function GetTransactionTotalGoods : Double;
    Function GetTransactionTotalVAT : Double;

    Function GetPaymentDetailsCount : Integer;
    Function GetPaymentDetails (Index : Integer) : IOrderPaymentsPaymentInfo;

    Function GetPaymentSummaryCount : Integer;
    Function GetPaymentSummary(Index : Integer) : IOrderPaymentsTransactionLinePaymentSummaryInfo;

    Function GetTotalPayments : Double;
    Function GetTotalPaymentsGoods : Double;
    Function GetTotalPaymentsVAT : Double;
    Function GetTotalRefunds : Double;
    Function GetTotalRefundsGoods : Double;
    Function GetTotalRefundsVAT : Double;
    Function GetNetPayments : Double;
    Function GetNetPaymentsGoods : Double;
    Function GetNetPaymentsVAT : Double;
    Function GetMaxPayment : Double;
    Function GetOutstandingTotal : Double;
    Function GetOutstandingTotalByVATCode (Index : VATType) : Double;
    Function GetOutstandingGoodsByVATCode (Index : VATType) : Double;
    Function GetOutstandingVATByVATCode (Index : VATType) : Double;
    Function GetLineCountByVATCode (Index : VATType) : Integer;
    // MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
    Function GetWriteOffTotal : Double;

    Function HasManualPayments(SORRef: string): Boolean; virtual; abstract;
    // Returns TRUE if a payment can be taken for the current transaction
    Function CanTakePayment : Boolean;
    // Finds the default Payment GL Code for the Transaction's Account
    Function GetDefaultPaymentGL : LongInt;
    // Loads the VAT Payment Details
    Procedure LoadVATPayDetails; Virtual;
    // Returns the index of a Transaction Line with a specified ABS Line No in the
    // optTransactionLines array, returns -1 if not found
    Function FindLineByLineNo (Const LineNo : Integer) : Integer;
    // Returns the index of a Payment Summary Line with a specified ABS Line No in the
    // optPaymentSummary array, returns -1 if not found
    Function FindPaymentSummaryByLineNo (Const LineNo : Integer) : Integer;
    // Writes the details to a cromulent XML string
    Function ToXML : ANSIString;
    // Returns TRUE is the specified payment reference exists in the Payment Details list and is a
    // payment against the current transaction
    Function PaymentAppliesToCurrentTransaction(PaymentRef : ShortString) : Boolean;
  Protected
    // Adds a transaction line found by the Pervasive/MSSQL descendants into the lines list
    Procedure AddLine (Const TransactionLine : IDetail);
    // Processes a VAT Payment Details row found by the Pervasive/MSSQL descendants
    Procedure AddVATPayDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
    // Updates a line for the current transaction with original order values from the original order
    // line in order to correctly determine the maximum payment values
    Procedure ProcessOrderLine (Const OrderLine : IDetail); Override;
    // Loads the Transaction Lines for optTransaction and calculates the Goods values
    Procedure LoadTransactionLines; Override;
  Public
    Constructor Create (Const Transaction : InvRec);
    Constructor CreateWithAccount (Const Transaction : InvRec; Const Account : CustRec);
    Destructor Destroy; Override;
  End; // TOrderPaymentsTransactionInfo

  //------------------------------

  TPervasiveOrderPaymentsTransactionInfo = Class(TOrderPaymentsTransactionInfo)
  Private
  Protected
    // Loads the Transaction Lines for optTransaction
    Procedure LoadTransactionLines; Override;
    // Loads the VAT Payment Details
    Procedure LoadVATPayDetails; Override;
    // Loads the original SOR lines in to determine the order values - this is required to determine
    // maximum payment values when on SDN/SIN transactions
    Procedure LoadOrderLines; Override;
  Public
    // CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment
    // Returns TRUE if payments have been allocated to the specified Sales
    // Order outside the Order Payments system
    Function HasManualPayments(SORRef: string): Boolean; override;
  End; // TPervasiveOrderPaymentsTransactionInfo

  //------------------------------

  TMSSQLOrderPaymentsTransactionInfo = Class(TOrderPaymentsTransactionInfo)
  Private
    FSQLCaller: TSQLCaller;
    FCompanyCode: AnsiString;
    // Loads the Transaction Lines for optTransaction
    Procedure LoadTransactionLines; Override;
    // Loads the VAT Payment Details
    Procedure LoadVATPayDetails; Override;
    // Loads the original SOR lines in to determine the order values - this is required to determine
    // maximum payment values when on SDN/SIN transactions
    Procedure LoadOrderLines; Override;
    Procedure PrepareSQLCaller;
  Public
    Destructor Destroy; Override;
    // CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment
    // Returns TRUE if payments have been allocated to the specified Sales
    // Order outside the Order Payments system
    Function HasManualPayments(SORRef: string): Boolean; override;
  End; // TMSSQLOrderPaymentsTransactionInfo

//=========================================================================

Function OPTransactionInfo (Const Transaction : InvRec) : IOrderPaymentsTransactionInfo;
Begin // OPTransactionInfo
  If SQLUtils.UsingSQL Then
    Result := TMSSQLOrderPaymentsTransactionInfo.Create (Transaction)
  Else
    Result := TPervasiveOrderPaymentsTransactionInfo.Create (Transaction);
End; // OPTransactionInfo

Function OPTransactionInfo (Const Transaction : InvRec; Const Account : CustRec) : IOrderPaymentsTransactionInfo;
Begin // OPTransactionInfo
  If SQLUtils.UsingSQL Then
    Result := TMSSQLOrderPaymentsTransactionInfo.CreateWithAccount (Transaction, Account)
  Else
    Result := TPervasiveOrderPaymentsTransactionInfo.CreateWithAccount (Transaction, Account);
End; // OPTransactionInfo

//=========================================================================

Constructor TOrderPaymentsPaymentInfo.Create (Const PaymentDetails : OrderPaymentsVATPayDetailsRecType);
Begin // Create
  Inherited Create;
  FPaymentDetails := PaymentDetails;
End; // Create

//------------------------------

Destructor TOrderPaymentsPaymentInfo.Destroy;
Begin // Destroy
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TOrderPaymentsPaymentInfo.GetOrderRef : ShortString;
Begin // GetOrderRef
  Result := Trim(FPaymentDetails.vpOrderRef);  // Remove any trailing spaces from DB padding
End; // GetOrderRef

//------------------------------

Function TOrderPaymentsPaymentInfo.GetReceiptRef : ShortString;
Begin // GetReceiptRef
  Result := Trim(FPaymentDetails.vpReceiptRef);  // Remove any trailing spaces from DB padding
End; // GetReceiptRef

//------------------------------

Function TOrderPaymentsPaymentInfo.GetTransRef : ShortString;
Begin // GetTransRef
  Result := Trim(FPaymentDetails.vpTransRef);  // Remove any trailing spaces from DB padding
End; // GetTransRef

//------------------------------

Function TOrderPaymentsPaymentInfo.GetLineOrderNo : LongInt;
Begin // GetLineOrderNo
  Result := FPaymentDetails.vpLineOrderNo;
End; // GetLineOrderNo

//------------------------------

Function TOrderPaymentsPaymentInfo.GetSORABSLineNo : LongInt;
Begin // GetSORABSLineNo
  Result := FPaymentDetails.vpSORABSLineNo;
End; // GetSORABSLineNo

//------------------------------

Function TOrderPaymentsPaymentInfo.GetType : enumOrderPaymentsVATPayDetailsType;
Begin // GetType
  Result := FPaymentDetails.vpType;
End; // GetType

//------------------------------

Function TOrderPaymentsPaymentInfo.GetCurrency : Byte;
Begin // GetCurrency
  Result := FPaymentDetails.vpCurrency;
End; // GetCurrency

//------------------------------

Function TOrderPaymentsPaymentInfo.GetDescription : ShortString;
Begin // GetDescription
  Result := FPaymentDetails.vpDescription;
End; // GetDescription

//------------------------------

Function TOrderPaymentsPaymentInfo.GetVATCode : Char;
Begin // GetVATCode
  Result := FPaymentDetails.vpVATCode;
End; // GetVATCode

//------------------------------

Function TOrderPaymentsPaymentInfo.GetGoodsValue : Double;
Begin // GetGoodsValue
  Result := FPaymentDetails.vpGoodsValue;
End; // GetGoodsValue

//------------------------------

Function TOrderPaymentsPaymentInfo.GetVATValue : Double;
Begin // GetVATValue
  Result := FPaymentDetails.vpVATValue;
End; // GetVATValue

//------------------------------

Function TOrderPaymentsPaymentInfo.GetUserName : ShortString;
Begin // GetUserName
  Result := FPaymentDetails.vpUserName;
End; // GetUserName

//------------------------------

Function TOrderPaymentsPaymentInfo.GetDateCreated : ShortString;
Begin // GetDateCreated
  Result := FPaymentDetails.vpDateCreated;
End; // GetDateCreated

//------------------------------

Function TOrderPaymentsPaymentInfo.GetTimeCreated : ShortString;
Begin // GetTimeCreated
  Result := FPaymentDetails.vpTimeCreated;
End; // GetTimeCreated

//=========================================================================

Constructor TOrderPaymentsTransactionLineInfo.Create (Const Order, Transaction : pInvRec; Const TransactionLine : IDetail);
Begin // Create
  Inherited Create;

  // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
  FLinePaymentSummaryIntf := NIL;

  // Net payment position from OPVATPay
  FNetPaymentGoods := 0.0;
  FNetPaymentVAT := 0.0;

  FCurrentPaymentGoods := 0.0;
  FCurrentPaymentVAT := 0.0;

  FOriginalOrderGoods := 0.0;
  FOriginalOrderVAT := 0.0;
  FOriginalOrderWriteOffGoods := 0.0;
  FOriginalOrderWriteOffVAT := 0.0;

  FPaymentDetails := TInterfaceList.Create;

  FOrder := Order;
  FTransaction := Transaction;
  FTransactionLine := TransactionLine;

  If (FTransactionLine.IdDocHed = SOR) Then
    SetOrderDetails(FTransactionLine);
End; // Create

//------------------------------

Destructor TOrderPaymentsTransactionLineInfo.Destroy;
Begin // Destroy
  // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
  FLinePaymentSummaryIntf := NIL;

  FPaymentDetails.Clear;
  FreeAndNIL(FPaymentDetails);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// IOrderPaymentsTransactionLineInfo_Internal
// Processes a VAT Payment Details row found by the Pervasive/MSSQL descendants
Procedure TOrderPaymentsTransactionLineInfo.AddVATPayDetails(Const VATPayDetails : IOrderPaymentsPaymentInfo);

  //------------------------------

  // Takes the SRC OurRef of a payment being refunded and looks up the original SIN OurRef that
  // was being paid by the payment SRC
  Function FindOriginalInvoice(Const PaymentSRCRef : ShortString) : ShortString;
  var
    PayDets : IOrderPaymentsPaymentInfo;
    I : integer;
  Begin // FindOriginalInvoice
    Result := '';

    For I := 0 To FPaymentDetails.Count - 1 Do
    Begin
      // Setup a local reference so the debugger can actually provide information
      PayDets := FPaymentDetails[i] as IOrderPaymentsPaymentInfo;
      If (PayDets.vpType = vptSINPayment) And (PayDets.vpReceiptRef = PaymentSRCRef) Then
      Begin
        Result := PayDets.vpTransRef;
        Break;
      End; // If (PayDets.vpType = vptSINPayment) And (PayDets.vpReceiptRef = PaymentSRCRef)
    End; // For I
    PayDets := NIL;
  End; // FindOriginalInvoice

  //------------------------------

  //PR: 05/02/2015 ABSEXCH-16126 Function to check if we need to include a match record - see below.
  //                             Returns True if we do, False if we don't because the match record is for a payment on a SIN.
  function AlreadyHaveSINPayOrRefundRecord : Boolean;
  var
    PayDets : IOrderPaymentsPaymentInfo;
    i : integer;
  begin
    Result := False;

(*
    //Iterate through payment details list and see if we have a sin payment or refund rec
    //that corresponds to the matching rec in VATPayDetails. The match is on
    //Goods and VAT value, SOR Line no, Receipt OurRef and Invoice OurRef
    for i := 0 to FPaymentDetails.Count - 1 do
    with FPaymentDetails[i] as IOrderPaymentsPaymentInfo do
      if (vpType in [vptSINPayment, vptSINValueRefund]) and
         (vpSORAbsLineNo = VATPayDetails.vpSORAbsLineNo) and
         (vpReceiptRef = VATPayDetails.vpReceiptRef) and
         (vpTransRef = VATPayDetails.vpTransRef) then
      begin
        Result := True;
        Break;
      end;
*)

    // MH 09/10/2015 2015-R1.1 ABSEXCH-16948: Replaced above code as it was incorrectly returning
    //                                        False for Matching entries against Refunds against SIN's
    For I := 0 To FPaymentDetails.Count - 1 Do
    Begin
      // Setup a local reference so the debugger can actually provide information
      PayDets := FPaymentDetails[i] as IOrderPaymentsPaymentInfo;
      If (
           (PayDets.vpType = vptSINPayment) and
           (PayDets.vpSORAbsLineNo = VATPayDetails.vpSORAbsLineNo) and
           (PayDets.vpReceiptRef = VATPayDetails.vpReceiptRef) and
           (PayDets.vpTransRef = VATPayDetails.vpTransRef)
         )
         Or
         (
           (PayDets.vpType = vptSINValueRefund) and
           (PayDets.vpSORAbsLineNo = VATPayDetails.vpSORAbsLineNo) and
           (PayDets.vpReceiptRef = VATPayDetails.vpReceiptRef) and
           // The TransRef on a SIN Value Refund line is the SRC being refunded, whereas on the
           // Matching line it will be the SIN being refunded - so we need to perform a lookup
           // on the ourref of the SRC being refunded to find out what SIN it was paying to
           // determine whether the Matching line should be processed
           (FindOriginalInvoice(PayDets.vpTransRef) = VATPayDetails.vpTransRef)
         ) Then
      Begin
        Result := True;
        Break;
      End; // If ((PayDets.vpType = vptSINPayment) and ...
    End; // For I
    PayDets := NIL;
  end;

  //------------------------------

Begin // AddVATPayDetails
  // Add payment details into internal list
  FPaymentDetails.Add(VATPayDetails);

  // Update line totals
  Case VATPayDetails.vpType Of
    // Payment against an SOR
    vptSORPayment,
    // Payment against an SDN
    vptSDNPayment,
    // Payment against an SIN
    vptSINPayment     : Begin
                          FNetPaymentGoods := Round_Up(FNetPaymentGoods + VATPayDetails.vpGoodsValue, 2);
                          FNetPaymentVAT := Round_Up(FNetPaymentVAT + VATPayDetails.vpVATValue, 2);
                        End; // vptSORPayment, vptSDNPayment, vptSINPayment

    // Refund against an SOR
    vptSORValueRefund,
    // Value Refund against an SIN - generates -SRC
    vptSINValueRefund,
    // Stock Refund against an SIN - SRF generated instead of -SRC
    vptSINStockRefund : Begin
                          FNetPaymentGoods := Round_Up(FNetPaymentGoods - VATPayDetails.vpGoodsValue, 2);
                          FNetPaymentVAT := Round_Up(FNetPaymentVAT - VATPayDetails.vpVATValue, 2);
                        End; // vptSORValueRefund

    // Payment Matched to Invoice
    vptMatching       : Begin
                          // PR: 05/02/2015 ABSEXCH-16126
                          // Where we have a part-payment against a SOR, the SOR is then delivered and
                          // invoiced, and we then pay the SIN, we need to include match records to
                          // take account of the pre-payment. However, we need to exclude match records
                          // for part-payments against the SIN. To do this we use the function
                          // AlreadyHaveSINPayOrRefundRecord to check if the matching records
                          // belong to a payment against the SIN.
                          if (FTransaction.InvDocHed = SIN) and not AlreadyHaveSINPayOrRefundRecord then
                          begin
                            FNetPaymentGoods := Round_Up(FNetPaymentGoods + VATPayDetails.vpGoodsValue, 2);
                            FNetPaymentVAT := Round_Up(FNetPaymentVAT + VATPayDetails.vpVATValue, 2);
                          end;
                        End; // vptMatching
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionLineInfo.AddVATPayDetails: Unhandled vpType (' + IntToStr(Ord(VATPayDetails.vpType)) + ')');
  End; // Case VATPayDetails.vpType
End; // AddVATPayDetails

//-------------------------------------------------------------------------

// IOrderPaymentsTransactionLineInfo_Internal
// Updates the line with original order values in order to correctly determine the maximum payment values
Procedure TOrderPaymentsTransactionLineInfo.SetOrderDetails(Const OrderLine : IDetail);
Var
  TempLine : IDetail;
Begin // SetOrderDetails
  FOriginalOrderGoods := Round_Up (InvLTotal (OrderLine, BOn, (FOrder^.DiscSetl * Ord(FOrder^.DiscTaken))), 2);
  FOriginalOrderVAT := OrderLine.VAT;

  // Calculate Write-Off value
  If (OrderLine.QtyWOFF <> 0.0) Then
  Begin
    // Create a fake line for the Written Off quantity and recalculate the totals
    TempLine := OrderLine;
    TempLine.Qty := TempLine.QtyWOff;
    FOriginalOrderWriteOffGoods := Round_Up (InvLTotal (TempLine, BOn, (FOrder^.DiscSetl * Ord(FOrder^.DiscTaken))), 2);

    CalcVAT(TempLine, FOrder^.DiscSetl);
    FOriginalOrderWriteOffVAT := TempLine.VAT;
  End; // If (OrderLine.QtyWOFF <> 0.0)
End; // SetOrderDetails

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionLineInfo.GetTransactionLine : IDetail;
Begin // GetTransactionLine
  Result := FTransactionLine
End; // GetTransactionLine

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetVATType : VATType;
Begin // GetVATType
  Result := GetVATNo(FTransactionLine.VATCode, FTransactionLine.VATIncFlg);
End; // GetVATType

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetHasWriteOffs : Boolean;
Begin // GetHasWriteOffs
  Result := (FTransactionLine.QtyWOff <> 0.0);
End; // GetHasWriteOffs

// MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
Function TOrderPaymentsTransactionLineInfo.GetWriteOffTotal : Double;
Begin // GetWriteOffTotal
  Result := Round_Up (GetWriteOffGoods + GetWriteOffVAT, 2);
End; // GetWriteOffTotal

Function TOrderPaymentsTransactionLineInfo.GetWriteOffGoods : Double;
Begin // GetWriteOffGoods
  Result := FOriginalOrderWriteOffGoods
End; // GetWriteOffGoods

Function TOrderPaymentsTransactionLineInfo.GetWriteOffVAT : Double;
Begin // GetWriteOffVAT
  Result := FOriginalOrderWriteOffVAT
End; // GetWriteOffVAT

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetLineNo : Integer;
Begin // GetLineNo
  If (FTransactionLine.IdDocHed = SOR) Then
    Result := FTransactionLine.ABSLineNo
  Else
    Result := FTransactionLine.SOPLineNo;
End; // GetLineNo

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetOrderLineTotal : Double;
Begin // GetOrderLineTotal
  Result := GetOrderLineGoods + GetOrderLineVAT
End; // GetOrderLineTotal

Function TOrderPaymentsTransactionLineInfo.GetOrderLineGoods : Double;
Begin // GetOrderLineGoods
  Result := FOriginalOrderGoods;
End; // GetOrderLineGoods

Function TOrderPaymentsTransactionLineInfo.GetOrderLineVAT : Double;
Begin // GetOrderLineVAT
  Result := FOriginalOrderVAT;
End; // GetOrderLineVAT

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetLineTotal : Double;
Begin // GetLineTotal
  Result := Round_Up (GetLineGoods + GetLineVAT, 2);
End; // GetLineTotal

Function TOrderPaymentsTransactionLineInfo.GetLineGoods : Double;
Begin // GetLineGoods
  Result := Round_Up (InvLTotal (FTransactionLine, BOn, (FTransaction^.DiscSetl * Ord(FTransaction^.DiscTaken))), 2)
End; // GetLineGoods

Function TOrderPaymentsTransactionLineInfo.GetLineVAT : Double;
Begin // GetLineVAT
  Result := Round_Up (FTransactionLine.VAT, 2);
End; // GetLineVAT

//------------------------------

// Net payment position from OPVATPay
Function TOrderPaymentsTransactionLineInfo.GetNetPaymentTotal : Double;
Begin // GetNetPaymentTotal
  Result := Round_Up(GetNetPaymentGoods + GetNetPaymentVAT, 2);
End; // GetNetPaymentTotal

Function TOrderPaymentsTransactionLineInfo.GetNetPaymentGoods : Double;
Begin // GetNetPaymentGoods
  Result := FNetPaymentGoods    // Already rounded to 2dp
End; // GetNetPaymentGoods

Function TOrderPaymentsTransactionLineInfo.GetNetPaymentVAT : Double;
Begin // GetNetPaymentVAT
  Result := FNetPaymentVAT      // Already rounded to 2dp
End; // GetNetPaymentVAT

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetOutstandingTotal : Double;
Begin // GetOutstandingTotal
  Result := Round_Up(GetOutstandingGoods + GetOutstandingVAT, 2);
End; // GetOutstandingTotal

Function TOrderPaymentsTransactionLineInfo.GetOutstandingGoods : Double;
Begin // GetOutstandingGoods
  Result := Round_Up(GetLineGoods - GetNetPaymentGoods, 2);
End; // GetOutstandingGoods

Function TOrderPaymentsTransactionLineInfo.GetOutstandingVAT : Double;
Begin // GetOutstandingVAT
  Result := Round_Up(GetLineVAT - GetNetPaymentVAT, 2);
End; // GetOutstandingVAT

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetCurrentPaymentTotal : Double;
Begin // GetCurrentPaymentTotal
  Result := FCurrentPaymentGoods + FCurrentPaymentVAT;
End; // GetCurrentPaymentTotal
Procedure TOrderPaymentsTransactionLineInfo.SetCurrentPaymentTotal (Value : Double);
Var
  VATRate, MaxOutstandingVAT : Double;
Begin // SetCurrentPaymentTotal
  // The Payment Total consists of payment for Goods + VAT - we need to split that out into
  // separate Goods + VAT fields as we need to know exactly how much VAT to declare for the payments.
  If (Value > GetOutstandingTotal) Then
  Begin
    // With Manual VAT you can end up with a payment greater than the outstanding line value if the
    // manual VAT figure is higher than the exchequer calculated VAT - the increased value will be
    // allocated to the last line for each VAT code

    // Work out the remaining goods value and then allocate the remainder to VAT
    FCurrentPaymentGoods := GetOutstandingGoods;
    FCurrentPaymentVAT := Round_Up(Value - FCurrentPaymentGoods, 2);
  End // If (Value > GetOutstandingTotal)
  // MH 19/09/2014 ABSEXCH-15633: Modified to use pre-calculated figures as pro-rata approach was
  //                              causing overpayment of VAT
  Else If (Value = GetOutstandingTotal) Then
  Begin
    FCurrentPaymentGoods := GetOutstandingGoods;
    FCurrentPaymentVAT := GetOutstandingVAT;
  End // If (Value = GetOutstandingTotal)
  Else
  Begin
    If (Value = GetLineTotal) Then
    Begin
      // Full Payment - use Line VAT figure
      FCurrentPaymentVAT := GetLineVAT;
    End // If (Value = GetLineTotal)
    Else
    Begin
      // Part payment - work out VAT included in the payment using the VAT Rate

      // Get VAT Rate for VAT Code/Inclusive VAT Code, e.g. 'S' = 0.2
      VATRate := SyssVAT^.VATRates.VAT[GetVATType].Rate;

      // Calculate the inclusive VAT Element
      FCurrentPaymentVAT := Round_Up((Value / (1 + VATRate)) * VATRate, 2);
      If (FCurrentPaymentVAT > GetLineVAT) Then
        FCurrentPaymentVAT := GetLineVAT;
    End; // Else

    // MH 08/01/2015 v7.1 ABSEXCH-15829: Check VAT value doesn't exceed the maximum payable VAT for the line
    If Assigned(FLinePaymentSummaryIntf) Then
    Begin
      // work out the maximum VAT that can be paid = Total Line VAT from Order - Total Prepaid VAT from all Payments
      MaxOutstandingVAT := Round_Up(FOriginalOrderVAT - FLinePaymentSummaryIntf.psNetPaymentVAT, 2);
      If (MaxOutstandingVAT < FCurrentPaymentVAT) Then
      Begin
        // If FCurrentPaymentVAT exceeds that value then limit the VAT payment to that value and
        // transfer the difference to the goods value as it is most likely a rounding difference
        // in the VAT calculation
        FCurrentPaymentVAT := MaxOutstandingVAT;
      End; // If (MaxOutstandingVAT < FCurrentPaymentVAT)
    End; // If Assigned(FLinePaymentSummaryIntf)

    // Treat remainder of payment as the Goods value to ensure it adds up
    FCurrentPaymentGoods := Round_Up(Value - FCurrentPaymentVAT, 2);
  End; // Else
End; // SetCurrentPaymentTotal

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetCurrentPaymentGoods : Double;
Begin // GetCurrentPaymentGoods
  Result := FCurrentPaymentGoods
End; // GetCurrentPaymentGoods

//------------------------------

Function TOrderPaymentsTransactionLineInfo.GetCurrentPaymentVAT : Double;
Begin // GetCurrentPaymentVAT
  Result := FCurrentPaymentVAT
End; // GetCurrentPaymentVAT

//-------------------------------------------------------------------------

// MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
Function TOrderPaymentsTransactionLineInfo.GetLinePaymentSummaryInfo : IOrderPaymentsTransactionLinePaymentSummaryInfo;
Begin // GetLinePaymentSummaryInfo
  Result := FLinePaymentSummaryIntf;
End; // GetLinePaymentSummaryInfo
Procedure TOrderPaymentsTransactionLineInfo.SetLinePaymentSummaryInfo (Value : IOrderPaymentsTransactionLinePaymentSummaryInfo);
Begin // SetLinePaymentSummaryInfo
  FLinePaymentSummaryIntf := Value;
End; // SetLinePaymentSummaryInfo

//=========================================================================

Constructor TOrderPaymentsTransactionLinePaymentSummaryInfo.Create (Const PaymentInfo : IOrderPaymentsPaymentInfo);
Begin // Create
  Inherited Create;

  FTotalPaymentGoods := 0.0;
  FTotalPaymentVAT := 0.0;

  FTotalRefundGoods := 0.0;
  FTotalRefundVAT := 0.0;

  // Record line details and update the running totals
  FPaymentInfo := PaymentInfo;
  UpdatePaymentSummary(FPaymentInfo);
End; // Create

//------------------------------

Destructor TOrderPaymentsTransactionLinePaymentSummaryInfo.Destroy;
Begin // Destroy
  FPaymentInfo := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TOrderPaymentsTransactionLinePaymentSummaryInfo.UpdatePaymentSummary(Const PaymentInfo : IOrderPaymentsPaymentInfo);
Begin // UpdatePaymentSummary
  // Update line totals
  Case PaymentInfo.vpType Of
    // Payment against an SOR
    vptSORPayment,
    // Payment against an SDN
    vptSDNPayment,
    // Payment against an SIN
    vptSINPayment     : Begin
                          FTotalPaymentGoods := Round_Up(FTotalPaymentGoods + PaymentInfo.vpGoodsValue, 2);
                          FTotalPaymentVAT := Round_Up(FTotalPaymentVAT + PaymentInfo.vpVATValue, 2);
                        End; // vptSORPayment, vptSDNPayment, vptSINPayment

    // Refund against an SOR
    vptSORValueRefund,
    // Value Refund against an SIN - generates -SRC
    vptSINValueRefund,
    // Stock Refund against an SIN - SRF generated instead of -SRC
    vptSINStockRefund : Begin
                          FTotalRefundGoods := Round_Up(FTotalRefundGoods + PaymentInfo.vpGoodsValue, 2);
                          FTotalRefundVAT := Round_Up(FTotalRefundVAT + PaymentInfo.vpVATValue, 2);
                        End; // vptSORValueRefund

    // Payment Matched to Invoice
    vptMatching       : Begin
                          // Do we need to do anything?
                        End; // vptMatching
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionLinePaymentSummaryInfo.UpdatePaymentSummary: Unhandled vpType (' + IntToStr(Ord(PaymentInfo.vpType)) + ')');
  End; // Case VATPayDetails.vpType
End; // UpdatePaymentSummary

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetLineNo : Integer;
Begin // GetLineNo
  Result := FPaymentInfo.vpSORABSLineNo;
End; // GetLineNo

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetNetPayments : Double;
Begin // GetNetPayments
  Result := GetTotalPayments - GetTotalRefunds
End; // GetNetPayments

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetNetPaymentGoods : Double;
Begin // GetNetPaymentGoods
  Result := GetTotalPaymentGoods - GetTotalRefundGoods
End; // GetNetPaymentGoods

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetNetPaymentVAT : Double;
Begin // GetNetPaymentVAT
  Result := GetTotalPaymentVAT - GetTotalRefundVAT
End; // GetNetPaymentVAT

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetTotalPayments : Double;
Begin // GetTotalPayments
  Result := GetTotalPaymentGoods + GetTotalPaymentVAT
End; // GetTotalPayments

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetTotalPaymentGoods : Double;
Begin // GetTotalPaymentGoods
  Result := FTotalPaymentGoods
End; // GetTotalPaymentGoods

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetTotalPaymentVAT : Double;
Begin // GetTotalPaymentVAT
  Result := FTotalPaymentVAT
End; // GetTotalPaymentVAT

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetTotalRefunds : Double;
Begin // GetTotalRefunds
  Result := GetTotalRefundGoods + GetTotalRefundVAT
End; // GetTotalRefunds

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetTotalRefundGoods : Double;
Begin // GetTotalRefundGoods
  Result := FTotalRefundGoods
End; // GetTotalRefundGoods

//------------------------------

Function TOrderPaymentsTransactionLinePaymentSummaryInfo.GetTotalRefundVAT : Double;
Begin // GetTotalRefundVAT
  Result := FTotalRefundVAT
End; // GetTotalRefundVAT

//=========================================================================

Constructor TOrderPaymentsTransactionInfo.Create (Const Transaction : InvRec);
Begin // Create
  // Ancestor creates Client Id / ExLocal and opens basic files and loads order header
  Inherited Create(Transaction);

  FCurrentTransactionLines := TInterfaceList.Create;
  FPaymentDetails := TInterfaceList.Create;
  FPaymentSummary := TInterfaceList.Create;

  // Initialise internal properties
  FillChar(FAccount, SizeOf(FAccount), #0);
  FTotalPaymentsGoods := 0.0;
  FTotalPaymentsVAT := 0.0;
  FTotalRefundsGoods := 0.0;
  FTotalRefundsVAT := 0.0;
  FNetPaymentsGoods := 0.0;
  FNetPaymentsVAT := 0.0;

  FMaxPayment := 0.0;
  FillChar(FLineCountByVATCode, SizeOf(FLineCountByVATCode), #0);
  FillChar(FOutstandingGoodsByVATCode, SizeOf(FOutstandingGoodsByVATCode), #0);
  FillChar(FOutstandingVATByVATCode, SizeOf(FOutstandingVATByVATCode), #0);

  // Read the transaction lines for FCurrentTransaction and the originating order (if different)
  LoadTransactionLines;

  // CJS 2015-01-29 - ABSEXCH-16068 - Order Payments delay in opening SINs
  If (FCurrentTransaction.InvDocHed <> SOR) and FHasLines Then
    LoadOrderLines;

  // Read entries in OPVATPay for Order / Transaction
  LoadVATPayDetails;

  // Calculate values
  UpdateTotals;
End; // Create

//------------------------------

Constructor TOrderPaymentsTransactionInfo.CreateWithAccount (Const Transaction : InvRec; Const Account : CustRec);
Begin // CreateWithAccount
  Create (Transaction);
  If (FullCustCode(Transaction.CustCode) = FullCustCode(Account.CustCode)) Then
    FAccount := Account;
End; // CreateWithAccount

//------------------------------

Destructor TOrderPaymentsTransactionInfo.Destroy;
Begin // Destroy
  FPaymentSummary.Clear;
  FreeAndNIL(FPaymentSummary);

  FPaymentDetails.Clear;
  FreeAndNIL(FPaymentDetails);

  FCurrentTransactionLines.Clear;
  FreeAndNIL(FCurrentTransactionLines);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Returns TRUE if a payment can be taken for the current transaction, for SOR's
// and SIN's this involves checking that the Outstanding Value is > 0, for SDN's
// you have to have the full SDN value oustanding as SDN's acn only be paid in full
Function TOrderPaymentsTransactionInfo.CanTakePayment : Boolean;
Var
  LineIntf : IOrderPaymentsTransactionLineInfo;
  PaymentSummaryIntf : IOrderPaymentsTransactionLinePaymentSummaryInfo;
  I, Idx : Integer;
  iVATCode : VATType;

  //------------------------------

  Function GetUnpaidOrderVATByVATCode(Const VATCode : VATType) : Double;
  Var
    PaymentDetsIntf : IOrderPaymentsPaymentInfo;
    I : Integer;
  Begin // GetUnpaidOrderVATByVATCode
    // Start off with the VAT Footer Total for the VAT Code - need to round as InvVatAnal
    // is a Real48
    Result := Round_Up(FOriginalOrder.InvVatAnal[VATCode], 2);

    // Run through the payment details knocking off any payment details for this VAT Code
    For I := 0 To (GetPaymentDetailsCount - 1) Do
    Begin
      PaymentDetsIntf := GetPaymentDetails(I);
      If (PaymentDetsIntf.vpVATCode = SyssVAT^.VATRates.VAT[VATCode].Code) Then
      Begin
        If (PaymentDetsIntf.vpType In VATPayDetailsTypePaymentSet) Then
          Result := Round_Up(Result - PaymentDetsIntf.vpVATValue, 2)
        Else If (PaymentDetsIntf.vpType In VATPayDetailsTypeRefundSet) Then
          Result := Round_Up(Result + PaymentDetsIntf.vpVATValue, 2);
      End; // If (PaymentDetsIntf.vpVATCode = SyssVAT^.VATRates.VAT[VATCode].Code)
    End; // For I
    PaymentDetsIntf := NIL;
  End; // GetUnpaidOrderVATByVATCode

  //------------------------------

Begin // CanTakePayment
  // Check the SOR was loaded OK (where applicable)
  Result := (FCurrentTransaction.InvDocHed = SOR)
            Or
            (
              (FCurrentTransaction.InvDocHed In [SDN, SIN])
              And
              (FOriginalOrder.InvDocHed = SOR)
              And
              (FOriginalOrder.OurRef = FCurrentTransaction.thOrderPaymentOrderRef)
            );

  If Result Then
  Begin
    // Check there is something to pay
    If (FCurrentTransaction.InvDocHed = SOR) Then
      Result := (GetOutstandingTotal > 0.0)
    Else If (FCurrentTransaction.InvDocHed = SDN) Then
    Begin
      // Check the totals first
      Result := (GetOutstandingTotal >= GetTransactionTotal);

      If Result Then
      Begin
        // Run through the SDN Goods/VAT Totals to ensure that it can be paid in full - this is
        // required to cover Manual VAT differences which increase the VAT Totals.

        // Note: If Manual VAT decreases the VAT Totals then the line checks might fail making
        // it impossible to pay the SDN - not sure if there is anything we can do about that.
        // (You should be able to pay via the SOR or SIN)
        For iVATCode := Low(VATType) To High(VATType) Do
        Begin
          // Check for lines
          If (GetLineCountByVATCode(iVATCode) > 0) Then
          Begin
            // Note: Don't need to check goods at the VAT Code level as they should always match
            // the line totals, whereas due to the joys of Manual VAT we need to compare SDN VAT
            // Total for the VAT Code against the Unpaid Order VAT Total for the VAT Code
            Result := (GetOutstandingVATByVATCode(iVATCode) <= GetUnpaidOrderVATByVATCode(iVATCode));

            If (Not Result) Then
              Break;
          End; // If (GetLineCountByVATCode(iVATCode) > 0)
        End; // For iVATCode
      End; // If Result

      If Result Then
      Begin
        // Run through each line and check that the line can be paid in full - due to being able to
        // refund specific items the payment will not necessarily be even across the lines, and the
        // SDN could only be for 1 specific line.
        For I := 0 To (GetTransactionLineCount - 1) Do
        Begin
          LineIntf := GetTransactionLines(I);

          // MH 08/10/2014 ABSEXCH-15712: Suppressed checking of zero value lines on SDN's
          If (LineIntf.optlLineTotal <> 0.0) Then
          Begin
            // Look for a payment summary line - if no payments have been made then this SDN
            // line can be paid, if payments have been made then we need to calculate the
            // unpaid value and check it is <= the SDN line value
            Idx := FindPaymentSummaryByLineNo (LineIntf.optlLineNo);
            If (Idx >= 0) Then
            Begin
              PaymentSummaryIntf := GetPaymentSummary(Idx);

              // Check SDN Line Goods against the unpaid line value of the SOR
              Result := (LineIntf.optlLineGoods <= Round_Up(LineIntf.optlOrderLineGoods - LineIntf.optlWriteOffGoods - PaymentSummaryIntf.psNetPaymentGoods, 2));
              If Result Then
                // Check SDN Line VAT against the unpaid line value of the SOR
                Result := (LineIntf.optlLineVAT <= Round_Up(LineIntf.optlOrderLineVAT - LineIntf.optlWriteOffVAT - PaymentSummaryIntf.psNetPaymentVAT, 2));
            End; // If (Idx >= 0)

            If (Not Result) Then
              Break;
          End; // If (LineIntf.optlLineTotal <> 0.0)
        End; // For I

        // Ensure any reference counts are removed
        LineIntf := NIL;
        PaymentSummaryIntf := NIL;
      End; // If Result
    End // If (FCurrentTransaction.InvDocHed = SDN)
    Else If (FCurrentTransaction.InvDocHed = SIN) Then
    Begin
      // MH 05/11/2014 ABSEXCH-15795: Added check on Max Payment which causes manually payments to
      // be taken into account instead of just payments through Order Payments
      Result := (FMaxPayment > 0.0) And (GetOutstandingTotal > 0.0);
    End // If (FCurrentTransaction.InvDocHed = SIN)
    Else
      Raise Exception.Create ('TOrderPaymentsTransactionInfo.CanTakePayment: Unhandled Transaction Type (' + IntToStr(Ord(FCurrentTransaction.InvDocHed)) + ')');
  End; // If Result
End; // CanTakePayment

//-------------------------------------------------------------------------

// Finds the default Payment GL Code for the Transaction's Account
Function TOrderPaymentsTransactionInfo.GetDefaultPaymentGL : LongInt;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // GetDefaultPaymentGL
  // Check to see if FAccount ihas been populated
  If (FullCustCode(FCurrentTransaction.CustCode) <> FullCustCode(FAccount.CustCode)) Then
  Begin
    // Nope - need to load the Customer details
    sKey := FullCustCode(FCurrentTransaction.CustCode);
    iStatus := FExLocal.LFind_Rec (B_GetEq, CustF, CustCodeK, sKey);
    If (iStatus = 0) Then
      FAccount := FExLocal.LCust
    Else
      // Account not found - Shouldn't ever happen unless data is borked so zero it down - the
      // only affect should be that the defaults for the payment window don't come in properly
      FillChar(FAccount, SizeOf(FAccount), #0);
  End; // If (FullCustCode(Transaction.CustCode) <> FullCustCode(FAccount.CustCode))

  // Decision was made that the Head-Office account should be ignored and the GL
  // taken from the Branch account
  Result := FAccount.acOrderPaymentsGLCode;
End; // GetDefaultPaymentGL

//-------------------------------------------------------------------------

// Calculates the totals from the Transaction, Transaction Lines and Payment Details
Procedure TOrderPaymentsTransactionInfo.UpdateTotals;
Var
  LineIntf : IOrderPaymentsTransactionLineInfo;
  PaymentSummaryIntf : IOrderPaymentsTransactionLinePaymentSummaryInfo;
  bValueExceeded : Array[VATType] of Boolean;
  IVAT : VATType;
  I, Idx : Integer;
Begin // UpdateTotals
  // Maximum Payment ----------------------

  FMaxPayment := 0.0;
  FillChar(FLineCountByVATCode, SizeOf(FLineCountByVATCode), #0);
  FillChar(FOutstandingGoodsByVATCode, SizeOf(FOutstandingGoodsByVATCode), #0);
  FillChar(FOutstandingVATByVATCode, SizeOf(FOutstandingVATByVATCode), #0);

  // Start off with the Footer Goods/VAT Totals as with Manual VAT selected the VAT figures
  // will not match up to the line values
  For IVAT := Low(VATType) To High(VATType) Do
  Begin
    FOutstandingGoodsByVATCode[IVAT] := FCurrentTransactionGoods[IVAT];
    FOutstandingVATByVATCode[IVAT] := FCurrentTransaction.InvVATAnal[IVAT];

    bValueExceeded[IVAT] := False;
  End; // For IVAT

  // Run through the Transaction Lines
  For I := 0 To (FCurrentTransactionLines.Count - 1) Do
  Begin
    LineIntf := GetTransactionLines(I);
    Try
      // Remove any written off goods on the Order from the Goods/VAT Totals
      If (FCurrentTransaction.InvDocHed = SOR) And LineIntf.optlHasWriteOffs Then
      Begin
        FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] - LineIntf.optlWriteOffGoods, 2);
        FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] - LineIntf.optlWriteOffVAT, 2);
      End; // If (FCurrentTransaction.InvDocHed = SOR) And LineIntf.HasWriteOffs

      If (FCurrentTransaction.InvDocHed = SOR) Then
      Begin
        // For SOR's remove the total payments/refunds against the SOR and any derived SDN's and SIN's
        Idx := FindPaymentSummaryByLineNo (LineIntf.optlLineNo);
        If (Idx >= 0) Then
        Begin
          PaymentSummaryIntf := GetPaymentSummary(Idx);
          Try
            FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] - PaymentSummaryIntf.psNetPaymentGoods, 2);
            FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] - PaymentSummaryIntf.psNetPaymentVAT, 2);
          Finally
            PaymentSummaryIntf := NIL;
          End; // Try..Finally
        End // If (Idx >= 0)
      End // If (FCurrentTransaction.InvDocHed = SOR)
      Else If (FCurrentTransaction.InvDocHed = SDN) Then
      Begin
        // Remove any payments/refunds against the lines from the Outstanding Goods/VAT Totals - this includes
        // only payments made against this SDN/SIN
        FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] - LineIntf.optlNetPaymentGoods, 2);
        FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] - LineIntf.optlNetPaymentVAT, 2);
      End // If (FCurrentTransaction.InvDocHed In [SDN, SIN])
      Else If (FCurrentTransaction.InvDocHed = SIN) Then
      Begin
        // MH 01/10/2014 ABSEXCH-15687: SIN maximum payment needs to be limited by pre-payments against the SOR and any SDN's or SIN's
        Idx := FindPaymentSummaryByLineNo (LineIntf.optlLineNo);
        If (Idx >= 0) Then
        Begin
          PaymentSummaryIntf := GetPaymentSummary(Idx);
          Try
            // Check whether the outstanding value of the line is >= the unpaid value of the order line
            // MH 20/04/2015 2015R1 ABSEXCH-16361: Added rounding as it was causing an error
            If (Not bValueExceeded[LineIntf.optlVATType]) And (LineIntf.optlOutstandingTotal <= Round_Up(LineIntf.optlOrderLineTotal - PaymentSummaryIntf.psNetPayments, 2)) Then
            Begin
              // Line Outstanding value can be fully paid
              FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] - LineIntf.optlNetPaymentGoods, 2);
              FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] - LineIntf.optlNetPaymentVAT, 2);
            End // If (Not bValueExceeded[LineIntf.optlVATType]) And (LineIntf.optlOutstandingTotal <= Round_Up(LineIntf.optlOrderLineTotal - PaymentSummaryIntf.psNetPayments, 2))
            Else
            Begin
              // Limit payments based on the unpaid order value fopr the line
              If (Not bValueExceeded[LineIntf.optlVATType]) Then
              Begin
                // Set the flag so we can accumulate values for any other lines for this VAT Code
                bValueExceeded[LineIntf.optlVATType] := True;

                // Set the outstanding value to the unpaid value for the order line (i.e. the maximum that can be paid)
                FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(LineIntf.optlOrderLineGoods - PaymentSummaryIntf.psNetPaymentGoods, 2);
                FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(LineIntf.optlOrderLineVAT - PaymentSummaryIntf.psNetPaymentVAT, 2);
              End // If (Not bValueExceeded[LineIntf.optlVATType])
              Else
              Begin
                // A previous line for this VAT Code could not be paid in full, but it could be possible to pay
                // this one so we should check whether the outstanding value of the line is >= the unpaid value of the order line
                // MH 20/04/2015 2015R1 ABSEXCH-16361: Added rounding as the same expression above was causing an error
                If (LineIntf.optlOutstandingTotal <= Round_Up(LineIntf.optlOrderLineTotal - PaymentSummaryIntf.psNetPayments, 2)) Then
                Begin
                  // This line can be paid in full, so add this SIN line's unpaid value into the total - this makes no provision for manual VAT
                  FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] + LineIntf.optlOutstandingGoods, 2);
                  FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] + LineIntf.optlOutstandingVAT, 2);
                End // If (LineIntf.optlOutstandingTotal <= (LineIntf.optlOrderLineTotal - PaymentSummaryIntf.psNetPayments))
                Else
                Begin
                  // The line cannot be paid in full, so add the Order's unpaid value for the line into the totals (i.e. the maximum that can be paid)
                  FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] + LineIntf.optlOrderLineGoods - PaymentSummaryIntf.psNetPaymentGoods, 2);
                  FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] + LineIntf.optlOrderLineVAT - PaymentSummaryIntf.psNetPaymentVAT, 2);
                End; // Else
              End; // Else
            End;
          Finally
            PaymentSummaryIntf := NIL;
          End; // Try..Finally
        End // If (Idx >= 0)
        Else
        Begin
          // No existing payments for the line
          FOutstandingGoodsByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingGoodsByVATCode[LineIntf.optlVATType] - LineIntf.optlNetPaymentGoods, 2);
          FOutstandingVATByVATCode[LineIntf.optlVATType] := Round_Up(FOutstandingVATByVATCode[LineIntf.optlVATType] - LineIntf.optlNetPaymentVAT, 2);
        End; // Else
      End; // If (FCurrentTransaction.InvDocHed = SIN)

      FLineCountByVATCode[LineIntf.optlVATType] := FLineCountByVATCode[LineIntf.optlVATType] + 1;
    Finally
      LineIntf := NIL;
    End; // Try..Finally
  End; // For I

(***

//  If (FPaymentDetails.Count > 0) Or True Then
//  Begin
    // Payments have been made so we need to look at the line outstanding values and
    // add up the outstanding values - due to manual VAT this actually could be more
    // than the transaction total value, in which case we use the lower value
    For I := 0 To (FCurrentTransactionLines.Count - 1) Do
    Begin
      LineIntf := GetTransactionLines(I);
      Try
        // Check outstanding values against PaymentSummary details to ensure that we don't
        // allow overpayments due to payments being made against different transactions deriving
        // from the SOR
        Idx := FindPaymentSummaryByLineNo (LineIntf.optlLineNo);
        If (Idx >= 0) Then
        Begin
          PaymentSummaryIntf := GetPaymentSummary(Idx);
          Try
            If (FCurrentTransaction.InvDocHed = SOR) Then
            Begin
              // For SORs the maximum payment is the Order Line Value - Total Payments against the line for all transactions (SORs + SDN's + SIN's)
              FOutstandingGoodsByVATCode[LineIntf.optlVATType] := FOutstandingGoodsByVATCode[LineIntf.optlVATType] + Round_Up(LineIntf.optlOrderLineGoods - PaymentSummaryIntf.psNetPaymentGoods, 2);
              FOutstandingVATByVATCode[LineIntf.optlVATType] := FOutstandingVATByVATCode[LineIntf.optlVATType] + Round_Up(LineIntf.optlOrderLineVAT - PaymentSummaryIntf.psNetPaymentVAT, 2);
            End // If (FCurrentTransaction.InvDocHed = SOR)
            Else
            Begin
              // For SDNs/SINs the maximum payment is the SxN Line Value, but that needs to be checked against payments made
              // against other Orders/SDNs/SINs to ensure that value is outstanding and can be paid without overpaying
              If (LineIntf.optlOutstandingTotal <= (LineIntf.optlOrderLineTotal - PaymentSummaryIntf.psNetPayments)) Then
              Begin
                // Line Outstanding value can be fully paid
                FOutstandingGoodsByVATCode[LineIntf.optlVATType] := FOutstandingGoodsByVATCode[LineIntf.optlVATType] + LineIntf.optlOutstandingGoods;
                FOutstandingVATByVATCode[LineIntf.optlVATType] := FOutstandingVATByVATCode[LineIntf.optlVATType] + LineIntf.optlOutstandingVAT;
              End // If (LineIntf.optlOutstandingTotal <= (LineIntf.optlOrderLineTotal - PaymentSummaryIntf.psNetPayments))
              Else
              Begin
                // Limit payment to outstanding payment value of order
                FOutstandingGoodsByVATCode[LineIntf.optlVATType] := FOutstandingGoodsByVATCode[LineIntf.optlVATType] + (LineIntf.optlOrderLineGoods - PaymentSummaryIntf.psNetPaymentGoods);
                FOutstandingVATByVATCode[LineIntf.optlVATType] := FOutstandingVATByVATCode[LineIntf.optlVATType] + (LineIntf.optlOrderLineVAT - PaymentSummaryIntf.psNetPaymentVAT);
              End;
            End; // Else
          Finally
            PaymentSummaryIntf := NIL;
          End; // Try..Finally
        End // If (Idx >= 0)
        Else
        Begin
          // No payment info - use line outstanding value
          FOutstandingGoodsByVATCode[LineIntf.optlVATType] := FOutstandingGoodsByVATCode[LineIntf.optlVATType] + LineIntf.optlOutstandingGoods;
          FOutstandingVATByVATCode[LineIntf.optlVATType] := FOutstandingVATByVATCode[LineIntf.optlVATType] + LineIntf.optlOutstandingVAT;
        End; // Else

        FLineCountByVATCode[LineIntf.optlVATType] := FLineCountByVATCode[LineIntf.optlVATType] + 1;
      Finally
        LineIntf := NIL;
      End; // Try..Finally
    End; // For I

    // Check the calculated line outstanding values doesn't exceed the header values - possible due to the
    // wonders of Manual VAT.
    For IVAT := Low(VATType) To High(VATType) Do
    Begin
      If (FOutstandingGoodsByVATCode[IVAT] > FCurrentTransactionGoods[IVAT]) Or
         (FOutstandingVATByVATCode[IVAT] > FCurrentTransaction.InvVATAnal[IVAT]) Then
      Begin
        // Line Outstanding values exceed Header Outstanding values so revert to Header values
        FOutstandingGoodsByVATCode[IVAT] := FCurrentTransactionGoods[IVAT];
        FOutstandingVATByVATCode[IVAT] := FCurrentTransaction.InvVATAnal[IVAT];
      End; // If (FOutstandingGoodsByVATCode[IVAT] > ...
    End; // For IVAT

// TODO: Does this need to force the VAT to match the header VAT - if no write-offs present - manual VAT could raise the VAT Total as well as lower

//  End // If (FPaymentDetails.Count > 0)
//  Else
//  Begin
//    // No payments made - just use the header totals
//    For IVAT := Low(VATType) To High(VATType) Do
//    Begin
//      FOutstandingGoodsByVATCode[IVAT] := FCurrentTransactionGoods[IVAT];
//      FOutstandingVATByVATCode[IVAT] := FCurrentTransaction.InvVATAnal[IVAT];
//    End; // For IVAT
//
//    // Count the lines against each VAT Code
//    For I := 0 To (FCurrentTransactionLines.Count - 1) Do
//    Begin
//      LineIntf := GetTransactionLines(I);
//      Try
//        FLineCountByVATCode[LineIntf.optlVATType] := FLineCountByVATCode[LineIntf.optlVATType] + 1;
//      Finally
//        LineIntf := NIL;
//      End; // Try..Finally
//    End; // For I
//  End; // Else

***)

  // Add up the outstanding Goods/VAT by VAT Code to determine the Total Outstanding / Max Payment
  FMaxPayment := GetOutstandingTotal;

  If (FCurrentTransaction.InvDocHed = SIN) Then
  Begin
    // Check transaction outstanding value for SINs as they may have been matched outside of
    // Order Payments causing the actual SIN outstanding value to be different to the value
    // expected by Order Payments
    If (FCurrentTransaction.CurrSettled > (GetTransactionTotal - GetOutstandingTotal)) Then
    Begin
      // Cut the maximum payment back to the outstanding SIN value - as we already have a SIN we
      // aren't too bothered about the VAT split, but this will leave an unpaid value on the SOR
      // as far as Order Payments is concerned.
      FMaxPayment := Round_Up(GetTransactionTotal - FCurrentTransaction.CurrSettled, 2);
    End; // If (FCurrentTransaction.CurrSettled <> 0.0)
  End; // If (FCurrentTransaction.InvDocHed = SIN) And (FCurrentTransaction.CurrSettled <> 0.0)
End; // UpdateTotals

//-------------------------------------------------------------------------

// Adds a transaction line found by the Pervasive/MSSQL descendants into the lines list
Procedure TOrderPaymentsTransactionInfo.AddLine (Const TransactionLine : IDetail);
Var
  oLineInfo : IOrderPaymentsTransactionLineInfo;
Begin // AddLine
  // Add line into the list
  oLineInfo := TOrderPaymentsTransactionLineInfo.Create (@FOriginalOrder, @FCurrentTransaction, TransactionLine);
  Try
    FCurrentTransactionLines.Add(oLineInfo);

    // Update the Goods totals with the line total
    FCurrentTransactionGoods[oLineInfo.optlVATType] := FCurrentTransactionGoods[oLineInfo.optlVATType] + Round_Up (InvLTotal (TransactionLine, BOn, (FCurrentTransaction.DiscSetl * Ord(FCurrentTransaction.DiscTaken))), 2);
  Finally
    oLineInfo := NIL;
  End; // Try..Finally
End; // AddLine

//------------------------------

// Loads the Transaction Lines for optTransaction and calculates the Goods values
Procedure TOrderPaymentsTransactionInfo.LoadTransactionLines;
Begin // LoadTransactionLines
  // Initialise local vars
  FCurrentTransactionLines.Clear;
  FillChar(FCurrentTransactionGoods, SizeOf(FCurrentTransactionGoods), #0);

  // Remainder of routine is implemented in database specific descendants for optimum performance
  // and calling AddLine (above) to add the transaction lines into the list
End; // LoadTransactionLines

//-------------------------------------------------------------------------

// Updates a line for the current transaction with original order values from the original order
// line in order to correctly determine the maximum payment values
Procedure TOrderPaymentsTransactionInfo.ProcessOrderLine (Const OrderLine : IDetail);
Var
  Idx : Integer;
Begin // ProcessOrderLine
  Idx := FindLineByLineNo (OrderLine.ABSLineNo);
  If (Idx >= 0) Then
  Begin
    (GetTransactionLines(Idx) As IOrderPaymentsTransactionLineInfo_Internal).SetOrderDetails(OrderLine);
  End; // If (Idx >= 0)
End; // ProcessOrderLine

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionInfo.GetPaymentSummaryCount : Integer;
Begin // GetPaymentSummaryCount
  Result := FPaymentSummary.Count;
End; // GetPaymentSummaryCount

//------------------------------

Function TOrderPaymentsTransactionInfo.GetPaymentSummary(Index : Integer) : IOrderPaymentsTransactionLinePaymentSummaryInfo;
Begin // GetPaymentSummary
  If (Index >= 0) And (Index < FPaymentSummary.Count) Then
    Result := FPaymentSummary.Items[Index] As IOrderPaymentsTransactionLinePaymentSummaryInfo
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionInfo.GetPaymentSummary: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FPaymentSummary.Count) + ')');
End; // GetPaymentSummary

//------------------------------

Function TOrderPaymentsTransactionInfo.FindPaymentSummaryByLineNo (Const LineNo : Integer) : Integer;
Var
  I : Integer;
Begin // FindPaymentSummaryByLineNo
  Result := -1;
  For I := 0 To (FPaymentSummary.Count - 1) Do
  Begin
    If (GetPaymentSummary(I).psLineNo = LineNo) Then
    Begin
      Result := I;
      Break;
    End; // If (GetPaymentSummary(I).psLineNo = LineNo)
  End; // For I
End; // FindPaymentSummaryByLineNo

//------------------------------

Procedure TOrderPaymentsTransactionInfo.UpdatePaymentSummary (Const PaymentInfo : IOrderPaymentsPaymentInfo);
Var
  oLinePaymentSummaryInfo : TOrderPaymentsTransactionLinePaymentSummaryInfo;
  Idx : Integer;
Begin // UpdatePaymentSummary
  // Find the line in the payment summary
  Idx := FindPaymentSummaryByLineNo(PaymentInfo.vpSORABSLineNo);
  If (Idx = -1) Then
  Begin
    // Doesn't exist - create a new entry
    oLinePaymentSummaryInfo := TOrderPaymentsTransactionLinePaymentSummaryInfo.Create (PaymentInfo);
    Try
      FPaymentSummary.Add (oLinePaymentSummaryInfo);

      // MH 08/01/2015 v7.1 ABSEXCH-15829: Link to Transaction Line object for Payment VAT Calculation
      Idx := FindLineByLineNo (PaymentInfo.vpSORABSLineNo);
      If (Idx >= 0) Then
        (GetTransactionLines(Idx) As IOrderPaymentsTransactionLineInfo_Internal).optlLinePaymentSummaryInfo := oLinePaymentSummaryInfo;
    Finally
      oLinePaymentSummaryInfo := NIL;
    End; // Try..Finally
  End // If (Idx = -1)
  Else
    // Update the existing entry
    (GetPaymentSummary(Idx) As IOrderPaymentsTransactionLinePaymentSummaryInfo_Internal).UpdatePaymentSummary(PaymentInfo);
End; // UpdatePaymentSummary

//-------------------------------------------------------------------------

// Returns TRUE is the specified payment reference exists in the Payment Details list and is a
// payment against the current transaction
Function TOrderPaymentsTransactionInfo.PaymentAppliesToCurrentTransaction(PaymentRef : ShortString) : Boolean;
Var
  OrderPaymentsPaymentInfo : IOrderPaymentsPaymentInfo;
  I : Integer;
Begin // PaymentAppliesToCurrentTransaction
  PaymentRef := Trim(PaymentRef);
  Result := False;

  For I := 0 To (FPaymentDetails.Count - 1) Do
  Begin
    OrderPaymentsPaymentInfo := GetPaymentDetails (I);
    If (PaymentRef = Trim(OrderPaymentsPaymentInfo.vpReceiptRef)) And (Trim(OrderPaymentsPaymentInfo.vpTransRef) = Trim(FCurrentTransaction.OurRef)) Then
    Begin
      Result := True;
      Break;
    End; // If (PaymentRef = Trim(OrderPaymentsPaymentInfo.vpReceiptRef)) And (Trim(OrderPaymentsPaymentInfo.vpTransRef) = Trim(FCurrentTransaction.OurRef))
  End; // For I
  OrderPaymentsPaymentInfo := NIL;
End; // PaymentAppliesToCurrentTransaction

//------------------------------

// Processes a VAT Payment Details row found by the Pervasive/MSSQL descendants
Procedure TOrderPaymentsTransactionInfo.AddVATPayDetails(Const VATPayDetails : OrderPaymentsVATPayDetailsRecType);
Var
  OrderPaymentsPaymentInfo : IOrderPaymentsPaymentInfo;
  Idx : Integer;
Begin // AddVATPayDetails
  // Add line into the central Order level list
  OrderPaymentsPaymentInfo := TOrderPaymentsPaymentInfo.Create (VATPayDetails);
  FPaymentDetails.Add(OrderPaymentsPaymentInfo);

  // Add into Order level totals
  UpdatePaymentSummary (OrderPaymentsPaymentInfo);

  // If we are working on the SOR and the payment details applies to the SOR or it isn't the SOR and
  // the Transaction reference is the current transaction then apply the details against the transaction
  // line
     //PR: 28/01/2015 ABSEXCH-16078 Need to include SDN payments when dealing with the SOR the SDN was generated from
//  If ((FCurrentTransaction.InvDocHed = SOR) And (OrderPaymentsPaymentInfo.vpType In [vptSORPayment, vptSDNPayment, vptSORValueRefund])) Or
  // MH 09/06/2015 Exch-R1 ABSEXCH-16432: Extended so that for the SOR all Payments and Refunds are taken into account
  If ((FCurrentTransaction.InvDocHed = SOR) And (OrderPaymentsPaymentInfo.vpType In (VATPayDetailsTypePaymentSet + VATPayDetailsTypeRefundSet))) Or
     ((FCurrentTransaction.InvDocHed <> SOR) And (OrderPaymentsPaymentInfo.vpTransRef = FCurrentTransaction.OurRef)) Or
     // MH 06/11/2014 ABSEXCH-15798: Include SOR Refunds if they apply to a payment against an SDN
     // MH 08/12/2014 ABSEXCH-15848: Include SOR Refunds if they apply to a payment against an SIN!
     ((FCurrentTransaction.InvDocHed In [SDN, SIN]) And (OrderPaymentsPaymentInfo.vpType = vptSORValueRefund) And PaymentAppliesToCurrentTransaction(VATPayDetails.vpTransRef)) Or
     // Include SIN Refunds if they apply to a payment for this transaction
     ((FCurrentTransaction.InvDocHed = SIN) And (OrderPaymentsPaymentInfo.vpType In [vptSINValueRefund, vptSINStockRefund]) And PaymentAppliesToCurrentTransaction(VATPayDetails.vpTransRef)) Then
  Begin
    // Find the associated transaction line and pass the payment info through for processing, any payment
    // description lines will be filtered out at this point as they won't map onto lines in the SOR/SDN/SIN
    Idx := FindLineByLineNo (OrderPaymentsPaymentInfo.vpSORABSLineNo);
    If (Idx >= 0) Then
      (GetTransactionLines(Idx) As IOrderPaymentsTransactionLineInfo_Internal).AddVATPayDetails(OrderPaymentsPaymentInfo);
  End; // If ((FCurrentTransaction.InvDocHed = SOR) And (...
End; // AddVATPayDetails

//------------------------------

// Loads the VAT Payment Details
Procedure TOrderPaymentsTransactionInfo.LoadVATPayDetails;
Begin // LoadVATPayDetails
  // Initialise local vars
  FPaymentDetails.Clear;

  // Remainder of routine is implemented in database specific descendants for optimum performance
End; // LoadVATPayDetails

//-------------------------------------------------------------------------

// Returns the index of a Transaction Line with a specified ABS Line No in the
// optTransactionLines array, returns -1 if not found
Function TOrderPaymentsTransactionInfo.FindLineByLineNo (Const LineNo : Integer) : Integer;
Var
  I : Integer;
Begin // FindLineByLineNo
  Result := -1;
  For I := 0 To (FCurrentTransactionLines.Count - 1) Do
  Begin
    // For SOR's match against the Absolute Line Number
    // For SDN/SIN match against the SOPLineNo which will map onto the Absolute Line Number of the originating line on the SOR
    If ((FCurrentTransaction.InvDocHed = SOR) And (GetTransactionLines(I).optlTransactionLine.ABSLineNo = LineNo)) Or
       ((FCurrentTransaction.InvDocHed <> SOR) And (GetTransactionLines(I).optlTransactionLine.SOPLineNo = LineNo)) Then
    Begin
      Result := I;
      Break;
    End; // If ((FCurrentTransaction.InvDocHed = SOR) And (...
  End; // For I
End; // FindLineByLineNo

//-------------------------------------------------------------------------

// Writes the details to a cromulent XML string
Function TOrderPaymentsTransactionInfo.ToXML : ANSIString;
Var
  sUtility : ShortString;
  IVAT : VATType;
  ILine : Integer;
Begin // ToXML
  Result := '<?xml version="1.0" encoding="ISO-8859-1" ?>' + #13#10 +
            '<OrderPayments OurRef="' + FCurrentTransaction.OurRef + '" Account="' + FCurrentTransaction.CustCode + '" >' + #13#10;

  Result := Result + '<VATTotals>' + #13#10;
  For IVAT := Low(VATType) To High(VATType) Do
  Begin
    // Suppress VAT Codes with no values
    If (GetTransactionGoods(IVAT) <> 0.0) Or (FCurrentTransaction.InvVATAnal[IVAT] <> 0.0) Or
       (GetOutstandingTotalByVATCode(IVAT) <> 0.0) Or (GetLineCountByVATCode(IVAT) <> 0) Then
    Begin
      If (SyssVAT^.VATRates.VAT[IVAT].Code In ['0'..'9', 'A'..'Z', 'a'..'z']) Then
        sUtility := SyssVAT^.VATRates.VAT[IVAT].Code
      Else
        sUtility := 'Code' + IntToStr(Ord(IVAT));

      Result := Result + '<VATCode Code= "' + sUtility +
                              '" Total="' + Form_Real(GetTransactionGoods(IVAT) + FCurrentTransaction.InvVATAnal[IVAT], 0, 2) +
                              '" Goods="' + Form_Real(GetTransactionGoods(IVAT), 0, 2) +
                              '" VAT="' + Form_Real(FCurrentTransaction.InvVATAnal[IVAT], 0, 2) +
                              '" OutStandingTotal="' + Form_Real(GetOutstandingTotalByVATCode(IVAT), 0, 2) +
                              '" OutStandingGoods="' + Form_Real(GetOutstandingGoodsByVATCode(IVAT), 0, 2) +
                              '" OutStandingVAT="' + Form_Real(GetOutstandingVATByVATCode(IVAT), 0, 2) +
                              '" Count="' + Form_Real(GetLineCountByVATCode(IVAT), 0, 2) + '" />' + #13#10;
    End; // If (GetTransactionGoods(IVAT) <> 0.0) Or (...
  End; // For IVAT
  Result := Result + '</VATTotals>' + #13#10;

  Result := Result + '<OrderPaymentSummary Count="' + IntToStr(FPaymentSummary.Count) + '" >' + #13#10;
  For ILine := 0 To (FPaymentSummary.Count - 1) Do
  Begin
    With GetPaymentSummary(ILine) Do
    Begin
      Result := Result + '<OrderLine No="' + IntToStr(psLineNo) + '" >' + #13#10;

      Result := Result + '<NetPayments Total="' + Form_Real(psNetPayments, 0, 2) +
                                    '" Goods="' + Form_Real(psNetPaymentGoods, 0, 2) +
                                      '" VAT="' + Form_Real(psNetPaymentVAT, 0, 2) + '" />' + #13#10;
      Result := Result + '<TotalPayments Total="' + Form_Real(psTotalPayments, 0, 2) +
                                    '" Goods="' + Form_Real(psTotalPaymentGoods, 0, 2) +
                                      '" VAT="' + Form_Real(psTotalPaymentVAT, 0, 2) + '" />' + #13#10;
      Result := Result + '<TotalRefunds Total="' + Form_Real(psTotalRefunds, 0, 2) +
                                '" Goods="' + Form_Real(psTotalRefundGoods, 0, 2) +
                                  '" VAT="' + Form_Real(psTotalRefundVAT, 0, 2) + '" />' + #13#10;

      Result := Result + '</OrderLine>' + #13#10;
    End; // With GetPaymentSummary(ILine)
  End; // For ILine
  Result := Result + '</OrderPaymentSummary>' + #13#10;


  Result := Result + '<TransactionLines Count="' + IntToStr(FCurrentTransactionLines.Count) + '" >' + #13#10;
  For ILine := 0 To (FCurrentTransactionLines.Count - 1) Do
  Begin
    With GetTransactionLines(ILine) Do
    Begin
      If (optlTransactionLine.VATCode In ['0'..'9', 'A'..'Z', 'a'..'z']) Then
        sUtility := optlTransactionLine.VATCode
      Else
        sUtility := '#' + IntToStr(Ord(optlTransactionLine.VATCode));

      Result := Result + '<TransactionLine No="' + IntToStr(ILine) +
                                      '" LineNo="' + IntToStr(optlTransactionLine.LineNo) +
                                      '" ABSLineNo="' + IntToStr(optlTransactionLine.ABSLineNo) +
                                      '" SOPLineNo="' + IntToStr(optlTransactionLine.SOPLineNo) +
                                      '" StockCode="' + optlTransactionLine.StockCode +
                                      '" Description="' + optlTransactionLine.Desc +
                                      '" VATCode="' + sUtility + '" >' + #13#10;

      Result := Result + '<LineTotals Total="' + Form_Real(optlLineTotal, 0, 2) +
                                   '" Goods="' + Form_Real(optlLineGoods, 0, 2) +
                                   '" VAT="' + Form_Real(optlLineVAT, 0, 2) + '" />' + #13#10;
      Result := Result + '<NetPayments Total="' + Form_Real(optlNetPaymentTotal, 0, 2) +
                                    '" Goods="' + Form_Real(optlNetPaymentGoods, 0, 2) +
                                      '" VAT="' + Form_Real(optlNetPaymentVAT, 0, 2) + '" />' + #13#10;
      Result := Result + '<Outstanding Total="' + Form_Real(optlOutstandingTotal, 0, 2) +
                                    '" Goods="' + Form_Real(optlOutstandingGoods, 0, 2) +
                                      '" VAT="' + Form_Real(optlOutstandingVAT, 0, 2) + '" />' + #13#10;
      Result := Result + '<CurrentPayment Total="' + Form_Real(optlCurrentPaymentTotal, 0, 2) +
                                '" Goods="' + Form_Real(optlCurrentPaymentGoods, 0, 2) +
                                  '" VAT="' + Form_Real(optlCurrentPaymentVAT, 0, 2) + '" />' + #13#10;
      Result := Result + '</TransactionLine>' + #13#10;
    End; // With GetTransactionLines(ILine)
  End; // For ILine
  Result := Result + '</TransactionLines>' + #13#10;
  Result := Result + '</OrderPayments>';
End; // ToXML

//-------------------------------------------------------------------------

Function TOrderPaymentsTransactionInfo.GetOrder : InvRec;
Begin // GetOrder
  Result := FOriginalOrder
End; // GetOrder

Function TOrderPaymentsTransactionInfo.GetOrderLocked : Boolean;
Begin // GetOrderLocked
  If (FCurrentTransaction.InvDocHed = SOR) Then
    Result := FCurrentTransactionLocked
  Else
    Result := FOriginalOrderLocked
End; // GetOrderLocked

Function TOrderPaymentsTransactionInfo.GetOrderLockPos : LongInt;
Begin // GetOrderLockPos
  If (FCurrentTransaction.InvDocHed = SOR) Then
    Result := FCurrentTransactionLockPos
  Else
    Result := FOriginalOrderLockPos
End; // GetOrderLockPos

//------------------------------

Function TOrderPaymentsTransactionInfo.GetAccount : CustRec;
Begin // GetAccount
  Result := FAccount;
End; // GetAccount

//------------------------------

Function TOrderPaymentsTransactionInfo.GetTransactionGoods(Index : VATType) : Double;
Begin // GetTransactionGoods
  Result := FCurrentTransactionGoods[Index]
End; // GetTransactionGoods

//------------------------------

Function TOrderPaymentsTransactionInfo.GetTransactionLineCount : Integer;
Begin // GetTransactionLineCount
  Result := FCurrentTransactionLines.Count;
End; // GetTransactionLineCount

//------------------------------

Function TOrderPaymentsTransactionInfo.GetTransactionLines(Index : Integer) : IOrderPaymentsTransactionLineInfo;
Begin // GetTransactionLines
  If (Index >= 0) And (Index < FCurrentTransactionLines.Count) Then
    Result := FCurrentTransactionLines.Items[Index] As IOrderPaymentsTransactionLineInfo
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionInfo.GetTransactionLines: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FCurrentTransactionLines.Count) + ')');
End; // GetTransactionLines

//------------------------------

Function TOrderPaymentsTransactionInfo.GetPaymentDetailsCount : Integer;
Begin // GetPaymentDetailsCount
  Result := FPaymentDetails.Count;
End; // GetPaymentDetailsCount

//------------------------------

Function TOrderPaymentsTransactionInfo.GetPaymentDetails (Index : Integer) : IOrderPaymentsPaymentInfo;
Begin // GetPaymentDetails
  If (Index >= 0) And (Index < FPaymentDetails.Count) Then
    Result := FPaymentDetails.Items[Index] As IOrderPaymentsPaymentInfo
  Else
    Raise Exception.Create ('TOrderPaymentsTransactionInfo.GetPaymentDetails: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FPaymentDetails.Count) + ')');
End; // GetPaymentDetails

//------------------------------

Function TOrderPaymentsTransactionInfo.GetTransactionTotal : Double;
Begin // GetTransactionTotal
  Result := Round_Up(ITotal(FCurrentTransaction),2);
End; // GetTransactionTotal
Function TOrderPaymentsTransactionInfo.GetTransactionTotalGoods : Double;
Begin // GetTransactionTotalGoods
  // MH 28/10/2014 ABSEXCH-15757: Rounding error caused by addition without rounding
  Result := Round_Up(GetTransactionTotal - GetTransactionTotalVAT, 2);
End; // GetTransactionTotalGoods
Function TOrderPaymentsTransactionInfo.GetTransactionTotalVAT : Double;
Begin // GetTransactionTotalVAT
  Result := FCurrentTransaction.InvVAT;
End; // GetTransactionTotalVAT

//------------------------------

Function TOrderPaymentsTransactionInfo.GetTotalPayments : Double;
Begin // GetTotalPayments
  Result := GetTotalPaymentsGoods + GetTotalPaymentsVAT;
End; // GetTotalPayments
Function TOrderPaymentsTransactionInfo.GetTotalPaymentsGoods : Double;
Begin // GetTotalPaymentsGoods
  Result := FTotalPaymentsGoods
End; // GetTotalPaymentsGoods
Function TOrderPaymentsTransactionInfo.GetTotalPaymentsVAT : Double;
Begin // GetTotalPaymentsVAT
  Result := FTotalPaymentsVAT
End; // GetTotalPaymentsVAT

//------------------------------

Function TOrderPaymentsTransactionInfo.GetTotalRefunds : Double;
Begin // GetTotalRefunds
  // MH 28/10/2014 ABSEXCH-15757: Rounding error caused by addition without rounding
  Result := Round_Up(GetTotalRefundsGoods + GetTotalRefundsVAT, 2);
End; // GetTotalRefunds
Function TOrderPaymentsTransactionInfo.GetTotalRefundsGoods : Double;
Begin // GetTotalRefundsGoods
  Result := FTotalRefundsGoods
End; // GetTotalRefundsGoods
Function TOrderPaymentsTransactionInfo.GetTotalRefundsVAT : Double;
Begin // GetTotalRefundsVAT
  Result := FTotalRefundsVAT
End; // GetTotalRefundsVAT

//------------------------------

Function TOrderPaymentsTransactionInfo.GetNetPayments : Double;
Begin // GetNetPayments
  // MH 28/10/2014 ABSEXCH-15757: Rounding error caused by addition without rounding
  Result := Round_Up(GetNetPaymentsGoods + GetNetPaymentsVAT, 2);
End; // GetNetPayments
Function TOrderPaymentsTransactionInfo.GetNetPaymentsGoods : Double;
Begin // GetNetPaymentsGoods
  Result := FNetPaymentsGoods
End; // GetNetPaymentsGoods
Function TOrderPaymentsTransactionInfo.GetNetPaymentsVAT : Double;
Begin // GetNetPaymentsVAT
  Result := FNetPaymentsVAT
End; // GetNetPaymentsVAT

//------------------------------

Function TOrderPaymentsTransactionInfo.GetMaxPayment : Double;
Begin // GetMaxPayment
  Result := FMaxPayment;
End; // GetMaxPayment

//------------------------------

// MH 11/08/2015 2015-R1 ABSEXCH-16664: Added Write-Off Total for Norbert
Function TOrderPaymentsTransactionInfo.GetWriteOffTotal : Double;
Var
  LineIntf : IOrderPaymentsTransactionLineInfo;
  I : Integer;
Begin // GetWriteOffTotal
  Result := 0.0;

  If (FCurrentTransaction.InvDocHed = SOR) Then
  Begin
    // Run through the Transaction Lines
    For I := 0 To (FCurrentTransactionLines.Count - 1) Do
    Begin
      LineIntf := GetTransactionLines(I);
      If LineIntf.optlHasWriteOffs Then
        Result := Round_Up(Result + LineIntf.optlWriteOffTotal, 2);
    End; // For I
	LineIntf := NIL;
  End; // If (FCurrentTransaction.InvDocHed = SOR)
End; // GetWriteOffTotal

//------------------------------

Function TOrderPaymentsTransactionInfo.GetOutstandingTotal : Double;
Var
  IVAT : VATType;
Begin // GetOutstandingTotal
  Result := 0.0;
  For IVAT := Low(VATType) To High(VATType) Do
    // MH 28/10/2014 ABSEXCH-15757: Rounding error caused by addition without rounding
    Result := Round_Up(Result + FOutstandingGoodsByVATCode[IVAT] + FOutstandingVATByVATCode[IVAT], 2);
End; // GetOutstandingTotal

Function TOrderPaymentsTransactionInfo.GetOutstandingTotalByVATCode (Index : VATType) : Double;
Begin // GetOutstandingTotalByVATCode
  // MH 28/10/2014 ABSEXCH-15757: Rounding error caused by addition without rounding
  Result := Round_Up(FOutstandingGoodsByVATCode[Index] + FOutstandingVATByVATCode[Index], 2);
End; // GetOutstandingTotalByVATCode

Function TOrderPaymentsTransactionInfo.GetOutstandingGoodsByVATCode (Index : VATType) : Double;
Begin // GetOutstandingGoodsByVATCode
  Result := FOutstandingGoodsByVATCode[Index];
End; // GetOutstandingGoodsByVATCode

Function TOrderPaymentsTransactionInfo.GetOutstandingVATByVATCode (Index : VATType) : Double;
Begin // GetOutstandingVATByVATCode
  Result := FOutstandingVATByVATCode[Index];
End; // GetOutstandingVATByVATCode

//------------------------------

Function TOrderPaymentsTransactionInfo.GetLineCountByVATCode (Index : VATType) : Integer;
Begin // GetLineCountByVATCode
  Result := FLineCountByVATCode[Index]
End; // GetLineCountByVATCode

//=========================================================================

// Loads the Transaction Lines for optTransaction
Procedure TPervasiveOrderPaymentsTransactionInfo.LoadTransactionLines;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadTransactionLines
  Inherited LoadTransactionLines;

  sKey := FullNomKey(FCurrentTransaction.FolioNum) + FullNomKey(0);
  iStatus := FExLocal.LFind_Rec (B_GetGEq, IDetailF, IdFolioK, sKey);
  While (iStatus = 0) And (FExLocal.LId.FolioRef = FCurrentTransaction.FolioNum) Do
  Begin
    AddLine (FExLocal.LId);
    iStatus := FExLocal.LFind_Rec (B_GetNext, IDetailF, IdFolioK, sKey);
  End; // While (iStatus = 0) And (FExLocal.LId.FolioRef = FCurrentTransaction.FolioNum)
End; // LoadTransactionLines

//-------------------------------------------------------------------------

// Loads the original SOR lines in to determine the order values - this is required to determine
// maximum payment values when on SDN/SIN transactions
Procedure TPervasiveOrderPaymentsTransactionInfo.LoadOrderLines;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadOrderLines
  sKey := FullNomKey(FOriginalOrder.FolioNum) + FullNomKey(0);
  iStatus := FExLocal.LFind_Rec (B_GetGEq, IDetailF, IdFolioK, sKey);
  While (iStatus = 0) And (FExLocal.LId.FolioRef = FOriginalOrder.FolioNum) Do
  Begin
    ProcessOrderLine (FExLocal.LId);
    iStatus := FExLocal.LFind_Rec (B_GetNext, IDetailF, IdFolioK, sKey);
  End; // While (iStatus = 0) And (FExLocal.LId.FolioRef = FOriginalOrder.FolioNum)
End; // LoadOrderLines

//-------------------------------------------------------------------------

// Loads the VAT Payment Details for the Order
Procedure TPervasiveOrderPaymentsTransactionInfo.LoadVATPayDetails;
Var
  VATPayBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;
  sKey : Str255;
  iStatus : Integer;

  //PR: 05/02/2015 ABSEXCH-16126 Changed to cache matching records so they are sent to AddVATPaymentDetails function after
  //                             other record types
  oVATDetMatchingCache : TOrderPaymentsVATPayDetailsList;
  I : Integer;
Begin // LoadVATPayDetails
  Inherited LoadVATPayDetails;

  VATPayBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
  oVATDetMatchingCache := TOrderPaymentsVATPayDetailsList.Create;
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
        //PR: 05/02/2015 ABSEXCH-16126
        If (VATPayBtrieveFile.VATPayDetails.vpType <> vptMatching) Then
          AddVATPayDetails(VATPayBtrieveFile.VATPayDetails)
        Else
          // Cache matching rows up until the end to ensure the Payment details have been processed
          oVATDetMatchingCache.Add(VATPayBtrieveFile.VATPayDetails);

        iStatus := VATPayBtrieveFile.GetNext;
      End; // While (iStatus = 0) And (VATPayBtrieveFile.VATPayDetails.vpOrderRef = sKey)

      VATPayBtrieveFile.CloseFile;

      //PR: 05/02/2015 ABSEXCH-16126
      // Pull out any cached Matching rows and apply them to the Payments
      For I := 0 To (oVATDetMatchingCache.Count - 1) Do
        AddVATPayDetails(oVATDetMatchingCache.Records[I]);

    End; // If (iStatus = 0)
  Finally
    VATPayBtrieveFile.Free;
    oVATDetMatchingCache.Free;
  End; // Try..Finally
End; // LoadVATPayDetails

//-------------------------------------------------------------------------

// CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment
function TPervasiveOrderPaymentsTransactionInfo.HasManualPayments(
  SORRef: string): Boolean;
var
  SORKeyS: Str255;
  SORKeyChk: Str255;
  SINKeyS: Str255;
  SINKeyChk: Str255;
  SRCKeyS: Str255;
  SRCKeyChk: Str255;
  InvKeyPath: Integer;
  InvRecAddr: LongInt;
  KeyPath: Integer;
  RecAddr: LongInt;
  Res: LongInt;

  function HasManualPayments_SQL: Boolean;
  const
    Qry =
      'SELECT thOurRef' +
      ', thOrderPaymentElement' +
      ', thOrderPaymentOrderRef' +
      ', SORMatch.DocRef' +
      ', SINMatch.PayRef' +
      ', SINMatch.MatchType ' +
      'FROM [COMPANY].FinancialMatching AS SORMatch ' +
      'INNER JOIN [COMPANY].FinancialMatching AS SINMatch ON SORMatch.DocRef = SINMatch.DocRef ' +
      'INNER JOIN [COMPANY].DOCUMENT AS DocMatch ON DocMatch.thOurRef = SINMatch.PayRef ' +
      'WHERE SORMatch.PayRef = ''%s'' AND ' +
      ' SINMatch.MatchType = ''A'' AND ' +
      ' thOrderPaymentOrderRef <> SORMatch.PayRef ';
  var
    QryStr: string;
  begin
    QryStr := Format(Qry, [SORRef]);
    Result := ExecSQL(QryStr, SetDrive) > 0;
  end;

begin
  Result := False;
  with FExLocal do
  begin
    // Save position in Inv
    LPresrv_BTPos(InvF, InvKeyPath, F[InvF], InvRecAddr, False, False);

    // Find the Order Matching records against this Sales Order
    SORKeyS := MatchTCode + MatchSCode + SORRef;
    SORKeyChk := SORKeyS;

    Res := LFind_Rec(B_GetGEq, PWrdF, HelpNdxK, SORKeyS);

    while (Res = 0) and (Copy(SORKeyS, 1, Length(SORKeyChk)) = SORKeyChk) and not Result do
    begin
      with LPassword.MatchPayRec do
      begin
        // If this is a Sales Invoice...
        if (Copy(DocCode, 1, 3) = 'SIN') and (MatchType = 'O') then
        begin
          // ...find the Financial Matching records against it
          SINKeyS := MatchTCode + MatchSCode + DocCode;
          SINKeyChk := SINKeyS;

          // Save the current position
          LPresrv_BTPos(PwrdF, KeyPath, F[PwrdF], RecAddr, False, False);

          // Find the records
          Res := LFind_Rec(B_GetGEq, PWrdF, PWK, SINKeyS);
          while (Res = 0) and (Copy(SINKeyS, 1, Length(SINKeyChk)) = SINKeyChk) and not Result do
          begin
            // If this is a Sales Receipt...
            if (Copy(FExLocal.LPassword.MatchPayRec.PayRef, 1, 3) = 'SRC') and (FExLocal.LPassword.MatchPayRec.MatchType = 'A') then
            begin
              // ...find the transaction header
              SRCKeyS := PayRef;
              Res := LFind_Rec(B_GetEq, InvF, InvOurRefK, SRCKeyS);
              if Res = 0 then
              begin
                // Is it an Order Payment?
                if (LInv.thOrderPaymentElement <> opeNA) then
                begin
                  // Is it against the current Sales Order?
                  if (LInv.thOrderPaymentOrderRef <> SORRef) then
                    // No -- treat it as a manual payment
                    Result := True;
                end
                else
                  // No -- it's a manual payment
                  Result := True;
              end;
            end;
            // Find the next Financial Matching record
            Res := LFind_Rec(B_GetNext, PWrdF, PWK, SINKeyS);
          end;

          // Restore the original position
          LPresrv_BTPos(PwrdF, KeyPath, F[PwrdF], RecAddr, True, False);

        end;
      end; // with LPassword.MatchPayRec ...

      if not Result then
        // Find the next Order Matching record
        Res := LFind_Rec(B_GetNext, PWrdF, HelpNdxK, SORKeyS);

    end;

    // Restore Inv position
    LPresrv_BTPos(InvF, InvKeyPath, F[InvF], InvRecAddr, True, False);

  end; // with FExLocal^ ...

end;

//=========================================================================

// Loads the Transaction Lines for optTransaction
Procedure TMSSQLOrderPaymentsTransactionInfo.LoadTransactionLines;
Var
  oSQLSelectTransactionLines : TSQLSelectTransactionLines;
Begin // LoadTransactionLines
  oSQLSelectTransactionLines := TSQLSelectTransactionLines.Create;
  Try
    oSQLSelectTransactionLines.CompanyCode   := SQLUtils.GetCompanyCode(SetDrive);
    oSQLSelectTransactionLines.FromClause    := 'FROM [COMPANY].DETAILS';
    oSQLSelectTransactionLines.WhereClause   := 'WHERE (tlFolioNum=' + IntToStr(FCurrentTransaction.FolioNum) + ') And (tlLineNo >= 0)';
    oSQLSelectTransactionLines.OrderByClause := 'ORDER BY tlFolioNum, tlLineNo';

    // Access using SQL navigation
    oSQLSelectTransactionLines.OpenFile;
    oSQLSelectTransactionLines.First;
    While (Not oSQLSelectTransactionLines.EOF) Do
    Begin
      AddLine (oSQLSelectTransactionLines.ReadRecord);
      oSQLSelectTransactionLines.Next;
    End; // While (Not oSQLSelectTransactionLines.EOF)
  Finally
    oSQLSelectTransactionLines.Free;
  End; // Try..Finally
End; // LoadTransactionLines

//-------------------------------------------------------------------------

// Loads the original SOR lines in to determine the order values - this is required to determine
// maximum payment values when on SDN/SIN transactions
Procedure TMSSQLOrderPaymentsTransactionInfo.LoadOrderLines;
Var
  oSQLSelectTransactionLines : TSQLSelectTransactionLines;
  TransactionLineIntf : IOrderPaymentsTransactionLineInfo;
  sLineNos : ANSIString;
  I : Integer;
Begin // LoadOrderLines
  // Work out which SOR lines we need to load to get the original order value for the current
  // transaction's lines.  If a large order has only been part delivered then this could make
  // a significant difference to the amount of data being retrieved
  sLineNos := '';
  For I := 0 To (GetTransactionLineCount - 1) Do
  Begin
    // Need to read the matching order line if the CurrentTransaction line has a value
    TransactionLineIntf := GetTransactionLines(I);
    If (TransactionLineIntf.optlLineTotal <> 0.0) Then
    Begin
      If (sLineNos <> '') Then
        sLineNos := sLineNos + ', ';
      sLineNos := sLineNos + IntToStr(TransactionLineIntf.optlTransactionLine.SOPLineNo);
    End; // If (TransactionLineIntf.optlLineTotal <> 0.0)
  End; // For I
  TransactionLineIntf := NIL;

  If (sLineNos <> '') Then
  Begin
    // Load the SOR lines
    oSQLSelectTransactionLines := TSQLSelectTransactionLines.Create;
    Try
      oSQLSelectTransactionLines.CompanyCode   := SQLUtils.GetCompanyCode(SetDrive);
      //PR: 10/02/2015 Added NOLOCK to FromClause to allow the query to run while a transaction is active
      oSQLSelectTransactionLines.FromClause    := 'FROM [COMPANY].DETAILS with (NOLOCK)';
      oSQLSelectTransactionLines.WhereClause   := 'WHERE (tlFolioNum=' + IntToStr(FOriginalOrder.FolioNum) + ') And (tlABSLineNo In (' + sLineNos + '))';
      oSQLSelectTransactionLines.OrderByClause := 'ORDER BY tlFolioNum, tlABSLineNo';

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
  End; // If (sLineNos <> '')
End; // LoadOrderLines

//-------------------------------------------------------------------------

// Loads the VAT Payment Details
Procedure TMSSQLOrderPaymentsTransactionInfo.LoadVATPayDetails;
Var
  fldOrderRef, fldReceiptRef, fldTransRef, fldDescription,
  fldVATCode, fldUserName, fldDateCreated, fldTimeCreated : TStringField;
  fldLineOrderNo, fldSORABSLineNo, fldType, fldCurrency : TIntegerField;
  fldGoodsValue, fldVATValue : TFloatField;
  SQLCaller : TSQLCaller;
  sCompanyCode, sConnection, sQuery, sOurRef: AnsiString;
  PayDetsRec : OrderPaymentsVATPayDetailsRecType;
Begin // LoadVATPayDetails
  //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
  SQLCaller := TSQLCaller.Create(GlobalAdoConnection);
  Try
    sCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    If (FCurrentTransaction.InvDocHed = SOR) Then
      sOurRef := FCurrentTransaction.OurRef
    Else
      sOurRef := FCurrentTransaction.thOrderPaymentOrderRef;

    sQuery := 'Select vpOrderRef, vpReceiptRef, vpTransRef, vpLineOrderNo, vpSORABSLineNo, ' +
                     'vpType, vpCurrency, vpDescription, vpVATCode, vpGoodsValue, ' +
                     'vpVATValue, vpUserName, vpDateCreated, vpTimeCreated ' +
                'From [COMPANY].OPVATPay ' +
               'Where (vpOrderRef=' + QuotedStr(sOurRef) + ') ' +
                 'And ((vpSORABSLineNo <> 0) Or (vpGoodsValue <> 0) Or (vpVATValue <> 0)) ' +
               'Order By vpType, vpOrderRef, vpLineOrderNo';
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
            AddVATPayDetails(PayDetsRec);

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
End; // LoadVATPayDetails

//-------------------------------------------------------------------------

// CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment
function TMSSQLOrderPaymentsTransactionInfo.HasManualPayments(
  SORRef: string): Boolean;
const
  Qry =
    'SELECT thOurRef' +
    ', thOrderPaymentElement' +
    ', thOrderPaymentOrderRef' +
    ', SORMatch.DocRef' +
    ', SINMatch.PayRef' +
    ', SINMatch.MatchType ' +
    'FROM [COMPANY].FinancialMatching AS SORMatch ' +
    'INNER JOIN [COMPANY].FinancialMatching AS SINMatch ON SORMatch.DocRef = SINMatch.DocRef ' +
    'INNER JOIN [COMPANY].DOCUMENT AS DocMatch ON DocMatch.thOurRef = SINMatch.PayRef ' +
    'WHERE SORMatch.PayRef = ''%s'' AND ' +
    ' SINMatch.MatchType = ''A'' AND ' +
    ' thOrderPaymentOrderRef <> SORMatch.PayRef ';
var
  QryStr: string;
  PayDetsRec : OrderPaymentsVATPayDetailsRecType;
Begin // LoadVATPayDetails
  Result := False;
  PrepareSQLCaller;
  QryStr := Format(Qry, [SORRef]);
  FSQLCaller.Select(QryStr, FCompanyCode);
  If (FSQLCaller.ErrorMsg = '') Then
    Result := (FSQLCaller.Records.RecordCount > 0);
  FSQLCaller.Close;
end;

//-------------------------------------------------------------------------

procedure TMSSQLOrderPaymentsTransactionInfo.PrepareSQLCaller;
begin
  //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
  if not Assigned(FSQLCaller) then
    FSQLCaller := TSQLCaller.Create(GlobalAdoConnection);

  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
end;

//-------------------------------------------------------------------------

destructor TMSSQLOrderPaymentsTransactionInfo.Destroy;
begin
  if Assigned(FSQLCaller) then
  begin
    FSQLCaller.Close;
    FSQLCaller.Free;
  end;
  inherited;
end;

//=========================================================================

End.
