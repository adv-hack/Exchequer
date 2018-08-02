Unit oOPPayment;

Interface

Uses SysUtils, StrUtils, Classes, oOrderPaymentsTransactionInfo, oCreditCardGateway,
     ContactsManager, Forms, Dialogs, GmXML;

Type
  enumOrderPaymentsPaymentType = (ptFull, ptPart);

  // Generic interface for objects which implement a specific import type
  IOrderPaymentsPayment = Interface
    ['{BE8A69D8-C5EC-4E26-ACBE-F71DCDF3B979}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOrderPaymentTransInfo : IOrderPaymentsTransactionInfo;
    Procedure SetOrderPaymentTransInfo (Value : IOrderPaymentsTransactionInfo);
    Function GetPaymentType : enumOrderPaymentsPaymentType;
    Procedure SetPaymentType (Value : enumOrderPaymentsPaymentType);
    Function GetPaymentValue : Double;
    Procedure SetPaymentValue (Value : Double);
    Function GetPaymentGLCode : LongInt;
    Procedure SetPaymentGLCode (Value : LongInt);
    Function GetPaymentReference : ShortString;
    Procedure SetPaymentReference (Value : ShortString);
    Function GetPrintVATReceipt : Boolean;
    Procedure SetPrintVATReceipt (Value : Boolean);
    Function GetCreditCardAction : enumCreditCardAction;
    Procedure SetCreditCardAction (Value : enumCreditCardAction);

    Function GetPaymentCostCentre : ShortString;
    Procedure SetPaymentCostCentre(const Value : ShortString);
    Function GetPaymentDepartment : ShortString;
    Procedure SetPaymentDepartment(const Value : ShortString);

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    Function GetSRCTransDate : ShortString;
    Procedure SetSRCTransDate(const Value : ShortString);

    // Set the contact details from the selected contact
    procedure SetContactDetails(aContact : TAccountContact);

    // ------------------ Public Properties ------------------
    Property oppOrderPaymentTransInfo : IOrderPaymentsTransactionInfo Read GetOrderPaymentTransInfo Write SetOrderPaymentTransInfo;
    Property oppPaymentType : enumOrderPaymentsPaymentType Read GetPaymentType Write SetPaymentType;
    Property oppPaymentValue : Double Read GetPaymentValue Write SetPaymentValue;
    Property oppPaymentGLCode : LongInt Read GetPaymentGLCode Write SetPaymentGLCode;
    Property oppPaymentReference : ShortString Read GetPaymentReference Write SetPaymentReference;
    Property oppPrintVATReceipt : Boolean Read GetPrintVATReceipt Write SetPrintVATReceipt;
    Property oppCreditCardAction : enumCreditCardAction Read GetCreditCardAction Write SetCreditCardAction;

    Property oppPaymentCostCentre : ShortString read GetPaymentCostCentre write SetPaymentCostCentre;
    Property oppPaymentDepartment : ShortString read GetPaymentDepartment write SetPaymentDepartment;

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    Property oppSRCTransDate : ShortString Read GetSRCTransDate Write SetSRCTransDate;

    //PR: 22/01/2015 OurRef, etc of SRC to create via disaster recovery
    {$IFDEF COMTK}
    Function GetSRCRef : ShortString;
    Procedure SetSRCRef(const Value : ShortString);

    Function GetSRCYear : Integer;
    Procedure SetSRCYear(const Value : Integer);

    Function GetSRCPeriod : Integer;
    Procedure SetSRCPeriod(const Value : Integer);

    Property oppSRCPeriod : Integer Read GetSRCPeriod Write SetSRCPeriod;
    Property oppSRCYear : Integer Read GetSRCYear Write SetSRCYear;
    Property oppSRCRef : ShortString Read GetSRCRef Write SetSRCRef;
    {$ENDIF}

    function GetProvider : Int64;
    procedure SetProvider(Value : Int64);

    function GetMerchantID : Int64;
    procedure SetMerchantID(Value : Int64);

    Property oppProvider : Int64 read GetProvider write SetProvider;
    Property oppMerchantID : Int64 read GetMerchantID write SetMerchantID;
    // ------------------- Public Methods --------------------
    // Creates a payment, executing any required Credit Card operations and creating subsequent
    // transactions, matching, notes, etc...
    Function CreatePayment : Integer;
  End; // IOrderPaymentsPayment

// Returns a new instance of the Order Payments' Payment object
Function NewOrderPayment : IOrderPaymentsPayment;

Implementation

Uses GlobVar, VarConst, BtrvU2, BTKeys1U, ETStrU, ETMiscU, oBtrieveFile, oOPVATPayBtrieveFile,
     oOrderPaymentsSRC, oOPVATPayMemoryList, ETDateU,
     {$IFDEF CU}Event1U, {$ENDIF} CurrncyU,
     // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
     oOPOrderAuditNotes,
     ExchequerPaymentGateway_TLB,
     Controls,
     SavePos,
     NoteSupU,
     BTSupU1,
     exbtth1u,
     XMLFuncs;

Type
  TOrderPaymentsPayment = Class(TInterfacedObject, IOrderPaymentsPayment)
  Private
    FOrderPaymentTransInfo : IOrderPaymentsTransactionInfo;
    FPaymentType : enumOrderPaymentsPaymentType;
    FPaymentValue : Double;
    FPaymentGLCode : LongInt;
    FPaymentReference : ShortString;
    FPrintVATReceipt : Boolean;
    FCreditCardAction : enumCreditCardAction;

    //Instance of SRC
    FPaymentSRC : IOrderPaymentsSRC;

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    FSRCTransDate : string;

    {$IFDEF COMTK}
    //PR: 22/01/2015 Creating SRC for disaster recovery
    FSRCRef       : string;
    FSRCYear      : Byte;
    FSRCPeriod    : Byte;
    {$ENDIF}

    FProvider : Int64;
    FMerchantID : Int64;

    FCostCentre : ShortString;
    FDepartment : ShortString;

    // Contact details
    FContactDetails : TAccountContact;

    Function CreateRefundSummary : TOrderPaymentsVATPayDetailsList;
    // Executes whatever Credit Card Operations are required
    Function ExecuteCreditCardOperation (Const RefundSummary : TOrderPaymentsVATPayDetailsList;
                                         Const aProvider : int64 = 0;
                                         Const aMerchant : int64 = 0) : Integer;
    // Adds the description lines into OPVATPay.Dat
    Function WritePaymentDetails (Const SRCRef : ShortString; Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;
    // Updates the thOrderPaymentFlags on the SOR to include the thopfPaymentTaken flag
    // PKR. 29/07/2015. ABSEXH-16683. Updated to optionally allow card details to be written to the SOR.
    Function UpdateOrderPaymentFlag(flag : integer;
                                    transGuid   : string = '';
                                    cardType    : string = '';
                                    last4Digits : string = '';
                                    expiryDate  : string = '';
                                    authNumber  : string = '') : Integer;

    // IOrderPaymentsPayment
    Function GetOrderPaymentTransInfo : IOrderPaymentsTransactionInfo;
    Procedure SetOrderPaymentTransInfo (Value : IOrderPaymentsTransactionInfo);
    Function GetPaymentType : enumOrderPaymentsPaymentType;
    Procedure SetPaymentType (Value : enumOrderPaymentsPaymentType);
    Function GetPaymentValue : Double;
    Procedure SetPaymentValue (Value : Double);
    Function GetPaymentGLCode : LongInt;
    Procedure SetPaymentGLCode (Value : LongInt);
    Function GetPaymentReference : ShortString;
    Procedure SetPaymentReference (Value : ShortString);
    Function GetPrintVATReceipt : Boolean;
    Procedure SetPrintVATReceipt (Value : Boolean);
    Function GetCreditCardAction : enumCreditCardAction;
    Procedure SetCreditCardAction (Value : enumCreditCardAction);
    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    Function GetSRCTransDate : ShortString;
    Procedure SetSRCTransDate(const Value : ShortString);

    //PR: 22/01/2015 OurRef of SRC to create via disaster recovery
    {$IFDEF COMTK}
    Function GetSRCRef : ShortString;
    Procedure SetSRCRef(const Value : ShortString);

    Function GetSRCYear : Integer;
    Procedure SetSRCYear(const Value : Integer);

    Function GetSRCPeriod : Integer;
    Procedure SetSRCPeriod(const Value : Integer);
    {$ENDIF}

    function GetProvider : Int64;
    procedure SetProvider(Value : Int64);

    function GetMerchantID : Int64;
    procedure SetMerchantID(Value : Int64);

    Function GetPaymentCostCentre : ShortString;
    Procedure SetPaymentCostCentre(const Value : ShortString);

    Function GetPaymentDepartment : ShortString;
    Procedure SetPaymentDepartment(const Value : ShortString);

    // Creates a payment, executing any required Credit Card operations and creating subsequent
    // transactions, matching, notes, etc...
    Function CreatePayment : Integer;
    // Run through the Transaction Lines and sets up details for a Full payment
    Procedure CalculateFullPayment;
    // Splits the payment value across the VAT Codes and Transaction Lines
    Procedure CalculatePaymentSplit;

    // Creates an XML string containing the transaction details to send back to the
    //  Payment Portal as CustomData
    function CreateCustomData : WideString;

    // Set the contact details from the selected contact
    procedure SetContactDetails(aContact : TAccountContact);

    function  TakeCardPayment(var gatewayResponse : PaymentGatewayResponse; oRefundSummary : TOrderPaymentsVATPayDetailsList) : integer;
    function LogPaymentError(gatewayResponse : PaymentGatewayResponse) : string;
    procedure AddWorkflowDiaryNote(aFilename : string);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TOrderPaymentsPayment

//=========================================================================

// Returns a new instance of the Order Payments' Payment object
Function NewOrderPayment : IOrderPaymentsPayment;
Begin // NewOrderPayment
  Result := TOrderPaymentsPayment.Create;
End; // NewOrderPayment

//=========================================================================

Constructor TOrderPaymentsPayment.Create;
Begin // Create
  Inherited Create;

  FOrderPaymentTransInfo := NIL;
  FPaymentType := ptFull;
  FPaymentValue := 0.0;
  FPaymentGLCode := 0;
  FPaymentReference := '';
  FPrintVATReceipt := False;
  // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
  FSRCTransDate := Today;
End; // Create

//------------------------------

Destructor TOrderPaymentsPayment.Destroy;
Begin // Destroy
  FOrderPaymentTransInfo := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------
// PKR. 16/07/2015. ABSEXCH-16425. Restructured to allow concurrent credit card payments
// New method added.
function TOrderPaymentsPayment.TakeCardPayment(var gatewayResponse : PaymentGatewayResponse;
                                               oRefundSummary : TOrderPaymentsVATPayDetailsList) : integer;
var
  GLCode       : integer;
  CostCentre   : string;
  Department   : string;
  theOrder     : invRec;
begin
  //PR: 02/02/2015 Credit card payment/refund/authorisation - moved from above so it isn't done
  //               unless the SRC will be added and matched correctly
  if (FCreditCardAction <> ccaNoAction) then
  begin
    theOrder := FOrderPaymentTransInfo.GetOrder;

    // PKR. 16/07/2015. ABSEXCH-16425. Restructured to allow concurrent credit card payments.
    // In Exchequer, the defaults were already obtained by the Payments Form, so they are
    // now passed in.  The COM Toolkit might still need to get them.

    {$IFDEF COMTK}
    //If we've already called ImportDefaults then we don't need to call GetPaymentDefaults again
    //Check by seeing if Provider and Merchant ID are set.
    if (FProvider = 0) or (FMerchantID = 0) then
    begin
      // Get the defaults
      CreditCardPaymentGateway.GetPaymentDefaults(GLCode, FProvider, FMerchantID,
                                                  CostCentre, Department,
                                                  theOrder.DocUser5, theOrder.DocUser6,
                                                  theOrder.DocUser7, theOrder.DocUser8,
                                                  theOrder.DocUser9, theOrder.DocUser10);
    end;
    {$ENDIF}

    // ExecuteCreditCardOperation returns:
    //  0 - Successful transaction. or no credit card action required
    //  1 - Pending
    //  2 - Not Authorised
    //  3 - Aborted
    //  4 - Rejected
    //  5 - Authenticated (for Authenticate Card with 3DSecure)
    //  6 - Registered    (for Authenticate Card with no 3DSecure)
    //  7 - Error

    // PKR. 16/07/2015. ABSEXCH-16425. Use passed-in values for Provider and MerchantID
    Result := ExecuteCreditCardOperation(oRefundSummary, FProvider, FMerchantID);

    // PKR. 21/07/2015. Changes made to Portal for Card Authentication.
    if (Result = 0) or
       ((FCreditCardAction = ccaRequestPaymentAuthorisation) and (Result = 6)) or // If 3DSecure not supported
       ((FCreditCardAction = ccaRequestPaymentAuthorisation) and (Result = 5))    // If 3DSecure supported
       then
    begin
      // Get the result that came back from the credit card payment transaction
      gatewayResponse := CreditCardPaymentGateway.GetPaymentResponse;

      // ABSEXCH-15933. PKR. 15/12/2014.  Moved within the test for credit card action
      if (gatewayResponse = nil) then
      begin
        if (FCreditCardAction = ccaRequestPaymentAuthorisation) then
        begin
          // Authorise Only - doesn't have a gatewayResponse, so it will always be nil
          // At present, we have to say it was successful as we don't get any true
          //  status from the Portal.
          Result := 0;
        end
        else
        begin
          // User must have cancelled at the portal, but before submitting, because we
          //  only get a gatewayResponse AFTER the payment has been submitted
          Result := Ord(gsiAbort);
        end
      end;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;


//-------------------------------------------------------------------------
// Creates a payment, executing any required Credit Card operations and creating subsequent
// transactions, matching, notes, etc...
//
// Return Values:-
//
//   0         Success
//   999       Unknown Error
Function TOrderPaymentsPayment.CreatePayment : Integer;
Var
  oRefundSummary : TOrderPaymentsVATPayDetailsList;
  iStatus, Res : Integer;
  udf5, udf6, udf7, udf8, udf9, udf10 : string;
  // XML data to be sent back to the Payment Portal for disaster recovery.
  CustomData   : WideString;
  // MH 29/06/2015 2015-R1 ABSEXCH-16615: Code wasn't setting the Credit Card Payment Taken flag
  ReqdFlag     : Integer;
  // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
  oAuditNotes  : IOPOrderAuditNotes;

  gatewayResponse : PaymentGatewayResponse;
  logFilename     : string;

  KeyS            : Str255;

  function GetOrderPaymentElement(const DocType : DocTypes) : enumOrderPaymentElement;
  begin
    Result := opeNA;
    Case DocType of
       SIN : Result := opeInvoicePayment;
       SOR : Result := opeOrderPayment;
       SDN : Result := opeDeliveryPayment;
    end; //case
  end;

Begin // CreatePayment
  Res := 999;

  If (FOrderPaymentTransInfo.optTransactionLineCount > 0) Then
  Begin
    // Allocate the Payment value across the transaction
    If (FPaymentType = ptFull) And (FPaymentValue = FOrderPaymentTransInfo.optTransactionTotal) And (Not FOrderPaymentTransInfo.optTransaction.ManVAT) Then
      // Full payment and NOT Manual VAT - use line values to reduce chance of rounding errors
      CalculateFullPayment
    Else
      // Part Payment or Manual VAT - pro-rata across the VAT Codes and Lines
      CalculatePaymentSplit;

    // Create a summary of the details to be written to OPVATPay if the Credit Card
    // and Refund operations succeed, this can then be used by the Credit Card operation
    // as well
    oRefundSummary := CreateRefundSummary;
    Try
      if (FCreditCardAction <> ccaNoAction) then
      begin
        // Credit card payment
        Res := TakeCardPayment(gatewayResponse, oRefundSummary);
      end
      else
      begin
        // Not a credit card payment
        Res := 0;
      end;

      if Res = 0 then
      begin
        // Begin Database Transaction
        iStatus := FOrderPaymentTransInfo.ExLocal.LCtrl_BTrans(1);  // Start Database Transaction
        if iStatus = 0 then
        begin
          // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
          oAuditNotes := NewOPOrderAuditNotes;

          Try
            // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
            oAuditNotes.anOrderFolio := FOrderPaymentTransInfo.optOrder.FolioNum;
            oAuditNotes.anOrderOurRef := FOrderPaymentTransInfo.optOrder.OurRef;
            oAuditNotes.anTransactionOurRef := FOrderPaymentTransInfo.optTransaction.OurRef;
            oAuditNotes.anReceiptValue := FPaymentValue;
            oAuditNotes.anReceiptCurrency := FOrderPaymentTransInfo.optCurrency;

            if (FCreditCardAction <> ccaRequestPaymentAuthorisation) then
            begin
              // Create SRC
              FPaymentSRC := NewOrderPaymentsSRC;

              FPaymentSRC.Currency := FOrderPaymentTransInfo.optCurrency;
              FPaymentSRC.OriginalXRate := XRate(FOrderPaymentTransInfo.optTransaction.CXRate, False, FPaymentSRC.Currency);
              FPaymentSRC.ControlGL := FOrderPaymentTransInfo.optTransaction.CtrlNom;
              FPaymentSRC.PaymentValue := FPaymentValue;
              FPaymentSRC.BankGL :=  FPaymentGLCode;
              FPaymentSRC.PayInRef := FPaymentReference;
              FPayMentSRC.OPElement := GetOrderPaymentElement(FOrderPaymentTransInfo.optTransaction.InvDocHed);

              // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
              FPaymentSRC.SRCTransDate := FSRCTransDate;

              // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
              If (Trim(FOrderPaymentTransInfo.optOrder.YourRef) <> '') Then
                FPaymentSRC.YourRef := FOrderPaymentTransInfo.optOrder.YourRef
              Else
                FPaymentSRC.YourRef := FOrderPaymentTransInfo.optOrder.OurRef;

              //PR: 22/01/2015 Set SRC ref for disaster recovery if needed
              {$IFDEF COMTK}
              if Trim(FSRCRef) <> '' then
              begin
                FPaymentSRC.SRCRef := FSRCRef;
                FPaymentSRC.SRCPeriod := FSRCPeriod;
                FPaymentSRC.SRCYear := FSRCYear;
              end;
              {$ENDIF}

              //PR: 13/11/2014 ABSEXCH-15812 If InvoiceTo is populated on the customer for a SOR/SDN then that's where the SRC needs to go
              if (FPayMentSRC.OPElement in [opeOrderPayment, opeDeliveryPayment]) and (Trim(FOrderPaymentTransInfo.optAccount.SOPInvCode) <> '') then
                FPaymentSRC.Account := FOrderPaymentTransInfo.optAccount.SOPInvCode
              else
                FPaymentSRC.Account := FOrderPaymentTransInfo.optAccount.CustCode;

              FPaymentSRC.CostCentre := FCostCentre;
              FPaymentSRC.Department := FDepartment;
              if FPaymentSRC.OPElement in [opeInvoicePayment, opeDeliveryPayment] then
              begin
                FPaymentSRC.TransactionRef := FOrderPaymentTransInfo.optTransaction.OurRef;
                FPaymentSRC.OrderReference := FOrderPaymentTransInfo.optTransaction.thOrderPaymentOrderRef;
              end
              else
              begin
                FPaymentSRC.TransactionRef := FOrderPaymentTransInfo.optTransaction.OurRef;
                FPaymentSRC.OrderReference := FOrderPaymentTransInfo.optTransaction.OurRef;
              end;

              FPaymentSRC.ExLocal := FOrderPaymentTransInfo.ExLocal;

              FPaymentSRC.VATPayList := oRefundSummary;

              //Store
              Res := FPaymentSRC.Save;

              // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
              If (Res = 0) Then
              Begin
                oAuditNotes.anOperation := antPayment;
                oAuditNotes.anReceiptOurRef := FPaymentSRC.OurRef;
              End; // If (Res = 0)

              if (Res = 0) then
              begin
                // Insert OPVATPay details via emulator so it is included within the Database Transaction
                Res := WritePaymentDetails (FPaymentSRC.OurRef, oRefundSummary);
              end;

              // MH 29/06/2015 2015-R1 ABSEXCH-ABSEXCH-16615: Code wasn't setting the Credit Card Payment Taken flag
              If (FCreditCardAction In [ccaRequestPayment, ccaRequestPaymentUsingExistingAuth]) Then
                ReqdFlag := thopfCreditCardPaymentTaken
              Else
                ReqdFlag := thopfPaymentTaken;

              // MH 29/09/2014 ABSEXCH-15682: Set Payment flag on SOR if not already set
              If (Res = 0) and
                 (   //PR: 27/01/2015 ABSEXCH-15964 Also need to set fixed flag for SORs which have payments taken.
                     //                             Do that in UpdateOrderPaymentFlag which is already updating SOR header.
                     // MH 29/06/2015 2015-R1 ABSEXCH-ABSEXCH-16615: Code wasn't setting the Credit Card Payment Taken flag
                    ((FOrderPaymentTransInfo.optOrder.thOrderPaymentFlags And ReqdFlag) <> ReqdFlag) or
                    ((FOrderPaymentTransInfo.optOrder.InvDocHed = SOR) and (not FOrderPaymentTransInfo.optOrder.SOPKeepRate))
                 ) Then
                //   0       AOK
                //   51000+  Error reading SOR
                //   52000+  Error restoring position
                //   53000+  Error updating SOR
                // MH 29/06/2015 2015-R1 ABSEXCH-ABSEXCH-16615: Code wasn't setting the Credit Card Payment Taken flag
                Res := UpdateOrderPaymentFlag(ReqdFlag);
            end  //((FCreditCardAction <> ccaRequestPaymentAuthorisation)
            else
            begin
              // FCreditCardAction = ccaRequestPaymentAuthorisation
              // (Card Authentication)
              Res := 0;

              // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
              oAuditNotes.anOperation := antAuthorisation;
            End; // Else
          Finally
            if (Res = 0) then
            begin
              // ccaRequestPaymentAuthorisation now means Card Authenticaiion.
              if (FCreditCardAction <> ccaNoAction) and (FCreditCardAction <> ccaRequestPaymentAuthorisation) then
              begin
                // Store the results of the credit card transaction
                // PKR. 29/07/2015. ABSEXCH16683. Card details not received from a Payment Authorisation.
                if (FCreditCardAction = ccaRequestPaymentUsingExistingAuth) then
                begin
                  // PKR. 29/07/2015. ABSEXCH-16683. Card Authentication/Authorise.
                  // Card Authentication returns these details, so they are stored on the order.
                  // For a Payment Authorisation using an existing Card Authentication, we don't receive
                  // these fields, so we copy them from the order instead.
                  FPaymentSRC.CardType            := FOrderPaymentTransInfo.optTransaction.thCreditCardType;
                  FPaymentSRC.CardNo              := FOrderPaymentTransInfo.optTransaction.thCreditCardNumber;
                  FPaymentSRC.CardExpiry          := FOrderPaymentTransInfo.optTransaction.thCreditCardExpiry;
                end
                else
                begin
                  FPaymentSRC.CardType            := gatewayResponse.Get_GatewayVendorCardType;
                  FPaymentSRC.CardNo              := gatewayResponse.Get_GatewayVendorCardLast4Digits;
                  FPaymentSRC.CardExpiry          := gatewayResponse.Get_GatewayVendorCardExpiryDate;
                end;

                // PKR. 29/07/2015. ABSEXCH-16710 Card Authorisation Number and Reference Number not
                // being populated correctly for Payment Authorisations.
                // These two fields come back from the Portal for ALL Payment types
                FPaymentSRC.CardAuhorisationNo  := gatewayResponse.Get_AuthorizationNumber;
                FPaymentSRC.CardReferenceNo     := gatewayResponse.Get_GatewayVendorTxCode; // Transaction GUID

                //PR: 30/01/2015 ABSEXCH-16102 Set action on PaymentSRC object so it can set OP flags on SRC
                FPaymentSRC.CreditCardAction    := FCreditCardAction;

                Res := FPaymentSRC.Update;
  {$ifdef Enter1}
                Screen.Cursor := crHourGlass;
  {$endif}
                // Create the CustomData XML for disaster recovery
                CustomData := CreateCustomData;

                // Send the CustomData and SRC reference to the Payment Portal
                CreditCardPaymentGateway.UpdateTransactionContent(FPaymentSRC.CardReferenceNo, FPaymentSRC.OurRef, CustomData);
  {$ifdef Enter1}
                Screen.Cursor := crDefault;
  {$endif}
                // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
                oAuditNotes.anCardAuthNo := FPaymentSRC.CardAuhorisationNo;
              end;
            end; // Res = 0

            // MH 02/07/2015 2015-R1 ABSEXCH-16508: Add SRC details into SOR Audit Notes
            If (Res = 0) Then
              // Pass the tdPostExLocal instance in so we can get the Audit Notes included within
              // the same Database transaction
              Res := oAuditNotes.WriteAudit (FOrderPaymentTransInfo.ExLocal);
            oAuditNotes := NIL;

            //End database transaction
            if Res = 0 then
            begin
              iStatus := FOrderPaymentTransInfo.ExLocal.LCtrl_BTrans(0)   // Commit Database Transaction
            end
            else
            begin
              iStatus := FOrderPaymentTransInfo.ExLocal.LCtrl_BTrans(2);  // Abort Database Transaction

              // Aborted transaction, so log it and write an entry to the Workflow Diary
              // PKR. 17/07/2015. ABSEXCH-16425.  Concurrent payments
              logFilename := LogPaymentError(gatewayResponse);
              AddWorkflowDiaryNote(logFilename);
  {$ifdef Enter1}
              MessageDlg('An error occurred taking the payment.'#13#10#13#10 +
                         'Please see the detailed report in the log file'#13#10 +
                         logFileName, mtError, [mbOk], 0);
  {$endif}
            end;

            //Destroy SRC object
            FPaymentSRC := nil;
          End;
        end; // if iStatus = 0
      end; // If Res = 0

      {$IFDEF CU}
      If (Res = 0) and (FCreditCardAction <> ccaRequestPaymentAuthorisation) Then
        // Fire the After Store Transaction hook point to notify plug-ins of the SRC's creation
        GenHooks (2000, 170, FOrderPaymentTransInfo.ExLocal^);
      {$ENDIF CU}

      // Card Authentication
      // We need to set the thopCreditCardAuthorisationTaken bit in thOrderPaymentFlags
      //  on the original transaction
      if ((Res = 6) or (Res = 5)) and (FCreditCardAction = ccaRequestPaymentAuthorisation) then
      begin
        // PKR. 29/07/2015. ABSEXCH-16683. Implement Card Authentication.
        // UpdateOrderPaymentFlag has been extended to take 5 optional parameters, which are
        // the card details returned from the Payment Provider/EPP.
        Res := UpdateOrderPaymentFlag(thopfCreditCardAuthorisationTaken,
                                      gatewayResponse.Get_GatewayVendorTxCode,
                                      gatewayResponse.GatewayVendorCardType,
                                      gatewayResponse.GatewayVendorCardLast4Digits,
                                      gatewayResponse.GatewayVendorCardExpiryDate,
                                      gatewayResponse.AuthorizationNumber);
      end;
    Finally
      FreeAndNIL(oRefundSummary);
      FPaymentSRC := nil;
    End; // Try..Finally
  End; // If (FOrderPaymentTransInfo.optTransactionLineCount > 0)

  Result := Res;
End; // CreatePayment

//------------------------------
// Writes an error log file to the <Exchequer>\LOGS directory.
// Filename is PaymentError_YYYYMMDD_HHMMSSZZZ.log
// PKR. 17/07/2015. ABSEXCH-16425.  Concurrent payments
function TOrderPaymentsPayment.LogPaymentError(gatewayResponse : PaymentGatewayResponse) : string;
var
  logFileName : string;
  timeStamp   : string;
  logFilePath : string;
  logNarrative : TStringList;
begin
  timeStamp    := FormatDateTime('yyyymmdd_hhnnsszzz', Now);
  logFileName  := 'PaymentError_' + timeStamp + '.log';
  logFilePath  := ExtractFilePath(Application.ExeName) + 'LOGS\';
  logNarrative := TStringList.Create;

  logNarrative.Add('Program. Version : ' + Ver);
  logNarrative.Add(ParamStr(0));
  logNarrative.Add(Format('%s. User : %s Company : ', [DateTimeToStr(Now), EntryRec^.Login, Syss.UserName]));
  logNarrative.Add(ConstStr('-', 80));
  logNarrative.Add('An error occurred creating the SRC for order ' + FPaymentSRC.OrderReference);
  logNarrative.Add('Account       : ' + FPaymentSRC.Account);
  logNarrative.Add('Payment value : ' + Format('%-10.2f', [FPaymentSRC.PaymentValue]));
  // If it was a credit card payment, give the details
  if (FCreditCardAction <> ccaNoAction) then
  begin
    if (gatewayResponse <> nil) then
    begin
      // A credit card payment was successfully made, so tell the user
      logNarrative.Add('A credit card payment was successfully taken for this payment :');
      logNarrative.Add('Card Type     : ' + gatewayResponse.Get_GatewayVendorCardType);
      logNarrative.Add('Card No.      : **** **** **** ' + gatewayResponse.Get_GatewayVendorCardLast4Digits);
      logNarrative.Add('Card Expiry   : ' + gatewayResponse.Get_GatewayVendorCardExpiryDate);
      logNarrative.Add('Card auth no. : ' + gatewayResponse.Get_AuthorizationNumber);
      logNarrative.Add('Card ref. no. : ' + gatewayResponse.Get_GatewayVendorTxCode);
    end;
  end;
  logNarrative.Add('');

  // Save the log
  logNarrative.SaveToFile(logFilePath + logFileName);
  
  Result := logFilePath + logFileName;
end;

//------------------------------
// PKR. 17/07/2015. ABSEXCH-16425.  Concurrent payments
Procedure TOrderPaymentsPayment.AddWorkflowDiaryNote(aFilename : string);
Var
  NotesSavePos : TBtrieveSavePosition;
  KeyS : Str255;
  iStatus : SmallInt;
Begin
  // Create some file save position objects
  NotesSavePos := TBtrieveSavePosition.Create;

  try
    // Save the notes file position
    NotesSavePos.SaveFilePosition (PwrdF, GetPosKey);
    NotesSavePos.SaveDataBlock (@Password, SizeOf(Password));

    // Get the transaction so we can add a new note, but don't wait for a lock
    KeyS := FullOurRefKey(FOrderPaymentTransInfo.GetOrder.OurRef);
    iStatus := FOrderPaymentTransInfo.ExLocal.LFind_Rec(B_GetEq+B_MultNWLock, InvF, InvOurRefK, KeyS);

    // If we got the record...
    if (iStatus = 0) Then
    begin
      // Get file position
      FOrderPaymentTransInfo.ExLocal.LGetRecAddr(InvF);

      // Increment the line count
      FOrderPaymentTransInfo.ExLocal.LInv.NLineCount := FOrderPaymentTransInfo.ExLocal.LInv.NLineCount + 1;

      // Update the record
      iStatus := FOrderPaymentTransInfo.ExLocal.LPut_Rec(InvF, InvOurRefK);

      // Unlock the record
      iStatus := FOrderPaymentTransInfo.ExLocal.LUnLockMLock(InvF);

      if iStatus = 0 then
      begin
        // Add the note
        FillChar(Password, SizeOf(Password), #0);

        Password.RecPFix := NoteTCode;
        Password.SubType := NoteCCode;

        With Password.NotesRec Do
        Begin
          LineNo := FOrderPaymentTransInfo.ExLocal.LInv.NLineCount - 1;
          NoteFolio := FullNomKey(FOrderPaymentTransInfo.GetOrder.FolioNum);
          NType := NoteCDCode;
          NoteDate:=Today;
          NoteAlarm := Today;
          NoteUser  := EntryRec^.Login;
          ShowDate  := True;
          NoteLine  := 'An error occured taking a payment for an order. For details, please refer to the log file ' + aFilename;

          NoteNo := FullRNoteKey(NoteFolio, NType, LineNo);
        End; // With Password.NotesRec

        iStatus := Add_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWk);
        Report_BError(PwrdF, iStatus);
      end; // If iStatus = 0
    end; // If iStatus = 0
    // Restore file positions
    NotesSavePos.RestoreDataBlock (@Password);
    NotesSavePos.RestoreSavedPosition;
  finally
    // Clean up
    NotesSavePos.Free;
  end; // try...finally
End; // AddWorkflowDiaryNote

//------------------------------
// Run through the Transaction Lines and sets up details for a Full payment
Procedure TOrderPaymentsPayment.CalculateFullPayment;
Var
  I : Integer;
Begin // CalculateFullPayment
  For I := 0 To (FOrderPaymentTransInfo.optTransactionLineCount - 1) Do
  Begin
    With FOrderPaymentTransInfo.optTransactionLines[I] Do
    Begin
      optlCurrentPaymentTotal := optlOutstandingTotal;
    End; // With FOrderPaymentTransInfo.optTransactionLines[I]
  End; // For I
End; // CalculateFullPayment

//------------------------------

// Splits the payment value across the VAT Codes and Transaction Lines
Procedure TOrderPaymentsPayment.CalculatePaymentSplit;
Var
  CurrentVATCode, CurrentLine, VATCodeCount : Integer;
  PaymentForThisVATCode, TotalPaymentAllocated, TotalVATCodePaymentAllocated : Double;
  oLine : IOrderPaymentsTransactionLineInfo;
  IVAT : VATType;
  ILine : Integer;
Begin // CalculatePaymentSplit
  // Count the number of VAT Codes in use on the transaction - this then allows us
  // to allocate whatever value remains to the last VAT Code
  VATCodeCount := 0;
  For IVAT := Low(VATType) To High(VATType) Do
  Begin
    If (FOrderPaymentTransInfo.optOutstandingTotalByVATCode[IVAT] <> 0.0) Then
      VATCodeCount := VATCodeCount + 1;
  End; // For IVAT

  If (VATCodeCount > 0) Then
  Begin
    // Run through the VAT Codes used on the transaction and pro-rata the payment value
    // across the Goods + VAT totals by VAT Code as when using Manual VAT they might not
    // match up with the line totals
    CurrentVATCode := 0;
    TotalPaymentAllocated := 0.0;
    For IVAT := Low(VATType) To High(VATType) Do
    Begin
      // Check there is an outstanding value for this VAT Code and there are transaction lines
      If (FOrderPaymentTransInfo.optOutstandingTotalByVATCode[IVAT] <> 0.0) And (FOrderPaymentTransInfo.optLineCountByVATCode[IVAT] > 0) Then
      Begin
        CurrentVATCode := CurrentVATCode + 1;

        // Check to see if it is the last VAT Code
        If (CurrentVATCode = VATCodeCount) Then
          // Last VAT Code - mop up whatever value is remaining
          PaymentForThisVATCode := Round_Up(FPaymentValue - TotalPaymentAllocated, 2)
        Else
          // Pro-rata the full payment value based on the outstanding value for this VAT code versus the total oustanding
          PaymentForThisVATCode := Round_Up((FOrderPaymentTransInfo.optOutstandingTotalByVATCode[IVAT] / FOrderPaymentTransInfo.optOutstandingTotal) * FPaymentValue, 2);
        TotalPaymentAllocated := TotalPaymentAllocated + PaymentForThisVATCode;

        // Run through the Transaction Lines for the current VAT Code and pro-rata the
        // calculated Payment Value for this VAT Code across the lines, allocate whatever
        // remains the the last line for the VAT Code
        CurrentLine := 0;
        TotalVATCodePaymentAllocated := 0.0;
        For ILine := 0 To (FOrderPaymentTransInfo.optTransactionLineCount - 1) Do
        Begin
          // Get a reference to the line and check the VAT Code matches the VAT Code we are currently allocating
          oLine := FOrderPaymentTransInfo.optTransactionLines[ILine];
          If (oLine.optlVATType = IVAT) Then
          Begin
            CurrentLine := CurrentLine + 1;

            // Check to see if it is the last line for the VAT Code
            If (CurrentLine = FOrderPaymentTransInfo.optLineCountByVATCode[IVAT]) Then
              // Last line - mop up whatever value is remaining
              oLine.optlCurrentPaymentTotal := PaymentForThisVATCode - TotalVATCodePaymentAllocated
            Else
              // Pro-rata the Payment for this VAT Code value based on the outstanding value for this line versus the total oustanding for the VAT Code
              //oLine.optlCurrentPaymentTotal := Round_Up((oLine.optlOutstandingTotal / FOrderPaymentTransInfo.optOutstandingTotalByVATCode[IVAT]) * PaymentForThisVATCode, 2);
              // MH 08/11/2015 2015-R1 ABSEXCH-16751: Pro-Rata not taking into account Write-Offs
              oLine.optlCurrentPaymentTotal := Round_Up(((oLine.optlOutstandingTotal - oLine.optlWriteOffTotal) / FOrderPaymentTransInfo.optOutstandingTotalByVATCode[IVAT]) * PaymentForThisVATCode, 2);
            TotalVATCodePaymentAllocated := TotalVATCodePaymentAllocated + oLine.optlCurrentPaymentTotal;
          End; // If (oLine.optlVATType = IVAT)
          oLine := NIL;
        End; // For ILine
      End; // If (FOrderPaymentTransInfo.optOutstandingTotalByVATCode[IVAT] <> 0.0) And (FOrderPaymentTransInfo.optLineCountByVATCode[IVAT] > 0)
    End; // For IVAT
  End // If (VATCodeCount > 0)
  Else
    // Shouldn't ever happen - you can't pay a zero value transaction
    Raise Exception.Create ('TOrderPaymentsPayment.CalculatePaymentSplit: No Goods/VAT Found');
End; // CalculatePaymentSplit

//------------------------------------------------------------------------------

// Updates the thOrderPaymentFlags on the SOR to include the thopfPaymentTaken flag
//
//   0       AOK
//   51000+  Error reading SOR
//   52000+  Error restoring position
//   53000+  Error updating SOR
// PKR. 17/12/2014. Now takes a parameter for the flag to set.
// flag should be one of:
//     thopfPaymentTaken
//     thopfCreditCardAuthorisationTaken
//     thopfCreditCardPaymentTaken
// PKR. 24/07/2015. Added additional parameter with default empty value to allow the
// Credit Card Transaction GUID to be stored.  Can be used to set onlu the GUID by
// specifying 0 for flag.
Function TOrderPaymentsPayment.UpdateOrderPaymentFlag(flag : integer;
                                                      transGuid   : string = '';
                                                      cardType    : string = '';
                                                      last4Digits : string = '';
                                                      expiryDate  : string = '';
                                                      authNumber  : string = '') : Integer;
Var
  SavedPos : LongInt;
  Res : Integer;
Begin // UpdateOrderPaymentFlag
  Result := 0;

  With FOrderPaymentTransInfo.ExLocal^ Do
  Begin
    // Store current position for restore
    LGetRecAddr(InvF);
    SavedPos := LastRecAddr[InvF];

    // Position on locked SOR
    LastRecAddr[InvF] := FOrderPaymentTransInfo.optOrderLockPos;
    Res := LGetDirectRec(InvF, InvOurRefK);
    If (Res = 0) Then
    Begin
      // Update the Flag
      //
      LInv.thOrderPaymentFlags := LInv.thOrderPaymentFlags Or flag; // was thopfPaymentTaken;

      //PR: 27/01/2015 ABSEXCH-15964 Once payments have been taken on a SOR Fixed rate must be set.
      // MH 01/07/2015 2015-R1 ABSEXCH-16623: Added check for Credit Card Payments
      if (LInv.InvDocHed = SOR) and ((flag = thopfPaymentTaken) Or (Flag = thopfCreditCardPaymentTaken)) then
      begin
        LInv.SOPKeepRate := True;

        //PR: 30/07/2015 ABSEXCH-16388 2015 R1 If paid in full and order is on credit hold then remove hold.
        //                                     Can't use SetHold procedure as we're in a database transaction at this point.
        if (FPaymentType = ptFull) and ((LInv.HoldFlg and 7) = HoldC) then
          LInv.HoldFlg := LInv.HoldFlg and (HoldSuspend+HoldNotes);

      end;

      // PKR. 24/07/2015.  ABSEXCH-16683. Update the order with the card details.
      // This is used for Authenticate Card.
      if (transGuid   <> '') then
        LInv.thCreditCardReferenceNo := transGuid;
      if (cardType    <> '') then
        Linv.thCreditCardType := cardType;
      if (last4Digits <> '') then
        Linv.thCreditCardNumber := last4Digits;
      if (expiryDate  <> '') then
        Linv.thCreditCardExpiry := expiryDate;
      if (authNumber  <> '') then
        Linv.thCreditCardAuthorisationNo := authNumber;

      Res := LPut_Rec(InvF, 0);
      If (Res <> 0) Then
        // Error updating SOR
        Result := 53000 + Res;
    End // If (Res = 0)
    Else
      // Error reading SOR
      Result := 51000 + Res;

    // Restore original position / record (should be the SRC)
    LastRecAddr[InvF] := SavedPos;
    Res := LGetDirectRec(InvF, 0);  // Idx 0 used for insert of SRC
    If (Res <> 0) And (Result = 0) Then
      // Error restoring position
      Result := 52000 + Res;
  End; // With FOrderPaymentTransInfo.ExLocal^
End; // UpdateOrderPaymentFlag

//------------------------------

// Executes whatever Credit Card Operations are required
//
//   0    Success
//
Function TOrderPaymentsPayment.ExecuteCreditCardOperation (Const RefundSummary : TOrderPaymentsVATPayDetailsList;
                                                           Const aProvider : int64 = 0;
                                                           Const aMerchant : int64 = 0) : Integer;
var
  paymentDetails : TCCPaymentDetails;
  GLCode : integer;
  Provider : string;
  MerchantID : string;
  CostCentre : string;
  Department : string;

Begin // ExecuteCreditCardOperation
  If (FCreditCardAction <> ccaNoAction) Then
  Begin
    paymentDetails.FullPayment      := FPaymentType = ptFull;
    paymentDetails.PaymentValue     := FPaymentValue;
    paymentDetails.PaymentReference := FPaymentReference;
    paymentDetails.CreditCardAction := FCreditCardAction;

    // We need to pass in the default PaymentProviderID and MerchantID to put in the ShoppingBasket object, or the UDFs 5..10 so we can derive them.
    // But we don't have those details at this point, so they need to be passed in to here.
    {$IFDEF Enter1}
    CreditCardPaymentGateway.SetOwnerHandle(Application.Mainform.Handle);
    {$ENDIF}

    Result := CreditCardPaymentGateway.MakePayment(RefundSummary,
                                                   FOrderPaymentTransInfo,
                                                   FContactDetails,
                                                   paymentDetails,
                                                   aProvider,
                                                   aMerchant);

    // Values for Result from the gateway:
    //  Pending       = 1  \_____These two values have been swapped to make OK = 0
    //  OK            = 0  /     to be consistent with Exchequer.
    //  NotAuthed     = 2
    //  Abort         = 3
    //  Rejected      = 4
    //  Authenticated = 5
    //  Registered    = 6
    //  Error         = 7

  End // If (FCreditCardAction <> ccaNoAction)
  Else
    // No action required - return successful status
    Result := 0;
End; // ExecuteCreditCardOperation

//------------------------------------------------------------------------------

Function TOrderPaymentsPayment.CreateRefundSummary : TOrderPaymentsVATPayDetailsList;
Var
  oMatchingRecs : TOrderPaymentsVATPayDetailsList;
  SummaryVATPayRec, MatchingVATPayRec, VATPayRec : OrderPaymentsVATPayDetailsRecType;
  oLine : IOrderPaymentsTransactionLineInfo;
  sPreDesc, sSuffDesc : ShortString;
  ModifiedUnitPrice : Double;
  I, LineCount : Integer;
Begin // CreateRefundSummary
  // Create the refund summary object
  Result := TOrderPaymentsVATPayDetailsList.Create;

  // For SINs build the matching information at the same time and then append to the
  // end of the list (so they are clustered together in theDB)
  If (FOrderPaymentTransInfo.optTransaction.InvDocHed = SIN) Then
    oMatchingRecs := TOrderPaymentsVATPayDetailsList.Create
  Else
    oMatchingRecs := NIL;

  // Create Payment summary line ----------------------------------------------
  InitialiseVATPayRec(SummaryVATPayRec);
  With SummaryVATPayRec Do
  Begin
    // SOR OurRef - originating order that all Order Payment transactions originate from
    If (FOrderPaymentTransInfo.optTransaction.InvDocHed = SOR) Then
      vpOrderRef := PadOrderRefKey (FOrderPaymentTransInfo.optTransaction.OurRef)
    Else
      vpOrderRef := PadOrderRefKey (FOrderPaymentTransInfo.optTransaction.thOrderPaymentOrderRef);

    // Payment OurRef (SRC) for payment taken against SOR/SDN/SIN
    vpReceiptRef := PadReceiptRefKey ('');  // Not known at this point

    // OurRef of related transaction, e.g. SDN or SIN a payment was made against
    If (FOrderPaymentTransInfo.optTransaction.InvDocHed <> SOR) Then
      vpTransRef := PadTransRefKey (FOrderPaymentTransInfo.optTransaction.OurRef)
    Else
      vpTransRef := PadTransRefKey ('');

    // Line sequence within OPVATPAY
    vpLineOrderNo   := 1;

    // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN
    vpSORABSLineNo  := 0;

    // Operation type / purpose
    If (FOrderPaymentTransInfo.optTransaction.InvDocHed = SOR) Then
      vpType := vptSORPayment
    Else If (FOrderPaymentTransInfo.optTransaction.InvDocHed = SDN) Then
      vpType := vptSDNPayment
    Else If (FOrderPaymentTransInfo.optTransaction.InvDocHed = SIN) Then
      vpType := vptSINPayment
    Else
      Raise Exception.Create ('TOrderPaymentsPayment.WritePaymentDetails: Unsupported Transaction Type (' + IntToStr(Ord(FOrderPaymentTransInfo.optTransaction.InvDocHed)) + ')');

    // SOR Currency and therefore SDN/SIN/SRC currency
    vpCurrency := FOrderPaymentTransInfo.optTransaction.Currency;

    // Text description of SOR line for printing VAT Receipts, e.g. £666.66 Part Payment against SORxxxxxx/SINxxxxxx
    vpDescription := FOrderPaymentTransInfo.optCurrencySymbol + Form_Real(FPaymentValue,0,2) + ' ' +
                     IfThen (FPaymentType = ptFull, 'Full', 'Part') + ' Payment against ';
    If (FOrderPaymentTransInfo.optTransaction.InvDocHed <> SOR) Then
      vpDescription := vpDescription + Trim(FOrderPaymentTransInfo.optTransaction.thOrderPaymentOrderRef) + '/';
    vpDescription := vpDescription + Trim(FOrderPaymentTransInfo.optTransaction.OurRef);

    // Exchequer User at point row inserted
    vpUserName := EntryRec^.Login;
  End; // With SummaryVATPayRec
  Result.Add(SummaryVATPayRec);

  // Create Payment line details ----------------------------------------------
  LineCount := 2;
  For I := 0 To (FOrderPaymentTransInfo.optTransactionLineCount - 1) Do
  Begin
    oLine := FOrderPaymentTransInfo.optTransactionLines[I];
    Try
      // Only add into VAT Payment Details if there is a payment
      If (oLine.optlCurrentPaymentTotal <> 0.0) Then
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
          If (FOrderPaymentTransInfo.optTransaction.InvDocHed = SOR) Then
            vpSORABSLineNo := oLine.optlTransactionLine.ABSLineNo
          Else
            vpSORABSLineNo := oLine.optlTransactionLine.SOPLineNo;

          // Calculate Unit Price taking into account discounts for the stock line - Note: This
          // could introduce penny type rounding errors with the rounded unit price not multiplying
          // up to the original line total - not sure what we can do about that
          ModifiedUnitPrice := Round_Up(oLine.optlLineGoods / oLine.optlTransactionLine.Qty, Syss.NoNetDec);

          If (Trim(oLine.optlTransactionLine.StockCode) <> '') Then
          Begin
            // Text description of SOR line for printing VAT Receipts, e.g. 10 x STUFF @ £100.00
            vpDescription := Form_Real (oLine.optlTransactionLine.Qty, 0, Syss.NoQtyDec) + ' x ' +
                             Trim(oLine.optlTransactionLine.StockCode) + ' @ ' +
                             Form_Real (ModifiedUnitPrice, 0, Syss.NoNetDec);
          End // If (Trim(oLine.optlTransactionLine.StockCode) <> '')
          Else
          Begin
            // Stock Code blank - Use the description instead - may need jiggery pokery to make it fit
            sPreDesc := Form_Real (oLine.optlTransactionLine.Qty, 0, Syss.NoQtyDec) + ' x ';
            sSuffDesc := ' @ ' + Form_Real (ModifiedUnitPrice, 0, Syss.NoNetDec);
            vpDescription := sPreDesc + Copy(oLine.optlTransactionLine.Desc, 1, 50 - Length(sPreDesc) - Length(sSuffDesc))  + sSuffDesc;
          End; // Else

          // SOR Line VAT Code
          // CJS 2015-01-06 - ABSEXCH-15988 - VAT Code M omitted from Order Payment VAT Returns
          if (oLine.optlTransactionLine.VATIncFlg In VATSet) and
             (oLine.optlTransactionLine.VATCode In VATEqStd) then
            vpVATCode := oLine.optlTransactionLine.VATIncFlg
          else
            vpVATCode := oLine.optlTransactionLine.VATCode;

          // Goods Value paid/refunded
          vpGoodsValue := oLine.optlCurrentPaymentGoods;
          // VAT Value paid/refunded
          vpVATValue := oLine.optlCurrentPaymentVAT;
        End; // With VATPayRec
        Result.Add(VATPayRec);

        // Create Matching details for SINs -----------------
        If Assigned(oMatchingRecs) Then
        Begin
          MatchingVATPayRec := VATPayRec;
          MatchingVATPayRec.vpType := vptMatching;
          oMatchingRecs.Add(MatchingVATPayRec);
        End; // If Assigned(oMatchingRecs)

        // Add Line for Stock Description -------------------
        If (Trim(oLine.optlTransactionLine.StockCode) <> '') Then
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
            vpDescription := oLine.optlTransactionLine.Desc;
          End; // With VATPayRec
          Result.Add(VATPayRec);
        End; // If (Trim(oLine.optlTransactionLine.StockCode) <> '')
      End; // If (oLine.optlCurrentPaymentTotal <> 0.0)
    Finally
      oLine := NIL;
    End; // Try..Finally
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

// Adds the description lines into OPVATPay.Dat
//
//  0           AOK
//  1000-1999  Error opening OPVATPay.Dat
//  2000-2999  Error inserting summary row
//  3000-3999  Error inserting transaction line row
//  4000-4999  Error inserting transaction Stock Description line row
Function TOrderPaymentsPayment.WritePaymentDetails (Const SRCRef : ShortString; Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;
Var
  VATPayBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;
  oLine : IOrderPaymentsTransactionLineInfo;
  sPreDesc, sSuffDesc : ShortString;
  ModifiedUnitPrice : Double;
  I, iStatus, LineCount : Integer;
Begin // WritePaymentDetails
  Result := 0;    // AOK

  // Create a Btrieve File Object for OPVATPay.Dat using the same Client Id as the ExLocal instance we are using.
  VATPayBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.CreateWithClientId (oBtrieveFile.ClientIdType(FOrderPaymentTransInfo.ExLocal.ExClientId^));
  Try
    iStatus := VATPayBtrieveFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
    If (iStatus = 0) Then
    Begin
      For I := 0 To (RefundSummary.Count - 1) Do
      Begin
        VATPayBtrieveFile.InitialiseRecord;
        VATPayBtrieveFile.VATPayDetails := RefundSummary.Records[I];
        With VATPayBtrieveFile.VATPayDetails Do
          vpReceiptRef := PadReceiptRefKey (SRCRef);
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
End; // WritePaymentDetails

//-------------------------------------------------------------------------

Function TOrderPaymentsPayment.GetOrderPaymentTransInfo : IOrderPaymentsTransactionInfo;
Begin // GetOrderPaymentTransInfo
  Result := FOrderPaymentTransInfo;
End; // GetOrderPaymentTransInfo
Procedure TOrderPaymentsPayment.SetOrderPaymentTransInfo (Value : IOrderPaymentsTransactionInfo);
Begin // SetOrderPaymentTransInfo
  FOrderPaymentTransInfo := Value;
End; // SetOrderPaymentTransInfo

//------------------------------

Function TOrderPaymentsPayment.GetPaymentType : enumOrderPaymentsPaymentType;
Begin // GetPaymentType
  Result := FPaymentType;
End; // GetPaymentType
Procedure TOrderPaymentsPayment.SetPaymentType (Value : enumOrderPaymentsPaymentType);
Begin // SetPaymentType
  FPaymentType := Value;
End; // SetPaymentType

//------------------------------

Function TOrderPaymentsPayment.GetPaymentValue : Double;
Begin // GetPaymentValue
  Result := FPaymentValue
End; // GetPaymentValue
Procedure TOrderPaymentsPayment.SetPaymentValue (Value : Double);
Begin // SetPaymentValue
  FPaymentValue := Value
End; // SetPaymentValue

//------------------------------

Function TOrderPaymentsPayment.GetPaymentGLCode : LongInt;
Begin // GetPaymentGLCode
  Result := FPaymentGLCode;
End; // GetPaymentGLCode
Procedure TOrderPaymentsPayment.SetPaymentGLCode (Value : LongInt);
Begin // SetPaymentGLCode
  FPaymentGLCode := Value;
End; // SetPaymentGLCode

//------------------------------

Function TOrderPaymentsPayment.GetPaymentReference : ShortString;
Begin // GetPaymentReference
  Result := FPaymentReference;
End; // GetPaymentReference
Procedure TOrderPaymentsPayment.SetPaymentReference (Value : ShortString);
Begin // SetPaymentReference
  FPaymentReference := Value;
End; // SetPaymentReference

//------------------------------

Function TOrderPaymentsPayment.GetPrintVATReceipt : Boolean;
Begin // GetPrintVATReceipt
  Result := FPrintVATReceipt;
End; // GetPrintVATReceipt
Procedure TOrderPaymentsPayment.SetPrintVATReceipt (Value : Boolean);
Begin // SetPrintVATReceipt
  FPrintVATReceipt := Value;
End; // SetPrintVATReceipt

//------------------------------

Function TOrderPaymentsPayment.GetCreditCardAction : enumCreditCardAction;
Begin // GetCreditCardAction
  Result := FCreditCardAction
End; // GetCreditCardAction
Procedure TOrderPaymentsPayment.SetCreditCardAction (Value : enumCreditCardAction);
Begin // SetCreditCardAction
  FCreditCardAction := Value;
End; // SetCreditCardAction

//-------------------------------------------------------------------------

Function TOrderPaymentsPayment.GetPaymentCostCentre : ShortString;
begin
  Result := FCostCentre;
end;

Procedure TOrderPaymentsPayment.SetPaymentCostCentre(const Value : ShortString);
begin
  FCostCentre := Value;
end;

//-------------------------------------------------------------------------
Function TOrderPaymentsPayment.GetPaymentDepartment : ShortString;
begin
  Result := FDepartment;
end;

Procedure TOrderPaymentsPayment.SetPaymentDepartment(const Value : ShortString);
begin
  FDepartment := Value;
end;

procedure TOrderPaymentsPayment.SetContactDetails(aContact : TAccountContact);
begin
  FContactDetails := aContact;
end;

//==============================================================================
// Create CustomData to send back to the Payment Portal to store in its
//  Disaster Recovery database.
// Not to be confused with the InvRec field, thCustomData1
function TOrderPaymentsPayment.CreateCustomData : WideString;
var
  XMLDoc         : TGmXML;
  rootNode       : TGmXMLNode;
  newNode        : TGmXMLNode;
  lineIndex      : integer;
  numTransLines  : integer;
  transLine      : IOrderPaymentsTransactionLineInfo;
  encodedText    : ShortString;
begin
  Result := '';

  XMLDoc := TGmXML.Create(nil);
  try
    XMLDoc.IncludeHeader := false;

    // Add the PayData node
    rootNode := XMLDoc.Nodes.AddOpenTag('PayData');
    // Add the attributes
    rootNode.Attributes.AddAttribute('TransRef', self.FOrderPaymentTransInfo.optOrder.OurRef);
    rootNode.Attributes.AddAttribute('Period', IntToStr(self.FOrderPaymentTransInfo.optOrder.AcPr));
    rootNode.Attributes.AddAttribute('Year', IntToStr(self.FOrderPaymentTransInfo.optOrder.AcYr));
    rootNode.Attributes.AddAttribute('GLCode', IntToStr(self.FPaymentGLCode));
    rootNode.Attributes.AddAttribute('CC', self.FCostCentre);
    rootNode.Attributes.AddAttribute('DP', self.FDepartment);
    rootNode.Attributes.AddAttribute('PayRef', self.FPaymentReference);

    //PR: 17/03/2017 ABSEXCH-16884 v2017 R1 Add credit card references
    rootNode.Attributes.AddAttribute('CreditCardReferenceNo', self.FOrderPaymentTransInfo.optOrder.thCreditCardReferenceNo);
    rootNode.Attributes.AddAttribute('CreditCardType', self.FOrderPaymentTransInfo.optOrder.thCreditCardType);
    rootNode.Attributes.AddAttribute('CreditCardNumber', self.FOrderPaymentTransInfo.optOrder.thCreditCardNumber);
    rootNode.Attributes.AddAttribute('CreditCardExpiry ', self.FOrderPaymentTransInfo.optOrder.thCreditCardExpiry);
    rootNode.Attributes.AddAttribute('CreditCardAuthorisationNo', self.FOrderPaymentTransInfo.optOrder.thCreditCardAuthorisationNo);

    // Check that there is at least one line
    numTransLines := self.FOrderPaymentTransInfo.optTransactionLineCount;

    if numTransLines > 0 then
    begin
      // Add the transaction line nodes
      for lineIndex := 0 to numTranslines-1 do
      begin
        transLine := self.FOrderPaymentTransInfo.optTransactionLines[lineIndex];

        newNode := rootNode.Children.AddLeaf('Line');
        // Add the attributes
        newNode.Attributes.AddAttribute('ABSNo', IntToStr(transLine.optlTransactionLine.ABSLineNo)) ;

        // PKR. 06/03/2015. If we have a stock code, include it in the line
        if (Trim(transLine.optlTransactionLine.StockCode) <> '') then
        begin
          // PKR. 09/04/2015. ABSEXCH-16104. Double quotes in stock codes and descriptions
          //  (eg when used for inches) are not surviving when they reach the C# code
          //  because " is the string delimiter.
          encodedText := WebEncode(transLine.optlTransactionLine.StockCode);
          newNode.Attributes.AddAttribute('Stk', encodedText);
        end
        else
        begin
          // We don't have a stock code, so store the description
          encodedText := WebEncode(Trim(transLine.optlTransactionLine.Desc));
          newNode.Attributes.AddAttribute('Desc', encodedText);
        end;
        
        newNode.Attributes.AddAttribute('Loc', transLine.optlTransactionLine.MLocStk);

        // If the VATCode is "M" (Manual VAT), then the inclusive VAT code will also be set,
        //  otherwise it will be a null string.  So by adding the two codes together,
        //  we will get a one or two character string. E.g. 'S' or 'MS'
        newNode.Attributes.AddAttribute('VATCode', transLine.optlTransactionLine.VATCode + transLine.optlTransactionLine.VATIncFlg);

        // PKR. 26/02/2015. ABSEXCH-16223. Use correct fields.
        newNode.Attributes.AddAttribute('Goods', Trim(Format('%30.2F', [transLine.optlCurrentPaymentGoods])));
        newNode.Attributes.AddAttribute('VAT',   Trim(Format('%30.2F', [transLine.optlCurrentPaymentVAT])));
      end;
    end;

    // Close the Paydata node
    XMLDoc.Nodes.AddCloseTag; // </PayData>

    Result := XMLDoc.Text;
  finally
    XMLDoc.Free;
  end;
end;

//------------------------------

// MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
function TOrderPaymentsPayment.GetSRCTransDate: ShortString;
begin
  Result := FSRCTransDate;
end;
procedure TOrderPaymentsPayment.SetSRCTransDate(const Value: ShortString);
begin
  FSRCTransDate := Value;
end;

//------------------------------

//PR: 22/01/2015 OurRef of SRC to create via disaster recovery
{$IFDEF COMTK}
function TOrderPaymentsPayment.GetSRCRef: ShortString;
begin
  Result := FSRCRef;
end;

procedure TOrderPaymentsPayment.SetSRCRef(const Value: ShortString);
begin
  FSRCRef := Value;
end;

function TOrderPaymentsPayment.GetSRCPeriod: Integer;
begin
  Result := FSRCPeriod;
end;

function TOrderPaymentsPayment.GetSRCYear: Integer;
begin
  Result := FSRCYear;
end;

procedure TOrderPaymentsPayment.SetSRCPeriod(const Value: Integer);
begin
  FSRCPeriod := Value;
end;

procedure TOrderPaymentsPayment.SetSRCYear(const Value: Integer);
begin
  FSRCYear := Value;
end;
{$ENDIF COMTK}

function TOrderPaymentsPayment.GetMerchantID: Int64;
begin
  Result := FMerchantID;
end;

function TOrderPaymentsPayment.GetProvider: Int64;
begin
  Result := FProvider;
end;

procedure TOrderPaymentsPayment.SetMerchantID(Value: Int64);
begin
  FMerchantID := Value;
end;

procedure TOrderPaymentsPayment.SetProvider(Value: Int64);
begin
  FProvider := Value;
end;

End.
