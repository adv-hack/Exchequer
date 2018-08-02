Unit oOrderPaymentsRefundManager;

Interface

Uses Classes, SysUtils, StrUtils, GlobVar, VarConst, ExBTTh1U, OrderPaymentsInterfaces,
     oCreditCardGateway, oOPVATPayMemoryList, oOrderPaymentsSRC, ContactsManager,
     GmXML, oOrderPaymentsTransactionInfo, ExchequerPaymentGateway_TLB;

Type
  Str50 = String[50];

  // Note: Must map onto the item indexes in the drop-down list on the refund dialog
  TRefundManagerRefundType = (rtValueOnly=0, rtValueAndStock=1);

  TOrderPaymentsRefundManager = Class(TObject)
  Private
    FExLocal : TdPostExLocalPtr;

    FPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
    FPaymentTransaction : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
    FRefundType : TRefundManagerRefundType;
    FCreditCardAction : enumCreditCardAction;
    FRefundReason : Str50;

    FRefundSRC : IOrderPaymentsSRC;

    //PR: 08/10/2014 Store reference to created refund SRC
    FRefundSRCOurRef : string;

    // PKR 14/11/2014.  Added because the portal/payment providers need iet
    FAccount     : CustRec;
    FContact     : TAccountContact;

    // MH 30/06/2015 2015-R1 ABSEXCH-16625: Added Refund Date into Refund dialog
    FRefundDate : LongDate;

    Procedure SetPaymentInfo (Value : IOrderPaymentsTransactionPaymentInfo);
    Procedure SetPaymentTransaction (Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);

    Function CreateRefundSummary : TOrderPaymentsVATPayDetailsList;

    // Executes whatever Credit Card Operations are required
    //
    //   0    Success
    //
    Function ExecuteCreditCardOperation (Const RefundSummary : TOrderPaymentsVATPayDetailsList;
                                         const aProvider : string = '';
                                         const aMerchant : string = '') : Integer;


    // Adds the description lines for the Refund into OPVATPay.Dat
    //
    //  0           AOK
    //  1000-1999  Error opening OPVATPay.Dat
    //  2000-2999  Error inserting summary row
    //  3000-3999  Error inserting transaction line row
    //  4000-4999  Error inserting transaction Stock Description line row
    Function WriteRefundDetails (Const RefundRef : ShortString; Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;

    //Creates the negative SRC
    // PKR. 20/1/2015. Added credit card details.  May be nil.
    Function CreateSRC : Integer;

    function CreateCustomData(aRefundSummary : TOrderPaymentsVATPayDetailsList) : WideString;

  Public
    Property rmPaymentInfo : IOrderPaymentsTransactionPaymentInfo Read FPaymentInfo Write SetPaymentInfo;
    Property rmPaymentTransaction : IOrderPaymentsTransactionPaymentInfoPaymentHeader Read FPaymentTransaction Write SetPaymentTransaction;
    Property rmRefundType : TRefundManagerRefundType Read FRefundType Write FRefundType;
    Property rmCreditCardAction : enumCreditCardAction Read FCreditCardAction Write FCreditCardAction;
    Property rmRefundReason : Str50 Read FRefundReason Write FRefundReason;
    Property rmRefundSRCOurRef : string Read FRefundSRCOurRef;
    // PKR. 14/11/2014. Added for credit card refunds.
    Property rmAccount : CustRec Read FAccount Write FAccount;
    Property rmContact : TAccountContact Read FContact Write FContact;
    // MH 30/06/2015 2015-R1 ABSEXCH-16625: Added Refund Date into Refund dialog
    Property rmRefundDate : LongDate Read FRefundDate Write FRefundDate;

    Constructor Create (ExLocal : TdPostExLocalPtr);
    Destructor Destroy; Override;

    Function ExecuteRefund : Integer;
  End; // TOrderPaymentsRefundManager

Implementation

Uses oBtrieveFile, oOPVATPayBtrieveFile, ETDateU, ETMiscU, ETStrU, BtrvU2, Math, VarRec2U, Dialogs, Forms, BtKeys1U, Controls,
     {$IFDEF CU}Event1U,{$ENDIF} MathUtil, CurrncyU,
     // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
     oOPOrderAuditNotes,
     XMLFuncs;

//=========================================================================

Constructor TOrderPaymentsRefundManager.Create (ExLocal : TdPostExLocalPtr);
Begin // Create
  Inherited Create;

  FExLocal := ExLocal;

  FPaymentInfo := NIL;
  FPaymentTransaction := NIL;
  FRefundType := rtValueOnly;
  FCreditCardAction := ccaNoAction;
  FRefundReason := '';
  // MH 30/06/2015 2015-R1 ABSEXCH-16625: Added Refund Date into Refund dialog
  FRefundDate := Today;
End; // Create

Destructor TOrderPaymentsRefundManager.Destroy;
Begin // Destroy
  FPaymentInfo := NIL;
  FPaymentTransaction := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TOrderPaymentsRefundManager.SetPaymentInfo (Value : IOrderPaymentsTransactionPaymentInfo);
Begin // SetPaymentInfo
  FPaymentInfo := Value;
End; // SetPaymentInfo

//------------------------------

Procedure TOrderPaymentsRefundManager.SetPaymentTransaction (Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);
Begin // SetPaymentInfo
  FPaymentTransaction := Value;
End; // SetPaymentInfo

//-------------------------------------------------------------------------

// Generates a Refund against the payment (FPaymentInfo.Payment)
//
//   0      Success
//   999    Unknown Error
Function TOrderPaymentsRefundManager.ExecuteRefund : Integer;
Var
  oRefundSummary : TOrderPaymentsVATPayDetailsList;
  RefundSRCRef : ShortString;
  iStatus, Res : Integer;
  customData      : WideString;
  gatewayResponse : PaymentGatewayResponse;
  // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
  oAuditNotes  : IOPOrderAuditNotes;
Begin // ExecuteRefund
  Res := 999;
  FRefundSRCOurRef := ''; //PR: 08/10/2014

  gatewayResponse := nil;

  // Check there is a value to refund
  If (FPaymentTransaction.opphRefundValue > 0.0) Then
  Begin
    // Create a summary of the details to be written to OPVATPay if the Credit Card
    // and Refund operations succeed, this can then be used by the Credit Card operation
    // as well
    oRefundSummary := CreateRefundSummary;

    Try
      // Execute any required Credit Card operation

        //Open files for stock, location and FIFO
        FExLocal.Open_System(StockF, StockF);
        FExLocal.Open_System(MLocF, MLocF);
        FExLocal.Open_System(MiscF, MiscF);

        // Begin Database Transaction
        iStatus := FPaymentInfo.ExLocal.LCtrl_BTrans(1);  // Start Database Transaction

        // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
        oAuditNotes := NewOPOrderAuditNotes;

        // Create SRC to refund the value only.
        if iStatus = 0 then
          Res := CreateSRC
        else
          Res := 55000 + iStatus;

        // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
        If (Res = 0) Then
        Begin
          oAuditNotes.anOperation := antRefund;
          oAuditNotes.anOrderFolio := FPaymentInfo.oppiOrder.FolioNum;
          oAuditNotes.anOrderOurRef := FPaymentInfo.oppiOrder.OurRef;
          oAuditNotes.anTransactionOurRef := FPaymentTransaction.opphPayment.OurRef;
          oAuditNotes.anReceiptOurRef := FRefundSRC.OurRef;
          oAuditNotes.anReceiptValue := FPaymentTransaction.opphRefundValue;
          oAuditNotes.anReceiptCurrency := FRefundSRC.Currency;
        End; // If (Res = 0)

        if Res = 0 then
        begin
          RefundSRCRef := FRefundSRC.OurRef;
          FRefundSRCOurRef := RefundSRCRef; //PR: 08/10/2014

          // Insert OPVATPay details via emulator so it is included within the Database Transaction
          if Res = 0 then
            Res := WriteRefundDetails (RefundSRCRef, oRefundSummary);

          //PR: 03/02/2015 Moved credit card operations her

          if Res = 0 then
            Res := ExecuteCreditCardOperation (oRefundSummary);

          If (Res = 0) Then
          Begin
            // PKR. 20/01/2015.
            // If this was a credit-card refund, then get the result to store in the SRC.
            if FCreditCardAction <> ccaNoAction then
            begin

                // PKR. 10/02/2015. ABSEXCH-16108. The Portal doesn't send back the card details for refunds
                //  but we can get them from the original SRC.
//                FRefundSRC.CardType            := gatewayResponse.Get_GatewayVendorCardType;
//                FRefundSRC.CardNo              := gatewayResponse.Get_GatewayVendorCardLast4Digits;
//                FRefundSRC.CardExpiry          := gatewayResponse.Get_GatewayVendorCardExpiryDate;

                // Get the data from the original SRC.

              // PKR. 17/08/2015. ABSEXCH-16763. Credit Card Refund Not Populating Credit Card Fields on SRC Header
              // These fields updated even if gatewayResponse is nil.
                FRefundSRC.CardType   := FPaymentTransaction.opphCreditCardType;
                FRefundSRC.CardNo     := FPaymentTransaction.opphCreditCardNumber;
                FRefundSRC.CardExpiry := FPaymentTransaction.opphCreditCardExpiry;

              gatewayResponse := CreditCardPaymentGateway.GetPaymentResponse;
              if (gatewayResponse <> nil) then
              begin
                FRefundSRC.CardAuhorisationNo  := gatewayResponse.Get_AuthorizationNumber;
                FRefundSRC.CardReferenceNo     := gatewayResponse.Get_GatewayVendorTxCode;
              end;

                //PR: 30/01/2015 ABSEXCH-16102 Set action on RefundSRC object so it can set OP flags on SRC
                FRefundSRC.CreditCardAction    := FCreditCardAction;

                Res := FRefundSRC.Update;

              // PKR. 16/01/2015. Send an XML update back to the Exchequer Payment Portal
{$ifdef Enter1}
              Screen.Cursor := crHourGlass;
{$endif}
              // Create the CustomData XML for disaster recovery
              customData := CreateCustomData(oRefundSummary);

              // Send the CustomData and SRC reference to the Payment Portal
              CreditCardPaymentGateway.UpdateTransactionContent(FRefundSRC.CardReferenceNo, FRefundSRC.OurRef, customData);
{$ifdef Enter1}
              Screen.Cursor := crDefault;
{$endif}

              // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
              oAuditNotes.anCardAuthNo := FRefundSRC.CardAuhorisationNo;
            end; //FCreditCardAction <> ccaNoAction
          end; //Res = 0
        End; // If (Res = 0)

        // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
        If (Res = 0) Then
          // Pass the tdPostExLocal instance in so we can get the Audit Notes included within
          // the same Database transaction
          Res := oAuditNotes.WriteAudit (FPaymentInfo.ExLocal);
        oAuditNotes := NIL;

        // End Transaction - Commit or Cancel
        if Res = 0 then
          iStatus := FPaymentInfo.ExLocal.LCtrl_BTrans(0)  // End Database Transaction
        else
        begin
          iStatus := FPaymentInfo.ExLocal.LCtrl_BTrans(2);  // Abort Database Transaction
        end;

        {$IFDEF CU}
          If (iStatus = 0) Then
            // Fire the After Store Transaction hook point to notify plug-ins of the SRC's creation
            GenHooks (2000, 170, FPaymentInfo.ExLocal^);
        {$ENDIF CU}

        // PKR. 05/02/2015. This was overwriting the Res value returned from the Credit Card Add-in.
        // So if the credit card transaction was cancelled, for example, it was still returning 0 instead of 3
        if FCreditCardAction = ccaNoAction then
        begin
          If (iStatus = 0) Then
            Res := 0;
        end;
    Finally
      FreeAndNIL(oRefundSummary);
      FRefundSRC := nil;
    End; // Try..Finally
  End; // If (FPaymentHeaderInfo.FPaymentTransaction > 0.0)

  Result := Res;
End; // ExecuteRefund

//-------------------------------------------------------------------------

// Executes whatever Credit Card Operations are required
//
//   0    Success
//
Function TOrderPaymentsRefundManager.ExecuteCreditCardOperation (Const RefundSummary : TOrderPaymentsVATPayDetailsList;
                                                                 const aProvider : string = '';
                                                                 const aMerchant : string = '') : Integer;
var
  CreditCardTransGUID : string;
  RefundCurrency      : string;
Begin // ExecuteCreditCardOperation
  If (FCreditCardAction <> ccaNoAction) Then
  Begin
    CreditCardTransGUID := FPaymentTransaction.opphPayment.thCreditCardReferenceNo;

    RefundCurrency      := FPaymentInfo.optCurrencySymbol;

    // PKR. 06/02/2015. ABSEXCH-16140. Set handle of Exchequer window so that status dialog will
    //  display centrally.
    {$IFDEF Enter1}
    CreditCardPaymentGateway.SetOwnerHandle(Application.Mainform.Handle);
    {$ENDIF}

    Result := CreditCardPaymentGateway.MakeRefund(rmAccount,
                                                  rmContact,
                                                  FPaymentInfo.optTransaction,
                                                  CreditCardTransGUID,
                                                  RefundCurrency,
                                                  RefundSummary,
                                                  FRefundReason);
  End // If (FCreditCardAction <> ccaNoAction)
  Else
    // No action required - return successful status
    Result := 0;
End; // ExecuteCreditCardOperation


//-------------------------------------------------------------------------

Function TOrderPaymentsRefundManager.CreateRefundSummary : TOrderPaymentsVATPayDetailsList;
Var
  oMatchingRecs : TOrderPaymentsVATPayDetailsList;
  SummaryVATPayRec, MatchingVATPayRec, VATPayRec : OrderPaymentsVATPayDetailsRecType;
  PaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  sPreDesc, sSuffDesc : ShortString;
  LineCount, I : Integer;
Begin // CreateRefundSummary
  // Create the refund summary object
  Result := TOrderPaymentsVATPayDetailsList.Create;

  // For SINs build the matching information at the same time and then append to the end of the
  // list (so they are clustered together in theDB)
  If (FPaymentInfo.optTransaction.InvDocHed = SIN) Then
    oMatchingRecs := TOrderPaymentsVATPayDetailsList.Create
  Else
    oMatchingRecs := NIL;

  // Create Refund summary line ----------------------------------------------
  InitialiseVATPayRec(SummaryVATPayRec);
  With SummaryVATPayRec Do
  Begin
    // SOR OurRef - originating order that all Order Payment transactions originate from
    If (FPaymentInfo.optTransaction.InvDocHed = SOR) Then
      vpOrderRef := PadOrderRefKey (FPaymentInfo.optTransaction.OurRef)
    Else
      vpOrderRef := PadOrderRefKey (FPaymentInfo.optTransaction.thOrderPaymentOrderRef);

    // OurRef (SRC) of Refund transaction
    vpReceiptRef := PadReceiptRefKey ('');  // Not known at this point

    // OurRef of payment being refunded
    vpTransRef := PadTransRefKey (FPaymentTransaction.opphPayment.OurRef);

    // Line sequence within OPVATPAY
    vpLineOrderNo   := 1;

    // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN
    vpSORABSLineNo  := 0;

    // Operation type / purpose
    If (FPaymentInfo.optTransaction.InvDocHed = SOR) Then
      // Refund against an SOR
      vpType := vptSORValueRefund
    Else If (FPaymentInfo.optTransaction.InvDocHed = SIN) And (rmRefundType = rtValueOnly) Then
      // Value Refund against an SIN - generates -SRC
      vpType := vptSINValueRefund
    Else
      Raise Exception.Create ('TOrderPaymentsRefundManager.CreateRefundSummary: Unsupported Transaction Type (' + IntToStr(Ord(FPaymentInfo.optTransaction.InvDocHed)) + ')');

    // SOR Currency and therefore SDN/SIN/SRC currency
    vpCurrency := FPaymentInfo.optTransaction.Currency;

    // Text description of SOR line for printing VAT Receipts, e.g. £666.66 Part Payment against SORxxxxxx/SINxxxxxx
    vpDescription := FPaymentTransaction.opphCurrencySymbol + Form_Real(FPaymentTransaction.opphRefundValue,0,2) + ' ' +
                     IfThen (FPaymentTransaction.opphRefundValue = FPaymentTransaction.opphNetValue, 'Full', 'Part') + ' Refund against ' +
                     Trim(vpOrderRef) + '/' + Trim(vpTransRef);

    // Exchequer User at point row inserted
    vpUserName := EntryRec^.Login;
  End; // With SummaryVATPayRec
  Result.Add(SummaryVATPayRec);

  // Create Payment line details ----------------------------------------------
  LineCount := 2;
  For I := 0 To (FPaymentTransaction.opphPaymentLineCount - 1) Do
  Begin
    PaymentLineIntf := FPaymentTransaction.opphPaymentLines[I];
    If PaymentLineIntf.opplRefundSelected And (PaymentLineIntf.opplRefundValue <> 0.0) Then
    Begin
      // Add Line for Stock Code / Price ------------------
      InitialiseVATPayRec(VATPayRec);
      With VATPayRec Do
      Begin
        // Copy details in from summary line
        vpOrderRef := SummaryVATPayRec.vpOrderRef;
        vpReceiptRef := SummaryVATPayRec.vpReceiptRef;
        vpTransRef := SummaryVATPayRec.vpTransRef;
        vpType := SummaryVATPayRec.vpType;
        vpCurrency := SummaryVATPayRec.vpCurrency;
        vpUserName := SummaryVATPayRec.vpUserName;
        vpDateCreated := SummaryVATPayRec.vpDateCreated;  // Copy Date/Time in from 1st record
        vpTimeCreated := SummaryVATPayRec.vpTimeCreated;  // so they are all the same

        // Line sequence within OPVATPAY within this payment
        vpLineOrderNo := LineCount;
        LineCount := LineCount + 1;

        // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN
        vpSORABSLineNo := PaymentLineIntf.opplOrderLine.opolLine.ABSLineNo;

        If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '') Then
        Begin
          // Text description of SOR line for printing VAT Receipts, e.g. 10 x STUFF @ £100.00
          vpDescription := Form_Real (PaymentLineIntf.opplOrderLine.opolLine.Qty, 0, Syss.NoQtyDec) + ' x ' +
                           Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) + ' @ ' +
                           Form_Real (PaymentLineIntf.opplOrderLine.opolUnitPrice, 0, Syss.NoNetDec);
        End // If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '')
        Else
        Begin
          // Stock Code blank - Use the description instead - may need jiggery pokery to make it fit
          sPreDesc := Form_Real (PaymentLineIntf.opplOrderLine.opolLine.Qty, 0, Syss.NoQtyDec) + ' x ';
          sSuffDesc := ' @ ' + Form_Real (PaymentLineIntf.opplOrderLine.opolUnitPrice, 0, Syss.NoNetDec);
          vpDescription := sPreDesc + Copy(PaymentLineIntf.opplOrderLine.opolLine.Desc, 1, 50 - Length(sPreDesc) - Length(sSuffDesc))  + sSuffDesc;
        End; // Else

        // SOR Line VAT Code
        // CJS 2015-01-06 - ABSEXCH-15988 - VAT Code M omitted from Order Payment VAT Returns
        if (PaymentLineIntf.opplOrderLine.opolLine.VATIncFlg In VATSet) and
           (PaymentLineIntf.opplOrderLine.opolLine.VATCode In VATEqStd) then
          vpVATCode := PaymentLineIntf.opplOrderLine.opolLine.VATIncFlg
        else
          vpVATCode := PaymentLineIntf.opplOrderLine.opolLine.VATCode;

        // Goods Value paid/refunded
        vpGoodsValue := PaymentLineIntf.opplRefundGoods;
        // VAT Value paid/refunded
        vpVATValue := PaymentLineIntf.opplRefundVAT;
      End; // With VATPayRec
      Result.Add(VATPayRec);

      // Create Matching details for SINs -----------------
      If Assigned(oMatchingRecs) Then
      Begin
        // Put -ve line into matching against the SIN to indicate the refund
        MatchingVATPayRec := VATPayRec;
        MatchingVATPayRec.vpTransRef := PadTransRefKey(FPaymentInfo.optTransaction.OurRef);  // SIN
        MatchingVATPayRec.vpType := vptMatching;
        MatchingVATPayRec.vpGoodsValue := -MatchingVATPayRec.vpGoodsValue;
        MatchingVATPayRec.vpVATValue := -MatchingVATPayRec.vpVATValue;
        oMatchingRecs.Add(MatchingVATPayRec);
      End; // If Assigned(oMatchingRecs)

      // Add Line for Stock Description -------------------
      If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '') Then
      Begin
        InitialiseVATPayRec(VATPayRec);
        With VATPayRec Do
        Begin
          // Copy details in from summary line
          vpOrderRef := SummaryVATPayRec.vpOrderRef;
          vpReceiptRef := SummaryVATPayRec.vpReceiptRef;
          vpTransRef := SummaryVATPayRec.vpTransRef;
          vpType := SummaryVATPayRec.vpType;
          vpCurrency := SummaryVATPayRec.vpCurrency;
          vpUserName := SummaryVATPayRec.vpUserName;
          vpDateCreated := SummaryVATPayRec.vpDateCreated;  // Copy Date/Time in from 1st record
          vpTimeCreated := SummaryVATPayRec.vpTimeCreated;  // so they are all the same

          // Line sequence within OPVATPAY within this payment
          vpLineOrderNo := LineCount;
          LineCount := LineCount + 1;

          // Text description of SOR line for printing VAT Receipts, e.g. 10 x STUFF @ £100.00
          vpDescription := PaymentLineIntf.opplOrderLine.opolLine.Desc;
        End; // With VATPayBtrieveFile.VATPayDetails
        Result.Add(VATPayRec);
      End; // If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '')
    End; // If PaymentLineIntf.opplRefundSelected And (PaymentLineIntf.opplRefundValue <> 0.0)
  End; // For I

  // Append Matching details for SINs -----------------------
  If Assigned(oMatchingRecs) Then
  Begin
    For I := 0 To (oMatchingRecs.Count - 1) Do
      Result.Add(oMatchingRecs.Records[I]);
    FreeAndNIL(oMatchingRecs);
  End; // If Assigned(oMatchingRecs)
