Unit OrdPayCustomisation;

Interface

Uses Classes, GlobVar, VarConst;

Type
  // Generic interface for objects which implement a specific import type
  IOrderPaymentsCustomisationTransactionTracker = Interface
    ['{C36D3313-79F8-47EE-AD46-17FACC464269}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOurRef : ShortString;
    Function GetCanEdit : Boolean;
    Function GetLineHasPayments (Index : Integer) : Boolean;

    // ------------------ Public Properties ------------------
    Property cttOurRef : ShortString Read GetOurRef;
    Property cttCanEdit : Boolean Read GetCanEdit;

    // MH 02/06/2015 Exch-R1 ABSEXCH-16475: Added tracking of payments at the line level so the
    // user can edit newly added lines freely
    // Returns TRUE if the specified transaction line (ABSLineNo) has a non-zero payment value
    Property cttLineHasPayments [Index: Integer] : Boolean Read GetLineHasPayments;

    // ------------------- Public Methods --------------------
  End; // IOrderPaymentsCustomisationTransactionTracker

  //------------------------------

// This singleton is used by the Customisation objects to determine whether fields affecting
// the transaction value can be be changed.  When tabbing through the windows the customisation
// will run up and shutdown many customisation objects, hence this caching mechanism to minimise
// the overhead
Function OrderPaymentsCustomisationTransactionTracker (Const Transaction : InvRec) : IOrderPaymentsCustomisationTransactionTracker;

// Reset function clears down any existing tracker and is called from OpenCompany and the
// Payment/Refund processes on the client.
Procedure ResetOrderPaymentsCustomisationTransactionTracker;

Implementation

{$IFDEF SOP}
Uses OrderPaymentsInterfaces, oOrderPaymentsTransactionPaymentInfo;
{$ENDIF SOP}

Type
  TOrderPaymentsCustomisationTransactionTracker = Class(TInterfacedObject, IOrderPaymentsCustomisationTransactionTracker)
  Private
    FTransaction : InvRec;
    FCanEdit : Boolean;
    FLinePayments : TBits;

    // IOrderPaymentsCustomisationTransactionTracker
    Function GetOurRef : ShortString;
    Function GetCanEdit : Boolean;
    // MH 02/06/2015 Exch-R1 ABSEXCH-16475: Added tracking of payments at the line level so the
    // user can edit newly added lines freely
    Function GetLineHasPayments (Index : Integer) : Boolean;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure CheckTransaction(Const Transaction : InvRec);
  End; // TOrderPaymentsCustomisationTransactionTracker



Var
 lOrderPaymentsCustomisationTransactionTrackerObj : TOrderPaymentsCustomisationTransactionTracker;
 lOrderPaymentsCustomisationTransactionTrackerIntf : IOrderPaymentsCustomisationTransactionTracker;

//=========================================================================

Function OrderPaymentsCustomisationTransactionTracker (Const Transaction : InvRec) : IOrderPaymentsCustomisationTransactionTracker;
Begin // OrderPaymentsCustomisationTransactionTracker
  If (Not Assigned(lOrderPaymentsCustomisationTransactionTrackerIntf)) Then
  Begin
    lOrderPaymentsCustomisationTransactionTrackerObj := TOrderPaymentsCustomisationTransactionTracker.Create;
    lOrderPaymentsCustomisationTransactionTrackerIntf := lOrderPaymentsCustomisationTransactionTrackerObj;
  End; // If (Not Assigned(lOrderPaymentsCustomisationTransactionTrackerIntf))

  lOrderPaymentsCustomisationTransactionTrackerObj.CheckTransaction(Transaction);

  Result := lOrderPaymentsCustomisationTransactionTrackerIntf;
End; // OrderPaymentsCustomisationTransactionTracker

//-------------------------------------------------------------------------

Procedure ResetOrderPaymentsCustomisationTransactionTracker;
Begin // ResetOrderPaymentsCustomisationTransactionTracker
  lOrderPaymentsCustomisationTransactionTrackerObj := NIL;
  lOrderPaymentsCustomisationTransactionTrackerIntf := NIL;
End; // ResetOrderPaymentsCustomisationTransactionTracker

//=========================================================================

Constructor TOrderPaymentsCustomisationTransactionTracker.Create;
Begin // Create
  Inherited Create;

  FillChar(FTransaction, SizeOf(FTransaction), #0);
  FCanEdit := False;
  FLinePayments := TBits.Create;
End; // Create

//------------------------------

Destructor TOrderPaymentsCustomisationTransactionTracker.Destroy;
Begin // Destroy
  FLinePayments.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TOrderPaymentsCustomisationTransactionTracker.GetOurRef : ShortString;
Begin // GetOurRef
  Result := FTransaction.OurRef;
End; // GetOurRef

//------------------------------

Function TOrderPaymentsCustomisationTransactionTracker.GetCanEdit : Boolean;
Begin // GetCanEdit
  Result := FCanEdit;
End; // GetCanEdit

//------------------------------

// MH 02/06/2015 Exch-R1 ABSEXCH-16475: Added tracking of payments at the line level so the
// user can edit newly added lines freely
Function TOrderPaymentsCustomisationTransactionTracker.GetLineHasPayments (Index : Integer) : Boolean;
Begin // GetLineHasPayments
  If (Index >= 0) And (Index < FLinePayments.Size) Then
    Result := FLinePayments[Index]
  Else
    Result := False;
End; // GetLineHasPayments

//-------------------------------------------------------------------------

// Checks whether a transaction can be freely edited - if an order payments transaction has
// been part paid then it is locked down until it has been refunded
Procedure TOrderPaymentsCustomisationTransactionTracker.CheckTransaction(Const Transaction : InvRec);
{$IFDEF SOP}
Var
  iOPTransactionPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
  I : Integer;
{$ENDIF SOP}
Begin // CheckTransaction
  {$IFDEF SOP}
    If Syss.ssEnableOrderPayments Then
    Begin
      // Check transaction has changed from any cached transaction to minimise unnecessary
      // data access
      If (Transaction.OurRef <> FTransaction.OurRef) Then
      Begin
        FTransaction := Transaction;

        // Reset the tracking of lines with payments
        FLinePayments.Size := 0;

        If (FTransaction.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice]) Then
        Begin
          // Now we need to run through OPVATPAY.DAT and determine the net payments position -
          // this could involve a lot of data access - hence the checks and caching mechanism
          iOPTransactionPaymentInfo := OPTransactionPaymentInfo(FTransaction);
          Try
            FCanEdit := (iOPTransactionPaymentInfo.GetPaymentCount = 0);

            // MH 02/06/2015 Exch-R1 ABSEXCH-16475: Added tracking of payments at the line level so the
            // user can edit newly added lines freely
            If (iOPTransactionPaymentInfo.GetPaymentCount > 0) Then
            Begin
              // Run through the Order Lines and record which ones have payments against them
              For I := 0 To (iOPTransactionPaymentInfo.oppiOrderLineCount - 1) Do
              Begin
                If (iOPTransactionPaymentInfo.oppiOrderLines[I].opolNetPaymentTotal <> 0.0) Then
                Begin
                  // Check to see if the FLinePayments array is large enough
                  If (iOPTransactionPaymentInfo.oppiOrderLines[I].opolLine.ABSLineNo >= FLinePayments.Size) Then
                    // No - increase it as required - the array is 0 based, so we need to add 1 when setting the size
                    FLinePayments.Size := iOPTransactionPaymentInfo.oppiOrderLines[I].opolLine.ABSLineNo + 1;

                  // Set the entry for the line to TRUE to indicate that a payment exists
                  FLinePayments[iOPTransactionPaymentInfo.oppiOrderLines[I].opolLine.ABSLineNo] := True;
                End; // If (iOPTransactionPaymentInfo.oppiOrderLines[I].opolNetPaymentTotal <> 0.0)
              End; // For I
            End; // If (iOPTransactionPaymentInfo.GetPaymentCount > 0)
          Finally
            iOPTransactionPaymentInfo := NIL;
          End; // Try..Finally
        End // If (FTransaction.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice])
        Else
          // Not an Order Payments transaction
          FCanEdit := True;
      End; // If (Transaction.OurRef <> FTransaction.OurRef)
    End // If Syss.ssEnableOrderPayments
    Else
      // Order Payments not enabled - so No Order Payments = no limitation
      FCanEdit := True;
  {$ELSE}
    // Order Payments is SPOP specific - so No SPOP = no limitation
    FCanEdit := True;
  {$ENDIF}
End; // CheckTransaction

//-------------------------------------------------------------------------

Initialization
  ResetOrderPaymentsCustomisationTransactionTracker;
Finalization
  ResetOrderPaymentsCustomisationTransactionTracker;
end.
