Unit TTD;

{$If not (Defined(SOP) or Defined(COMTK))}
  This unit should not be compiling into this application/dll
{$IfEnd}

Interface

Uses Classes, Controls, Dialogs, Forms, SysUtils, Windows, GlobVar, VarConst, BtrvU2, TEditVal,
     VBD;

Type
  TTTDTransactionMode = (tmView, tmAdd, tmEdit);

  //------------------------------

  TTTDBaseHelper = Class(TObject)
  Private
    FApplyTTD : Boolean;
    FEnabled : Boolean;
    FTTDEnabled : Boolean;
    FTransactionMode : TTTDTransactionMode;
    //PR: 20/05/2009 Added extract
    {$IFDEF COMTK}
    FDiscountAmount : Double;
    FDiscountChar : Char;
    {$ENDIF}
    Function GetEnabled : Boolean;
    Function GetTTDEnabled : Boolean;
    Procedure SetApplyTTD (Value : Boolean); Virtual;
  Public
    // ApplyTTD - Indicates that the user has selected to apply TTD
    Property ApplyTTD : Boolean Read FApplyTTD Write SetApplyTTD;
    // Enabled - Indicates that Advanced Discounts (TTD or VBD) can be applied to this transaction
    //           based on the transaction checks and transaction mode
    Property Enabled : Boolean Read GetEnabled;
    Property TransactionMode : TTTDTransactionMode Read FTransactionMode Write FTransactionMode;
    // TTDEnabled - Indicates that TTD is enabled
    Property TTDEnabled : Boolean Read GetTTDEnabled;

    {$IFDEF COMTK}
    property DiscountAmount : Double read FDiscountAmount write FDiscountAmount;
    property DiscountChar : Char read FDiscountChar write FDiscountChar;
    {$ENDIF}
    Constructor Create;
    Procedure ScanTransaction(Var ADTrans : InvRec); Virtual; Abstract;
  End; // TTTDBaseHelper

  //------------------------------

  // Helper class used by Transaction Dialog in Exchequer
  TTTDTelesaleHelper = Class(TTTDBaseHelper)
  Private
    FOwner : TComponent;
  Public
    Property Owner : TComponent Read FOwner Write FOwner;

    Procedure ScanTransaction(Var ADTrans : InvRec); Override;
    Procedure OfferTTD (Var ADTrans : InvRec);
  End; // TTTDTelesaleHelper

  //------------------------------

  // Helper class used by Transaction Dialog in Exchequer
  TTTDTransactionHelper = Class(TTTDBaseHelper)
  Private
    FTTDExists : Boolean;
    FOrigTransValue : Double;
    FOrigAccount : String[10];
    FOrigDate : LongDate;
    FOrigCcy : Byte;

    FOffered : Boolean;

    Procedure SetApplyTTD (Value : Boolean); Override;
    Procedure SetOrigFields (Const ADTrans : InvRec);
  Public
    Property Offered : Boolean Read FOffered Write FOffered;

    Constructor Create;
    Procedure ScanTransaction(Var ADTrans : InvRec); Override;
    Function ApplyDiscounts (Const Owner : TComponent; Const SampleControl : Text8Pt; Var ADTrans : InvRec) : Boolean;

    // Checks the transaction's costs, returns FALSE if transaction went below cost due
    // to VBD, otherwise returns TRUE
    Function CheckVBDCosts(Const ADTrans : InvRec) : Boolean;
  End; // TTTDTransactionHelper

  //------------------------------


Implementation

Uses TTDCalc, TTDF, ComnUnit, PWarnU, ETMiscU;


//=========================================================================

Constructor TTTDBaseHelper.Create;
Begin // Create
  Inherited Create;

  FApplyTTD := False;
  FEnabled := True;
  FTTDEnabled := Syss.EnableTTDDiscounts;
  FTransactionMode := tmView;
End; // Create

//-------------------------------------------------------------------------

Function TTTDBaseHelper.GetEnabled : Boolean;
Begin // GetEnabled
  Result := FEnabled And (FTransactionMode <> tmView);
End; // GetEnabled

//------------------------------