End; // CreateRefundSummary

//-------------------------------------------------------------------------

// Adds the description lines for the Refund into OPVATPay.Dat
//
//  0           AOK
//  1000-1999  Error opening OPVATPay.Dat
//  2000-2999  Error inserting row
//
Function TOrderPaymentsRefundManager.WriteRefundDetails (Const RefundRef : ShortString; Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;
Var
  VATPayBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;
  I, iStatus : Integer;
Begin // WriteRefundDetails
  Result := 0;    // AOK

  // Create a Btrieve File Object for OPVATPay.Dat using the same Client Id as the ExLocal instance we are using.
  VATPayBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.CreateWithClientId (oBtrieveFile.ClientIdType(FExLocal.ExClientId^));
  Try
    iStatus := VATPayBtrieveFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
    If (iStatus = 0) Then
    Begin
      For I := 0 To (RefundSummary.Count - 1) Do
      Begin
        VATPayBtrieveFile.InitialiseRecord;
        VATPayBtrieveFile.VATPayDetails := RefundSummary.Records[I];
        With VATPayBtrieveFile.VATPayDetails Do
          vpReceiptRef := PadReceiptRefKey(RefundRef);
        iStatus := VATPayBtrieveFile.Insert;
        If (iStatus <> 0) Then
          Result := 2000 + iStatus;
      End; // For I

      VATPayBtrieveFile.CloseFile(False);  // Don't reset the ClientId as that will screw up the ExLocal
    End // If (iStatus = 0)
    Else
      // Error opening OPVATPay.Dat
      Result := 1000 + iStatus;
  Finally
    VATPayBtrieveFile.Free;
  End; // Try..Finally
End; // WriteRefundDetails

//-------------------------------------------------------------------------
//Creates the negative SRC
Function TOrderPaymentsRefundManager.CreateSRC : Integer;
var
  Res : Integer;
  KeyS : Str255;

  function GetOrderPaymentElement(const DocType : DocTypes) : enumOrderPaymentElement;
  begin
    Result := opeInvoiceRefund;
    Case DocType of
       SIN : Result := opeInvoiceRefund;
       SOR : Result := opeOrderRefund;
    end; //case
  end;

begin
  Result := 0;
  // Create SRC
  FRefundSRC := NewOrderPaymentsSRC;

  //Set properties

  // MH 01/07/2015 2015-R1 ABSEXCH-16625: Added Refund Date to Refund dialog
  FRefundSRC.SRCTransDate := FRefundDate;

  //PR: 13/11/2014 ABSEXCH-15812
  FRefundSRC.Account := FPaymentTransaction.opphPayment.CustCode;
  FRefundSRC.Currency := FPaymentInfo.optTransaction.Currency;
  FRefundSRC.OriginalXRate := XRate(FPaymentInfo.optTransaction.CXRate, False, FRefundSRC.Currency);
  FRefundSRC.ControlGL := FPaymentInfo.optTransaction.CtrlNom;
  FRefundSRC.PaymentValue := FPaymentTransaction.opphRefundValue * -1;
  FRefundSRC.OPElement := GetOrderPaymentElement(FPaymentInfo.optTransaction.InvDocHed);

  // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy YourRef from SRC being Refunded into Refund SRC
  If (Trim(FPaymentTransaction.opphPayment.YourRef) <> '') Then
    FRefundSRC.YourRef := FPaymentTransaction.opphPayment.YourRef
  Else
    FRefundSRC.YourRef := FPaymentTransaction.opphPayment.OurRef;

  if FRefundSRC.OPElement = opeInvoiceRefund then
  begin
    //Refunding against invoice
    FRefundSRC.TransactionRef := FPaymentInfo.optTransaction.OurRef;
    FRefundSRC.OrderReference := FPaymentInfo.optTransaction.thOrderPaymentOrderRef;
    FRefundSRC.PaymentRef := FPaymentTransaction.opphPayment.OurRef;
    FRefundSRC.RemitNo := FPaymentTransaction.opphPayment.OurRef;   //PR: 06/10/2014 ABSEXCH-15710
  end
  else
  begin
    //Refunding against order - match against SRC
    FRefundSRC.TransactionRef := FPaymentTransaction.opphPayment.OurRef;
    FRefundSRC.OrderReference := FPaymentInfo.optTransaction.OurRef;
    FRefundSRC.RemitNo := FPaymentTransaction.opphPayment.OurRef;
  end;

  //Get Bank GL & CC/Dept from original SRC line
  FRefundSRC.ExLocal := FPaymentInfo.ExLocal;
  with FRefundSRC.ExLocal^ do
  begin
      //Find the transaction line for the payment - created automatically so only one line per SRC
      KeyS := FullNomKey(FPaymentTransaction.opphPayment.FolioNum);

      Res := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, KeyS);

      if (Res = 0) and (LId.FolioRef = FPaymentTransaction.opphPayment.FolioNum) then
      begin

          FRefundSRC.BankGL := LId.NomCode;
          fRefundSRC.CostCentre := LId.CCDep[True];
          FRefundSRC.Department := LId.CCDep[False];

      end // if (LId.FolioRef = FPaymentTransaction.opphPayment.FolioNum)
      else
        //Haven't found line for the payment we're refunding against
        Result := 999;

  end;


  //Store
  if Result = 0 then
    Result := FRefundSRC.Save;
