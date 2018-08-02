Unit oOrderPaymentsBaseTransactionInfo;

Interface

Uses Classes, SysUtils, OrderPaymentsInterfaces, GlobVar, VarConst, ExBTTh1U;

Type
  // Generic base interface for the Payment / Refund objects in the Order Payments system
  TOrderPaymentsBaseTransactionInfo = Class(TInterfacedObject, IOrderPaymentsBaseTransactionInfo)
  Protected
    FClientId : Integer;
    FExLocal : TdPostExLocal;

    // CJS 2015-01-29 - ABSEXCH-16068 - Order Payments delay in opening SINs
    // Flag to indicate whether or not LoadOrder successfully found and loaded
    // the originating Sales Order lines
    FHasLines: Boolean;

    FOriginalOrder : InvRec;
    FOriginalOrderLocked : Boolean;
    FOriginalOrderLockPos : LongInt;

    FCurrentTransaction : InvRec;
    FCurrentTransactionLocked : Boolean;
    FCurrentTransactionLockPos : LongInt;

    // Loads the original order for the SDN/SIN
    Procedure LoadOrder;
    // Frees any record locks successfully applied by LockTransaction
    Procedure UnLockTransaction;

    // IOrderPaymentsBaseTransactionInfo methods -------------------------------
    Function GetExLocal : TdPostExLocalPtr;
    Function GetTransaction : InvRec;
    Function GetTransactionCurrency : Byte;
    Function GetTransactionCurrencySymbol : String;

    // Applies a record lock to the Transaction (SOR/SDN/SIN) to prevent multi-user whoopsie's happening
    Function LockTransaction : Boolean;

    // Abstract methods to be implemented in descendants -----------------------
    // Loads the Transaction Lines for the current transaction and order as required
    Procedure LoadTransactionLines; Virtual; Abstract;
    // Processes an Order Line loaded by LoadTransactionLines
    Procedure ProcessOrderLine (Const OrderLine : IDetail); Virtual; Abstract;

  Public
    Constructor Create (Const Transaction : InvRec);
    Destructor Destroy; Override;
  End; // TOrderPaymentsTransactionInfo

Implementation

Uses BtrvU2, BTKeys1U, CurrncyU;

Var
  ClientIds : TBits;

//=========================================================================

