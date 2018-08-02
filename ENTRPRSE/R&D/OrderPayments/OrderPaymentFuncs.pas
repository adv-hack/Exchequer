Unit OrderPaymentFuncs;

Interface

Uses GlobVar, VarConst;

// Calculates the text for the OP Status column on the SOR Daybook
Function CalcOrderPaymentStatus (Const OrderPaymentElement : enumOrderPaymentElement; Const OrderPaymentFlags : Integer) : String;

//PR: 10/08/2015 ABSEXCH-16388 Function to check whether order is fully paid
function OrderIsFullyPaid(const InvR : InvRec) : Boolean;

Implementation

uses
  oOrderPaymentsTransactionInfo;

//=========================================================================

// Calculates the text for the OP Status column on the SOR Daybook
Function CalcOrderPaymentStatus (Const OrderPaymentElement : enumOrderPaymentElement; Const OrderPaymentFlags : Integer) : String;
Begin // CalcOrderPaymentStatus
  // Check transaction type - status is only shown for Orders
  If (OrderPaymentElement = opeOrder) Then
  Begin
    // Check to see if any payment has been taken
    If (OrderPaymentFlags <> 0) Then
    Begin
      Result := '';

      // Check for Credit Card Authorisation
      If ((OrderPaymentFlags And thopfCreditCardAuthorisationTaken) = thopfCreditCardAuthorisationTaken) Then
        Result := Result + 'A';

      // Check for Credit Card Payment
      If ((OrderPaymentFlags And thopfCreditCardPaymentTaken) = thopfCreditCardPaymentTaken) Then
        Result := Result + 'C';

      If ((OrderPaymentFlags And thopfPaymentTaken) = thopfPaymentTaken) Then
        // Order Payments - Payment Taken
        Result := Result + 'P'
    End // If (thOrderPaymentFlags <> 0)
    Else
      // Unpaid
      Result := 'U'
  End // If (OrderPaymentElement = opeOrder)
  Else
    // Leave blank for SDN's and non-Order Payments SOR's
    Result := '';
End; // CalcOrderPaymentStatus

//-------------------------------------------------------------------------

//PR: 10/08/2015 ABSEXCH-16388 Function to check whether order is fully paid
function OrderIsFullyPaid(const InvR : InvRec) : Boolean;
var
  iOPPaymentInfo : IOrderPaymentsTransactionInfo;
begin
  iOPPaymentInfo := OPTransactionInfo (InvR);
  Try
    //Is the order fully paid? Check (1) that it's an OP order and (2) that there is nothing outstanding on it
    Result := (InvR.thOrderPaymentElement = opeOrder) and (iOPPaymentInfo.optOutstandingTotal = 0.00);
  Finally
    iOPPaymentInfo := NIL;
  End; // Try..Finally
end;





End.