end;

//------------------------------------------------------------------------------
function TOrderPaymentsRefundManager.CreateCustomData(aRefundSummary : TOrderPaymentsVATPayDetailsList) : WideString;
var
  XMLDoc          : TGmXML;
  rootNode        : TGmXMLNode;
  newNode         : TGmXMLNode;
  // PKR. 09/03/2015. ABSEXCH-16256. Incorrect data for XML customData.
  transLineIndex  : integer;
  transLine       : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  numTransLines   : integer;

  refundLineIndex : integer;
  refundLine      : OrderPaymentsVATPayDetailsRecType;
  numRefundLines  : integer;

  encodedText     : ShortString;
  location        : ShortString;
  stockCode       : ShortString;

  refGoodsVal     : double;
  refVatVal       : double;
begin
  Result := '';

  XMLDoc := TGmXML.Create(nil);
  try
    XMLDoc.IncludeHeader := false;

    // Add the PayData node
    rootNode := XMLDoc.Nodes.AddOpenTag('PayData');

    // Add the attributes
    // PKR. 28/09/2015. ABSEXCH-16655.  Incorrect our ref was same as this SRC's ref.
    rootNode.Attributes.AddAttribute('TransRef', self.FPaymentInfo.oppiOrder.OurRef); //  self.FRefundSRCOurRef);

    rootNode.Attributes.AddAttribute('Period', IntToStr(self.FPaymentInfo.optTransaction.AcPr));
    rootNode.Attributes.AddAttribute('Year', IntToStr(self.FPaymentInfo.optTransaction.AcYr));
    rootNode.Attributes.AddAttribute('GLCode', IntToStr(self.FRefundSRC.BankGL));

    // These will be blank if CCs/Depts not being used.
    rootNode.Attributes.AddAttribute('CC', self.FRefundSRC.CostCentre);
    rootNode.Attributes.AddAttribute('DP', self.FRefundSRC.Department);

    rootNode.Attributes.AddAttribute('PayRef', self.FRefundSRC.PaymentRef);

    // PKR. 15/09/2015. ABSEXCH-16344. Refunds not being recreated as expected
    // Incorrect XML data was going to the EPP.
    numTransLines := self.FPaymentTransaction.opphPaymentLineCount;

    numRefundLines := aRefundSummary.Count;
    if (numRefundLines > 0) then
    begin
      for refundLineIndex := 0 to numRefundLines-1 do
      begin
        refundLine := aRefundSummary.Records[refundLineIndex];

        // PKR. 16/10/2015. Filter out Matching records.
        if (refundLine.vpType <> vptMatching) then
        begin
          // Create a new XML child node
          newNode := rootNode.Children.AddLeaf('Line');

          // Add the attributes
          newNode.Attributes.AddAttribute('ABSNo', IntToStr(refundLine.vpSORABSLineNo)) ;

          // Find the corresponding line in the order so we can get the location
          // and Stock Code.
          location := '';
          stockCode := '';
          for transLineIndex := 0 to numTransLines-1 do
          begin
            // PKR. 09/03/2015. ABSEXCH-16256. Incorrect data for XML customData.
            transLine := self.FPaymentTransaction.opphPaymentLines[transLineIndex];

            if (transLine.opplOrderLine.opolLine.ABSLineNo = refundLine.vpSORABSLineNo) then
            begin
              // Found the corresponding line
              location := transLine.opplOrderLine.opolLine.MLocStk;
              stockCode := WebEncode(transLine.opplOrderLine.opolLine.StockCode);

              break;
            end;
          end;
          newNode.Attributes.AddAttribute('Loc', location);
          newNode.Attributes.AddAttribute('Stk', stockCode);

          // PKR. 10/04/2015. ABSEXCH-16104. Double quotes in stock codes and descriptions
          //  (eg when used for inches) are not surviving when they reach the C# code
          //  because " is the string delimiter.
          encodedText := WebEncode(Trim(refundLine.vpDescription));
          // PKR. 16/10/2015. Replace commas with spaces in the description so that it doesn't mess up the CSV.
          newNode.Attributes.AddAttribute('Desc', StringReplace(encodedText, ',', ' ', [rfReplaceAll]));

          newNode.Attributes.AddAttribute('VATCode', refundLine.vpVATCode);

          // PKR. 21/08/2015. ABSEXCH-16344. Part refunds not being recreated as expected.
          RefGoodsVal := refundLine.vpGoodsValue;
          RefVatVal   := refundLine.vpVATValue;

          // Format to 2 decimal places in an extra-wide field and then remove leading spaces.
          // PKR. 09/03/2015. ABSEXCH-16256. Incorrect data for XML customData.
          newNode.Attributes.AddAttribute('Goods', Trim(Format('%30.2F', [RefGoodsVal])));
          newNode.Attributes.AddAttribute('VAT',   Trim(Format('%30.2F', [RefVatVal])));
        end;
      end;
    end;

    //--------------------------------------------------------------------------
    // Close the Paydata node
    XMLDoc.Nodes.AddCloseTag; // </PayData>

    Result := XMLDoc.Text;
  finally
    XMLDoc.Free;
  end;
end;

End.