Function TTTDBaseHelper.GetTTDEnabled : Boolean;
Begin // GetTTDEnabled
  Result := FTTDEnabled;
End; // GetTTDEnabled

//------------------------------

Procedure TTTDBaseHelper.SetApplyTTD (Value : Boolean);
Begin // SetApplyTTD
  If GetEnabled Then
    FApplyTTD := Value;
End; // SetApplyTTD

//=========================================================================

Procedure TTTDTelesaleHelper.ScanTransaction(Var ADTrans : InvRec);
Begin // ScanTransaction
  If FEnabled Then  //PR: 16/07/2009 Added credit transactions  - SCR, SJC, SRF, PCR, PJC, PRF
    FEnabled := (ADTrans.InvDocHed In [SQU, SOR, SIN, SJI, SRI, SCR, SJC, SRF, PQU, POR, PIN, PJI, PPI, PCR, PJC, PRF]);
End; // ScanTransaction

//-------------------------------------------------------------------------

Procedure TTTDTelesaleHelper.OfferTTD (Var ADTrans : InvRec);
Var
  oTTDCalculator : TTTDCalculator;
  oVBDList : TVBDList;
  oVBDOffer : TVBDListItem;
  OfferVBD : Boolean;

  //------------------------------

  Procedure CreateTTDCalculator (Var TTDCalculator : TTTDCalculator);
  Begin // CreateTTDCalculator
    If (Not Assigned(TTDCalculator)) Then
    Begin
      TTDCalculator := TTTDCalculator.Create(FTransactionMode = tmAdd, @ADTrans);
      TTDCalculator.AllowSaleBelowCost := PChkAllowed_In(309);
      TTDCalculator.AllowDiscountToExceedSale := PChkAllowed_In(310);
    End; // If (Not Assigned(TTDCalculator))
  End; // CreateTTDCalculator

  //------------------------------

  Procedure CreateVBDList (Var VBDList : TVBDList);
  Begin // CreateVBDList
    If (Not Assigned(VBDList)) Then
    Begin
      VBDList := TVBDList.Create (@ADTrans);
    End; // If (Not Assigned(VBDList))
  End; // CreateVBDList

  //------------------------------

Begin // OfferTTD
  If FEnabled Then
  Begin
    Try
      oTTDCalculator := NIL;
      oVBDList := NIL;

      If FApplyTTD Then
      Begin
        CreateTTDCalculator (oTTDCalculator);
        CreateVBDList (oVBDList);

        TTDF.OfferTTD (FOwner, Nil, oTTDCalculator, oVBDList);

        OfferVBD := Not oTTDCalculator.TTDExists;
      End // If FApplyTTD
      Else
        OfferVBD := True;

      If Syss.EnableVBDDiscounts And OfferVBD Then
      Begin
        // Check to see if VBD needs to be applied
        CreateVBDList (oVBDList);
        If (oVBDList.DiscountCount > 0) Then
        Begin
          CreateTTDCalculator (oTTDCalculator);
          If (Not oTTDCalculator.TTDExists) Then
          Begin
            // No TTD - check whether VBD can be applied
            oVBDOffer := oVBDList.GetOffer(oTTDCalculator.TransTotals[ttBeforeNetTotal]);
            If Assigned (oVBDOffer) Then
            Begin
              // Apply offer
              oTTDCalculator.DiscountMode := cdmVBD;
              oTTDCalculator.CalculateAD (oVBDOffer.DiscountVal, oVBDOffer.DiscountType);
              oTTDCalculator.ApplyTTD;  // Actually applying VBD
            End; // If Assigned (oVBDOffer)
          End; // If (Not oTTDCalculator.TTDExists)
        End; // If (oVBDList.DiscountCount > 0)
      End; // If Syss.EnableVBDDiscounts And OfferVBD
    Finally
      FreeAndNIL(oTTDCalculator);
      FreeAndNIL(oVBDList);
    End; // Try..Finally
  End; // If FEnabled
End; // OfferTTD

//=========================================================================

