Unit oOPPreviousVATTracker;

Interface

Uses Classes, SysUtils, StrUtils, Dialogs, GlobVar, VarConst, oOPVATPayBtrieveFile;

Type
  // Generic interface for objects which implement a specific import type
  IOPPreviousVATTracker = Interface
    ['{D4F955FE-ED6B-483A-99D8-10B8E8FE17F6}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOrderVAT : Double;
    Function GetDeliveryNoteVAT : Double;

    // ------------------ Public Properties ------------------
    Property pvtOrderVAT : Double Read GetOrderVAT;
    Property pvtDeliveryNoteVAT : Double Read GetDeliveryNoteVAT;

    // ------------------- Public Methods --------------------
  End; // IOPPreviousVATTracker

  //------------------------------

// Singleton for calulating the previously declared VAT for an invoice
Function OrderPaymentsPreviousVATTracker (Const Transaction : InvRec) : IOPPreviousVATTracker;

// Shutdown routine to reset the singleton called during Change Company and Shutdown
Procedure ResetOrderPaymentsPreviousVATTracker;

Implementation

Uses VarRec2U, BtrvU2, SavePos, SQLUtils, BTKeys1U, ETMiscU;

Type
  TOPPreviousVATTracker = Class(TInterfacedObject, IOPPreviousVATTracker)
  Private
    FCurrentTransaction : InvRec;
    FOrderVAT : Double;
    FDeliveryNoteVAT : Double;

    // Load the payment transaction and check it falls into scope
    Procedure CheckPayment(Const PaymentMatching : MatchPayType);

    // Run through the financial matching against the SIN to determine what transactions
    // are currently matched to it - only interested in Order Payments SRC's added against
    // Orders and Delivery Notes
    Procedure FindMatchedPayments;

    Procedure ResetTotals;

    Function LoadOrderPaymentMatchingVATTotal (Const OrderRef, InvoiceRef, PaymentRef : ShortString) : Double; Virtual; Abstract;

    // IOPPreviousVATTracker
    Function GetOrderVAT : Double;
    Function GetDeliveryNoteVAT : Double;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure CheckTransaction(Const Transaction : InvRec);
  End; // TOPPreviousVATTracker

  //------------------------------

  TPervasiveOPPreviousVATTracker = Class(TOPPreviousVATTracker)
  Private
    OPVATPayFile : TOrderPaymentsVATPayDetailsBtrieveFile;

    Function LoadOrderPaymentMatchingVATTotal (Const OrderRef, InvoiceRef, PaymentRef : ShortString) : Double; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TPervasiveOPPreviousVATTracker

  //------------------------------

  TMSSQLOPPreviousVATTracker = Class(TOPPreviousVATTracker)
  Private
    Function LoadOrderPaymentMatchingVATTotal (Const OrderRef, InvoiceRef, PaymentRef : ShortString) : Double; Override;
  End; // TMSSQLOPPreviousVATTracker

  //------------------------------

Var
 lOPPreviousVATTrackerObj : TOPPreviousVATTracker;
 lOPPreviousVATTrackerIntf : IOPPreviousVATTracker;

//=========================================================================

// Singleton for calulating the previously declared VAT for an invoice
Function OrderPaymentsPreviousVATTracker (Const Transaction : InvRec) : IOPPreviousVATTracker;
Begin // OrderPaymentsPreviousVATTracker
  If (Not Assigned(lOPPreviousVATTrackerIntf)) Then
  Begin
    If SQLUtils.UsingSQL Then
      lOPPreviousVATTrackerObj := TMSSQLOPPreviousVATTracker.Create
    Else
      lOPPreviousVATTrackerObj := TPervasiveOPPreviousVATTracker.Create;
    lOPPreviousVATTrackerIntf := lOPPreviousVATTrackerObj;
  End; // If (Not Assigned(lOPPreviousVATTrackerIntf))

  lOPPreviousVATTrackerObj.CheckTransaction(Transaction);

  Result := lOPPreviousVATTrackerIntf;
End; // OrderPaymentsPreviousVATTracker

//------------------------------

// Shutdown routine to reset the singleton called during Change Company and Shutdown
Procedure ResetOrderPaymentsPreviousVATTracker;
Begin // ResetOrderPaymentsPreviousVATTracker
 lOPPreviousVATTrackerObj := NIL;
 lOPPreviousVATTrackerIntf := NIL;
End; // ResetOrderPaymentsPreviousVATTracker

//=========================================================================

Constructor TOPPreviousVATTracker.Create;
Begin // Create
  Inherited Create;

  FillChar(FCurrentTransaction, SizeOf(FCurrentTransaction), #0);
  ResetTotals;
End; // Create

//------------------------------

Destructor TOPPreviousVATTracker.Destroy;
Begin // Destroy

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TOPPreviousVATTracker.ResetTotals;
Begin // ResetTotals
  FOrderVAT := 0.0;
  FDeliveryNoteVAT := 0.0;
End; // ResetTotals

//-------------------------------------------------------------------------

Procedure TOPPreviousVATTracker.CheckTransaction(Const Transaction : InvRec);
Begin // CheckTransaction
  // Check for change in transaction
//  If (Transaction.OurRef <> FCurrentTransaction.OurRef) Then
  Begin
    FCurrentTransaction := Transaction;
    ResetTotals;

    If (Transaction.InvDocHed = SIN) Then
    Begin
      // Run through the financial matching against the SIN to determine what transactions
      // are currently matched to it - we can't rely on the Matching rows in OPVATPAY as
      // they could have unallocated the transactions and re-matched them differently
      FindMatchedPayments;
    End; // If (Transaction.InvDocHed = SIN)
  End; // If (Transaction.OurRef <> FCurrentTransaction.OurRef)
End; // CheckTransaction

//-------------------------------------------------------------------------

// Run through the financial matching against the SIN to determine what transactions
// are currently matched to it - only interested in Order Payments SRC's added against
// Orders and Delivery Notes
Procedure TOPPreviousVATTracker.FindMatchedPayments;
Var
  oInvSavePos : TBtrieveSavePosition;
  oPwrdSavePos : TBtrieveSavePosition;
  sKey : Str255;
  iStatus : Integer;
Begin // FindMatchedPayments
  // Save the data/position in the global file as it could be in use by the form printing
  oInvSavePos := TBtrieveSavePosition.Create;
  oPwrdSavePos := TBtrieveSavePosition.Create;
  Try
    // Save the current position in the file for the current key
    oInvSavePos.SaveDataBlock (@Inv, SizeOf(Inv));
    oInvSavePos.SaveFilePosition (InvF, GetPosKey);

    oPwrdSavePos.SaveDataBlock (@Password, SizeOf(Password));
    oPwrdSavePos.SaveFilePosition (PwrdF, GetPosKey);

    //------------------------------

    sKey := FullMatchKey(MatchTCode, MatchSCode, FCurrentTransaction.OurRef);
    iStatus := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, sKey);
    While (iStatus = 0) And (Trim(Password.MatchPayRec.DocCode) = Trim(FCurrentTransaction.OurRef)) Do
    Begin
      // Ignore everything except Financial Matching
      If (Password.MatchPayRec.MatchType = 'A') Then
      Begin
        CheckPayment(Password.MatchPayRec);
      End; // If (Password.MatchPayRec.MatchType = 'A')

      iStatus := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, sKey);
    End; // While (iStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff))

    //------------------------------

    // Restore positions in file
    oInvSavePos.RestoreDataBlock (@Inv);
    oInvSavePos.RestoreSavedPosition;

    oPwrdSavePos.RestoreDataBlock (@Password);
    oPwrdSavePos.RestoreSavedPosition;
  Finally
    oInvSavePos.Free;
    oPwrdSavePos.Free;
  End; // Try..Finally