Constructor TOrderPaymentsBaseTransactionInfo.Create (Const Transaction : InvRec);
Begin // Create
  Inherited Create;

  // ExLocal instance for data access to avoid interference with other code, use a unique ClientId
  // for each instance to prevent locking issues between instances
  FClientId := ClientIds.OpenBit;

  //PR: 16/09/2014 ABSEXCH-15635 Need to set the bit to true.
  ClientIds.Bits[FClientId] := True;
  FExLocal.Create(FClientId, 'OP');

  // Open required Data Files - minimise number of files being opened to reduce overhead
  FExLocal.Open_System(CustF,CustF);
  FExLocal.Open_System(InvF,IDetailF);
  FExLocal.Open_System(NHistF,NHistF); // Customer balances
  FExLocal.Open_System(PwrdF,PwrdF);   // Audit notes, Matching
  FExLocal.Open_System(IncF,IncF);     // Doc Numbers

  // Stash the transaction locally for reference
  FCurrentTransaction := Transaction;
  FCurrentTransactionLocked := False;
  FCurrentTransactionLockPos := 0;

  // Initialise and load the original order properties
  FillChar (FOriginalOrder, SizeOf(FOriginalOrder), #0);
  FOriginalOrderLocked := False;
  FOriginalOrderLockPos := 0;
  // CJS 2015-01-29 - ABSEXCH-16068 - Order Payments delay in opening SINs
  FHasLines := True;
  If (FCurrentTransaction.InvDocHed <> SOR) Then
    LoadOrder
  Else
    FOriginalOrder := FCurrentTransaction;
End; // Create

//------------------------------

Destructor TOrderPaymentsBaseTransactionInfo.Destroy;
Begin // Destroy
  // Free any record locks held on the transaction(s)
  UnLockTransaction;

  // Destroy the exlocal instance and mark the ClientId number as available again
  FExLocal.Close_Files;
  FExLocal.Destroy;
  ClientIds[FClientId] := False;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Loads the original order for the SDN/SIN
Procedure TOrderPaymentsBaseTransactionInfo.LoadOrder;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadOrder
  sKey := FullOurRefKey (FCurrentTransaction.thOrderPaymentOrderRef);
  iStatus := FExLocal.LFind_Rec (B_GetEq, InvF, InvOurRefK, sKey);
  // CJS 2015-01-29 - ABSEXCH-16068 - Order Payments delay in opening SINs
  If (iStatus = 0) Then
  begin
    FOriginalOrder := FExLocal.LInv;
    FHasLines := True;
  end
  else
    FHasLines := False;

  // Error Handling? It shouldn't ever fail to find the order, unless the data is
  // borked or the SOR has been purged before all its corresponding transactions
  // have been paid.  This should be caught by the checks in descendant objects which
  // should prevent any further operations being performed via Order Payments - the user
  // should still be able to take payments through the normal mechanisms

End; // LoadOrder

//-------------------------------------------------------------------------

// Applies a record lock to the Transaction (SOR/SDN/SIN) to prevent multi-user whoopsie's happening
Function TOrderPaymentsBaseTransactionInfo.LockTransaction : Boolean;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LockTransaction
  // Lock the current transaction ---------------------
  sKey := FCurrentTransaction.OurRef;
  iStatus := FExLocal.LFind_Rec (B_GetEq + B_MultNWLock, InvF, InvOurRefK, sKey);

  FCurrentTransactionLocked := (iStatus = 0);
  If FCurrentTransactionLocked Then
  Begin
    // Update Current Transaction to the latest (just in case)
    FCurrentTransaction := FExLocal.LInv;
    If (FCurrentTransaction.InvDocHed = SOR) Then
      FOriginalOrder := FCurrentTransaction;

    // Store the position so we can unlock it again later
    FExLocal.LGetRecAddr(InvF);
    FCurrentTransactionLockPos := FExLocal.LastRecAddr[InvF];
  End; // If FCurrentTransactionLocked

  // Lock the original order as well ------------------
  If (FCurrentTransaction.InvDocHed <> SOR) And (FOriginalOrder.OurRef = FCurrentTransaction.thOrderPaymentOrderRef) Then
  Begin
    sKey := FOriginalOrder.OurRef;
    iStatus := FExLocal.LFind_Rec (B_GetEq + B_MultNWLock, InvF, InvOurRefK, sKey);

    FOriginalOrderLocked := (iStatus = 0);
    If FOriginalOrderLocked Then
    Begin
      // Store the position so we can unlock it again later
      FExLocal.LGetRecAddr(InvF);
      FOriginalOrderLockPos := FExLocal.LastRecAddr[InvF];
    End; // If FOriginalOrderLocked
  End; // If (FCurrentTransaction.InvDocHed <> SOR) And (FOriginalOrder.OurRef = FCurrentTransaction.thOrderPaymentOrderRef)

  Result := FCurrentTransactionLocked;
End; // LockTransaction

//------------------------------

// Frees any record locks successfully applied by LockTransaction
Procedure TOrderPaymentsBaseTransactionInfo.UnLockTransaction;
Begin // UnLockTransaction
  If FCurrentTransactionLocked Then
  Begin
    // Note: Ignore any errors from the unlock call as any popup messages or exceptions
    // would actually cause worse problems
    FExLocal.UnLockMLock(InvF, FCurrentTransactionLockPos);
    FCurrentTransactionLocked := False;
    FCurrentTransactionLockPos := 0;
  End; // If FCurrentTransactionLocked

  If FOriginalOrderLocked Then
  Begin
    // Note: Ignore any errors from the unlock call as any popup messages or exceptions
    // would actually cause worse problems
    FExLocal.UnLockMLock(InvF, FOriginalOrderLockPos);
    FOriginalOrderLocked := False;
    FOriginalOrderLockPos := 0;
  End; // If FOriginalOrderLocked
End; // UnLockTransaction

//-------------------------------------------------------------------------

Function TOrderPaymentsBaseTransactionInfo.GetExLocal : TdPostExLocalPtr;
Begin // GetExLocal
  Result := @FExLocal;
End; // GetExLocal

//------------------------------

Function TOrderPaymentsBaseTransactionInfo.GetTransaction : InvRec;
Begin // GetTransaction
  Result := FCurrentTransaction
End; // GetTransaction

//------------------------------

Function TOrderPaymentsBaseTransactionInfo.GetTransactionCurrency : Byte;
Begin // GetTransactionCurrency
  Result := FCurrentTransaction.Currency;
End; // GetTransactionCurrency

Function TOrderPaymentsBaseTransactionInfo.GetTransactionCurrencySymbol : String;
Begin // GetTransactionCurrencySymbol
  Result := SSymb(FCurrentTransaction.Currency);
End; // GetTransactionCurrencySymbol

//=========================================================================

Initialization
  // Use the ClientIds TBits to generate unique Client Id numbers across multiple instances
  // of the object
  ClientIds := TBits.Create;
  ClientIds[0] := True;  // Reserve so we start at 1
Finalization
  FreeAndNIL(ClientIds);
End.