Constructor TTTDTransactionHelper.Create;
Begin // Create
  Inherited Create;

  FTTDExists := False;
  FOrigTransValue := 0.0;
  FOrigAccount := '';
  FOrigDate := '';
  FOrigCcy := 255;  // 0 is valid for Prof systems

  FOffered := False;
End; // Create

//-------------------------------------------------------------------------

Procedure TTTDTransactionHelper.SetApplyTTD (Value : Boolean);
Begin // SetApplyTTD
  Inherited;

  If FApplyTTD Then
    FOffered := False;
End; // SetApplyTTD

//-------------------------------------------------------------------------

Procedure TTTDTransactionHelper.SetOrigFields (Const ADTrans : InvRec);
Begin // SetOrigFields
  FOrigTransValue := Round_Up(ITotal(ADTrans) - ADTrans.InvVAT, 2);
  FOrigAccount := ADTrans.CustCode;
  FOrigDate := ADTrans.TransDate;
  FOrigCcy := ADTrans.Currency;
End; // SetOrigFields

//-------------------------------------------------------------------------

Procedure TTTDTransactionHelper.ScanTransaction (Var ADTrans : InvRec);
Begin // ScanTransaction
  If (FTransactionMode <> tmView) Then
  Begin
    //PR: 16/07/2009 Added credit transactions  - SCR, SJC, SRF, PCR, PJC, PRF
    FEnabled := (ADTrans.InvDocHed In [SQU, SOR, SIN, SJI, SRI, SCR, SJC, SRF, PQU, POR, PIN, PJI, PPI, PCR, PJC, PRF]);

    If FEnabled And (FTransactionMode = tmEdit) Then
      SetOrigFields (ADTrans);
  End; // If (FTransactionMode = tmEdit)
End; // ScanTransaction

//-------------------------------------------------------------------------

Function TTTDTransactionHelper.ApplyDiscounts (Const Owner : TComponent; Const SampleControl : Text8Pt; Var ADTrans : InvRec) : Boolean;
Var
  oTTDCalculator : TTTDCalculator;
  oVBDList : TVBDList;
  bOfferTTD, bOfferVBD, bCriticalFieldChanged, bTransactionTotalChanged : Boolean;
  oVBDOffer : TVBDListItem;

  //------------------------------

  Procedure CreateTTDCalculator (Var TTDCalculator : TTTDCalculator);
  Begin // CreateTTDCalculator
    If (Not Assigned(TTDCalculator)) Then
    Begin
      TTDCalculator := TTTDCalculator.Create(FTransactionMode = tmAdd, @ADTrans);
      TTDCalculator.AllowSaleBelowCost := PChkAllowed_In(309);
      TTDCalculator.AllowDiscountToExceedSale := PChkAllowed_In(310);
    End; // If (Not Assigned(TTDCalculator))
  End; // CreateTTDCalculator

  //------------------------------

  Procedure CreateVBDList (Var VBDList : TVBDList);
  Begin // CreateVBDList
    If (Not Assigned(VBDList)) Then
    Begin
      VBDList := TVBDList.Create (@ADTrans);
    End; // If (Not Assigned(VBDList))
  End; // CreateVBDList

  //------------------------------