End; // FindMatchedPayments

//-------------------------------------------------------------------------

// Load the payment transaction and check it falls into scope
Procedure TOPPreviousVATTracker.CheckPayment(Const PaymentMatching : MatchPayType);
Var
  sKey : Str255;
  iStatus : Integer;
  VATValue : Double;
Begin // CheckPayment
  // Load the Payment transaction header
  sKey := FullOurRefKey(PaymentMatching.PayRef);
  iStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, sKey);

  // Check it is an Order Payments payment made against an order or delivery note - otherwise
  // we ignore it
  If (iStatus = 0) And (Inv.InvDocHed = SRC) And (Inv.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment]) Then
  Begin
    // Get the matching details from the OPVATPay table between the SIN and the SRC
    VATValue := LoadOrderPaymentMatchingVATTotal (FCurrentTransaction.thOrderPaymentOrderRef, FCurrentTransaction.OurRef, Inv.OurRef);

    If (Inv.thOrderPaymentElement = opeOrderPayment) Then
      // Payment made against Order
      FOrderVAT := Round_Up(FOrderVAT + VATValue, 2)
    Else
      // Payment made against Delivery Note
      FDeliveryNoteVAT := Round_Up(FDeliveryNoteVAT + VATValue, 2);
  End; // If (iStatus = 0) And (Inv.InvDocHed = SRC) And (Inv.thOrderPaymentElement In [opeOrderPayment, opeDeliveryPayment])
End; // CheckPayment

//-------------------------------------------------------------------------

Function TOPPreviousVATTracker.GetOrderVAT : Double;
Begin // GetOrderVAT
  Result := FOrderVAT
End; // GetOrderVAT

//------------------------------

Function TOPPreviousVATTracker.GetDeliveryNoteVAT : Double;
Begin // GetDeliveryNoteVAT
  Result := FDeliveryNoteVAT
End; // GetDeliveryNoteVAT

//=========================================================================

Constructor TPervasiveOPPreviousVATTracker.Create;
Begin // Create
  Inherited Create;

  OPVATPayFile := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
  OPVATPayFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
End; // Create

//------------------------------

Destructor TPervasiveOPPreviousVATTracker.Destroy;
Begin // Destroy
  FreeAndNIL(OPVATPayFile);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TPervasiveOPPreviousVATTracker.LoadOrderPaymentMatchingVATTotal (Const OrderRef, InvoiceRef, PaymentRef : ShortString) : Double;
Var
  iStatus : Integer;
Begin // LoadOrderPaymentMatchingVATTotal
  Result := 0.0;

  // Run through the OPVATPay.Dat rows for the SOR/SRC and add up the VAT values
  OPVATPayFile.Index := vpIdxReceiptRef;
  iStatus := OPVATPayFile.GetGreaterThanOrEqual(OPVATPayFile.BuildReceiptRefKey(OrderRef, PaymentRef));
  While (iStatus = 0) And
        (Trim(OPVATPayFile.VATPayDetails.vpOrderRef) = Trim(OrderRef)) And
        (Trim(OPVATPayFile.VATPayDetails.vpReceiptRef) = Trim(PaymentRef)) Do
  Begin
    If (OPVATPayFile.VATPayDetails.vpType = vptMatching) Then
      Result := Round_Up(Result + OPVATPayFile.VATPayDetails.vpVATValue, 2);

    iStatus := OPVATPayFile.GetNext;
  End; // While (iStatus = 0) And ...
End; // LoadOrderPaymentMatchingVATTotal

//=========================================================================

Function TMSSQLOPPreviousVATTracker.LoadOrderPaymentMatchingVATTotal (Const OrderRef, InvoiceRef, PaymentRef : ShortString) : Double;
Var
  VATSum : Variant;
  Res : Integer;
Begin // LoadOrderPaymentMatchingVATTotal
  Res := SQLFetch('Select SUM(vpVATValue) As VATTotal ' +
                    'From [COMPANY].OPVATPay ' +
                   'Where (vpOrderRef=' + QuotedStr(OrderRef) + ') ' +
                     'And (vpReceiptRef=' + QuotedStr(PaymentRef) + ') ' +
                     'And (vpTransRef=' + QuotedStr(InvoiceRef) + ') ' +
                     'And (vpType=' + IntToStr(Ord(vptMatching)) + ')',
                  'VATTotal',
                  SetDrive,
                  VATSum);

  If (Res = 0) Then
    Result := VATSum
  Else
    Result := 0.0;
End; // LoadOrderPaymentMatchingVATTotal

//=========================================================================

Initialization
  ResetOrderPaymentsPreviousVATTracker;
Finalization
  ResetOrderPaymentsPreviousVATTracker;
End.