Begin // ApplyDiscounts

  //PR: 17/06/2013 ABSEXCH-13516 The result was uninitialised and did not always get set later. In Importer
  //                             it was returning true which was causing totals to be recalculated even on transactions
  //                             which can't have VBDs. In COM Tk it was returning False
  //                             so there was no problem, but that may change in future builds. (In Exchequer, it's ignored.)
  Result := False;

  If FOffered Then
  Begin
    // MH 31/07/2009: Check user hasn't made changes since TTD/VBD first applied
   FOffered := (FOrigAccount = ADTrans.CustCode) And
               (FOrigDate = ADTrans.TransDate) And
               (FOrigCcy = ADTrans.Currency) And
               (FOrigTransValue = Round_Up(ITotal(ADTrans) - ADTrans.InvVAT, 2));
  End; // If FOffered

  If FEnabled And (Not FOffered) Then
  Begin
    FOffered := True;

    Try
      // Creating the TTD Calculator reads all the transaction lines so do as many checks as
      // possible before creating the TTD Calculator to minimise overhead
      oTTDCalculator := NIL;
      oVBDList := NIL;

      bOfferTTD := False; // TTD should only be offered if the user specifically requests it or it is already present and the transaction value has changed

      bTransactionTotalChanged := FOrigTransValue <> Round_Up(ITotal(ADTrans) - ADTrans.InvVAT,2);

      bCriticalFieldChanged := (FOrigAccount <> ADTrans.CustCode) Or (FOrigDate <> ADTrans.TransDate) Or (FOrigCcy <> ADTrans.Currency);

      //------------------------------

      If (FTransactionMode = tmAdd) And FApplyTTD And (ITotal(ADTrans) <> 0.0) Then
      Begin
        bOfferTTD := True
      End; // If (FTransactionMode = tmAdd) And FApplyTTD And (ITotal(ADTrans) <> 0.0)

      //------------------------------

      If (FTransactionMode = tmEdit) And FApplyTTD Then
      Begin
          bOfferTTD := True
      End; // If (FTransactionMode = tmEdit) And FApplyTTD

      //------------------------------

      If (FTransactionMode = tmEdit) And (Not bOfferTTD) And (bTransactionTotalChanged Or bCriticalFieldChanged) Then
      Begin
        CreateTTDCalculator (oTTDCalculator);
        If oTTDCalculator.TTDExists Then
          bOfferTTD := True
      End; // If (FTransactionMode = tmEdit) And (Not bOfferTTD) And (bTransactionTotalChanged Or bCriticalFieldChanged)

      //------------------------------

      If bOfferTTD Then
      Begin
        CreateTTDCalculator (oTTDCalculator);
        CreateVBDList (oVBDList);

        {$IFDEF COMTK}
        Result := oTTDCalculator.CalculateAD(FDiscountAmount, FDiscountChar);
        if Result then
          oTTDCalculator.ApplyTTD;
        {$ELSE}
        // Display TTD Offer dlg
        OfferTTD (Owner, SampleControl, oTTDCalculator, oVBDList);
        {$ENDIF}

        bOfferVBD := (Not oTTDCalculator.TTDExists) And (oVBDList.DiscountCount > 0);
      End // If bOfferTTD
      Else
        bOfferVBD := (FTransactionMode = tmAdd) Or ((FTransactionMode = tmEdit) And (bTransactionTotalChanged Or bCriticalFieldChanged));

      //------------------------------

      If Syss.EnableVBDDiscounts And bOfferVBD Then
      Begin
        If (FTransactionMode = tmEdit) Then
        Begin
          // Existing transaction being edited - check to see if the net total has changed
          // MH 12/06/09: Extended to apply VBD if offered via the TTD dialog
          If bTransactionTotalChanged or bCriticalFieldChanged Or bOfferTTD Then
          Begin
            // Total changed - check for existance of VBD and query user if VBD already exists
            CreateTTDCalculator (oTTDCalculator);
            {$IFNDEF COMTK}
            If oTTDCalculator.VBDExists Then
              // Ask user if they want to modify existing VBD
              bOfferVBD := (MessageDlg ('Value Based Discount is present on this transaction, do you want to update it to compensate for your changes',
                                        mtConfirmation, [mbYes, mbNo], 0) = mrYes)
            Else
              // No existing VBD - check to see if it now qualifies
              bOfferVBD := True;
            {$ELSE}
              bOfferVBD := False; //PR: 20/05/2009 For ComTk, don't update on edit
            {$ENDIF}


            If bOfferVBD Then
            Begin
              CreateVBDList (oVBDList);
              If (oVBDList.DiscountCount > 0) Then
              Begin
                oVBDOffer := oVBDList.GetOffer(oTTDCalculator.TransTotals[ttBeforeNetTotal]);
                If Assigned (oVBDOffer)Then
                Begin
                  // Apply offer
                  oTTDCalculator.DiscountMode := cdmVBD;
                  oTTDCalculator.CalculateAD (oVBDOffer.DiscountVal, oVBDOffer.DiscountType);
                  oTTDCalculator.ApplyTTD;  // Actually applying VBD
                End // If Assigned (oVBDOffer)
                Else
                Begin
                  If oTTDCalculator.VBDExists Then
                  Begin
                    oTTDCalculator.DiscountMode := cdmVBD;
                    oTTDCalculator.RemoveTTD;  // Actually removing VBD
                  End; // If oTTDCalculator.VBDExists
                End; // Else
              End // If (oVBDList.DiscountCount > 0)
              Else
              Begin
                If oTTDCalculator.VBDExists Then
                Begin
                  oTTDCalculator.DiscountMode := cdmVBD;
                  oTTDCalculator.RemoveTTD;  // Actually removing VBD
                End; // If oTTDCalculator.VBDExists
              End; // Else
            End; // If bOfferVBD
          End; // If bTransactionTotalChanged or bCriticalFieldChanged
        End // If (FTransactionMode = tmEdit)
        Else
        Begin
          // Adding - Check that there is VBD to apply
          CreateVBDList (oVBDList);

          // Use the TTDCalculator to detect any pre-existing TTD discounts and apply new VBD discounts
          CreateTTDCalculator (oTTDCalculator);

          // MH 31/07/2009: Need to remove any pre-existing VBD which could exist if the user clicks OK
          // on the trans header and then returns to the main tab and changes the account code - should be shot!
          If oTTDCalculator.VBDExists Then
          Begin
            oTTDCalculator.DiscountMode := cdmVBD;
            oTTDCalculator.RemoveTTD;  // Actually removing VBD
          End; // If oTTDCalculator.VBDExists

          If (oVBDList.DiscountCount > 0) Then
          Begin
            If (Not oTTDCalculator.TTDExists) Then
            Begin
              // Get applicable VBD offer
              oVBDOffer := oVBDList.GetOffer(oTTDCalculator.TransTotals[ttBeforeNetTotal]);
              If Assigned (oVBDOffer)Then
              Begin
                // Apply offer
                oTTDCalculator.DiscountMode := cdmVBD;
                {$If (not Defined(COMTK) and not Defined(EBAD))}
                oTTDCalculator.CalculateAD (oVBDOffer.DiscountVal, oVBDOffer.DiscountType);
                oTTDCalculator.ApplyTTD;  // Actually applying VBD
                {$Else} //PR: 20/05/2009 - Need to return a result for the COM Toolkit
                Result := oTTDCalculator.CalculateAD (oVBDOffer.DiscountVal, oVBDOffer.DiscountType);
                if Result then
                  oTTDCalculator.ApplyTTD;  // Actually applying VBD
                {$IfEnd}
              End // If Assigned (oVBDOffer)
            End; // If (Not oTTDCalculator.TTDExists)
          End; // If (oVBDList.DiscountCount > 0)
        End; // Else
      End; // If bOfferVBD

      SetOrigFields (ADTrans);
    Finally
      FreeAndNIL(oTTDCalculator);
      FreeAndNIL(oVBDList);
    End; // Try..Finally
  End // If FEnabled
  Else
    Result := False;
End; // ApplyDiscounts

//-------------------------------------------------------------------------

// Checks the transaction's costs, returns TRUE if transaction went below cost due
// to VBD, otherwise returns FALSE
Function TTTDTransactionHelper.CheckVBDCosts(Const ADTrans : InvRec) : Boolean;
Var
  oTTDCalculator : TTTDCalculator;
Begin // CheckVBDCosts
  Result := FALSE;
  Try
    oTTDCalculator := TTTDCalculator.Create(FTransactionMode = tmAdd, @ADTrans);
    oTTDCalculator.AllowSaleBelowCost := PChkAllowed_In(309);
    oTTDCalculator.AllowDiscountToExceedSale := PChkAllowed_In(310);

    If oTTDCalculator.VBDExists Then
    Begin
      // Return TRUE if the Net Total excluding VBD is > Total Cost
      Result := Round_Up(oTTDCalculator.TransTotals [ttBeforeNetTotal], 2) >= Round_Up(ADTrans.TotalCost, 2);
    End; // If oTTDCalculator.VBDExists
  Finally
    FreeAndNIL(oTTDCalculator);
  End; // Try..Finally
End; // CheckVBDCosts

//=========================================================================



end.


