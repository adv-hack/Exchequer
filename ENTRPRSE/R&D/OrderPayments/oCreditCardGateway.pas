Unit oCreditCardGateway;

Interface

uses
  ExchequerPaymentGateway_TLB,
  VarConst,
  Controls, Forms, Windows, SysUtils,
  oOrderPaymentsTransactionInfo, OrderPaymentsInterfaces,
  oOPVATPayMemoryList, oOPVATPayBtrieveFile,
  BTSupU1,
  ContactsManager,
  Registry,
  ComObj,
  ActiveX;

Type
  // PKR. 22/07/2015. ABSEXCH-16683. ccaRequestPaymentAuthorisation     now means "Authenticate Card"
  //                                 ccaRequestPaymentUsingExistingAuth now means "Take Payment against Authenticated Card"
//  enumCreditCardAction = (ccaNoAction=0, ccaRequestPaymentAuthorisation=1, ccaRequestPayment=2, ccaRequestPaymentUsingExistingAuth=3, ccaRequestRefund=4);
  enumCreditCardAction = (ccaNoAction=0, ccaRequestPaymentAuthorisation=1, ccaRequestPayment=2, ccaRequestPaymentUsingExistingAuth=3, ccaRequestRefund=4);

  enumGatewayStatusIds = (gsiNoStatus = -1, gsiPending = 0, gsiOK, gsiNotAuthed, gsiAbort, gsiRejected, gsiAuthenticated, gsiRegistered, gsiError);

  ccValidationErrors = (veOK                         =   0,
                        veInvalidPaymentProvider     = 100,
                        veInvalidMerchantID          = 101,
                        veInvalidCompanyCode         = 102,
                        veInvalidSalesOrderReference = 103,
                        veInvalidContactName         = 104,
                        veInvalidCurrency            = 105,
                        veInvalidBillingAddr1        = 106,
                        veInvalidBillingTown         = 107,
                        veInvalidBillingCounty       = 108,
                        veInvalidBillingPostcode     = 109,
                        veInvalidBillingCountry      = 110,
                        veInvalidDelAddr1            = 111,
                        veInvalidDelTown             = 112,
                        veInvalidDelCounty           = 113,
                        veInvalidDelPostcode         = 114,
                        veInvalidDelCountry          = 115,
                        veInvalidNetTotal            = 116,
                        veInvalidVATTotal            = 117,
                        veInvalidGrossTotal          = 118
                       );

Const
  // Plug-in Id Code for the Exchequer Credit Card Payment Gateway
  CreditCardGatewayPlugInCode = 'EXCHCREDIT000286';

  // 24/09/2014. PKR : Updated these to match the HLD, and added Request Payment using existing Authorisation.
  // MH 03/07/2015 2015-R1 ABSEXCH-16496: Changed 'Credit Account only' to 'Create SRC only'
  // PKR. 16/11/2015. BSEXCH-16697. Changed 'Create SRC only' to 'Non Card Payment'. Changed order of items.
  
  CreditCardActionDescriptions : Array[enumCreditCardAction] Of String = ('Non Card Payment',
                                                                          'Request Card Authentication',
                                                                          'Pay by Card',
                                                                          'Request Payment Authorisation',
                                                                          'Request Refund');
  //------------------------------

Type
  TCCPaymentDetails = record
    FullPayment      : boolean;
    PaymentValue     : Double;
    PaymentReference : ShortString;
    CreditCardAction : enumCreditCardAction;
  end;
  //------------------------------

  // Generic interface for objects which implement a specific import type
  ICreditCardPaymentGateway = Interface
    ['{181FC1CE-B376-4C27-93A6-187131739F6A}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCompanyCode : String;
    Procedure SetCompanyCode (Value : String);
    Function GetInstalled : Boolean;
    Procedure SetInstalled (Value : Boolean);
    // PKR. 24/11/2014. ABSEXCH-15842. Added because uninstalling doesn't remove the licence
    //  so "installed" and "licenced" need to be checked separately.
    Function GetLicenced : Boolean;
    Procedure SetLicenced (Value : Boolean);
    Function GetCompanyEnabled : Boolean;

    // ------------------ Public Properties ------------------
    // Current Company Code open in Exchequer
    Property ccpgCompanyCode : String Read GetCompanyCode Write SetCompanyCode;
    // Is the Credit Card Plug-In Installed and Licenced?
    Property ccpgInstalled : Boolean Read GetInstalled Write SetInstalled;
    // PKR. 24/11/2014. ABSEXCH-15842. Added because uninstalling doesn't remove the licence
    //  so they installed and licenced need to be checked separately.
    Property ccpgLicenced  : Boolean Read GetLicenced Write SetLicenced;
    // Is the Credit Card Plug-In enabled for this Company?
    Property ccpgCompanyEnabled : Boolean Read GetCompanyEnabled;

    // ------------------- Public Methods --------------------
    // Function GetPaymentInstance : TPaymentGateway;
    // Function GetRefundInstance  : ?????????;
    Function MakePayment(aRefundSummary : TOrderPaymentsVATPayDetailsList;
                         iOPPaymentInfo  : IOrderPaymentsTransactionInfo;
                         aContactDetails : TAccountContact;
                         aPaymentDetails : TCCPaymentDetails;
                         aProvider       : int64;
                         aMerchant       : int64) : integer;

    Function GetPaymentResponse : PaymentGatewayResponse;

    Function GetPaymentDefaults(out aGLCode : integer;
                                out aProvider : int64;
                                out aMerchantID : int64;
                                out aCostCentre : string;
                                out aDepartment : string;
                                aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10 : string) : Boolean;

    // ABSEXCH-15792. PKR. 03/12/2014.  Set Payment Reference to Payment Provider name
    Function GetPaymentDefaultsEx(out aGLCode : integer;
                                  out aProvider : int64;
                                  out aMerchantID : int64;
                                  out aCostCentre : string;
                                  out aDepartment : string;
                                  out aPaymentProviderDesc : string;
                                  aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10 : string) : Boolean;

    Function MakeRefund(aCustomer : CustRec;
                        aContactDetails : TAccountContact;
                        aOriginalOrder : InvRec;
                        aCreditCardTransGUID : string;
                        aRefundCurrency : string;
                        aRefundSummary : TOrderPaymentsVATPayDetailsList;
                        aRefundReason  :  string) : integer;

    function GetTransactionStatus(aVendorTxCode : string) : PaymentGatewayResponse;

    function GetTransactionResult : integer;

    procedure SetOwnerHandle(aHandle : HWND);

    // Displays the Credit Card Payment Gateway's Configuration window
    Procedure DisplayConfigurationWindow;

    function GetServiceStatus() : boolean;

    function UpdateTransactionContent(const gatewayTransactionGuid: WideString;
                                       const receiptReference: WideString;
                                       const customData: WideString) : integer;

    // MH 18/02/2015 v7.1 ABSEXCH-16151: Made public to allow re-use by Payment form
    function ValidateContactName(aName : string) : boolean;
  End; // ICreditCardPaymentGateway

  //------------------------------

//PR: 20/02/2015 Added function to return the error message from the error code
function CCGatewayErrorMessage(errCode : Integer) : string;

procedure CCGatewayReportValidationError(errCode : integer);

// Returns the singleton instance of the CreditCardPaymentGateway
Function CreditCardPaymentGateway : ICreditCardPaymentGateway;

// Changed to a unit function
function IsCCAddinInstalled : Boolean;


Implementation

Uses
  Classes, Dialogs, GlobVar, {$IFDEF COMTK}MiscFunc,{$ENDIF}
  VAOUtil,
  TxStatusF,
  DotNet;
//=========================================================================

Type
  TCreditCardPaymentGateway = Class(TInterfacedObject, ICreditCardPaymentGateway)
  Private
    FCompanyCode : String;
    FInstalled : Boolean;
    FLicenced  : Boolean;
    FCompanyEnabled : Boolean;
    FOwnerHandle    : HWND;

    ccGateway : TPaymentGateway;

    // The reply from the CC Gateway, containing the reply from the Payment Portal.
    fResponse : PaymentGatewayResponse;

    fTransactionResult : integer;

    // ICreditCardPaymentGateway
    Function GetCompanyCode : String;
    Procedure SetCompanyCode (Value : String);
    Function GetInstalled : Boolean;
    Procedure SetInstalled (Value : Boolean);
    // PKR. 24/11/2014. ABSEXCH-15842. Added because uninstalling doesn't remove the licence
    //  so "Installed" and "Licenced" need to be checked separately.
    Function GetLicenced : Boolean;
    Procedure SetLicenced (Value : Boolean);
    Function GetCompanyEnabled : Boolean;

    // Displays the Credit Card Payment Gateway's Configuration window
    Procedure DisplayConfigurationWindow;

    Function MakePayment(aRefundSummary : TOrderPaymentsVATPayDetailsList;
                         iOPPaymentInfo : IOrderPaymentsTransactionInfo;
                         aContactDetails :TAccountContact;
                         aPaymentDetails : TCCPaymentDetails;
                         aProvider       : int64;
                         aMerchant       : int64) : integer;

    Function GetPaymentResponse : PaymentGatewayResponse;

    Function GetPaymentDefaults(out aGLCode : integer;
                                out aProvider : int64;
                                out aMerchantID : int64;
                                out aCostCentre : string;
                                out aDepartment : string;
                                aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10 : string) : Boolean;

    // ABSEXCH-15792. PKR. 03/12/2014.  Set Payment Reference to Payment Provider name
    Function GetPaymentDefaultsEx(out aGLCode : integer;
                                  out aProvider : int64;
                                  out aMerchantID : int64;
                                  out aCostCentre : string;
                                  out aDepartment : string;
                                  out aPaymentProviderDesc : string;
                                  aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10 : string) : Boolean;

    Function MakeRefund(aCustomer : CustRec;
                        aContactDetails : TAccountContact;
                        aOriginalOrder : InvRec;
                        aCreditCardTransGUID : string;
                        aRefundCurrency : string;
                        aRefundSummary : TOrderPaymentsVATPayDetailsList;
                        aRefundReason  :  string) : integer;

    function GetTransactionStatus(aVendorTxCode : string) : PaymentGatewayResponse;

    function GetTransactionResult : integer;

    procedure SetOwnerHandle(aHandle : HWND);

    function ValidateInputData(transDetails : ExchequerTransaction;
                               aProvider : integer; aMerchant : integer) : ccValidationErrors;

    function GetServiceStatus() : boolean;

    function UpdateTransactionContent(const gatewayTransactionGuid: WideString;
                                       const receiptReference: WideString;
                                       const customData: WideString) : integer;

    function ValidateContactName(aName : string) : boolean;
  Public
    Constructor Create;
    Destructor Destroy; override;
  End; // TCreditCardPaymentGateway


Var
  // Internal references to singleton instance
  CreditCardPaymentGatewayObj : TCreditCardPaymentGateway;
  CreditCardPaymentGatewayIntf : ICreditCardPaymentGateway;

  personalTitles : array [1..13] of string = ('Ms',   'Miss', 'Mrs',  'Mr',   'Master',
                                              'Rev',  'Fr',   'Dr',   'Prof', 'Sir',
                                              'Lord', 'Dame', 'Lady');

// Returns the singleton instance of the CreditCardPaymentGateway
Function CreditCardPaymentGateway : ICreditCardPaymentGateway;
Begin // CreditCardPaymentGateway
  If (Not Assigned(CreditCardPaymentGatewayObj)) Then
  Begin
    // Create instance and record local reference to prevent destruction
    CreditCardPaymentGatewayObj := TCreditCardPaymentGateway.Create;
    CreditCardPaymentGatewayIntf := CreditCardPaymentGatewayObj;
  End; // If (Not Assigned(CreditCardPaymentGatewayObj))

  Result := CreditCardPaymentGatewayIntf;
End; // CreditCardPaymentGateway

//=========================================================================

// DO NOT USE THIS DIRECTLY.  Use the CreditCardPaymentGateway function
Constructor TCreditCardPaymentGateway.Create;
Begin // Create
  Inherited Create; // Because it inherits from TInterfacedObject

  FCompanyCode := '';
  FCompanyEnabled := False;

  FInstalled := isCCAddinInstalled;

  // PKR. 02/01/2015. ABSEXCH-15971. Only allow the credit card add-in if it is a UK system.
  if (CurrentCountry <> UKCCode) then
  begin
    // PKR. 24/11/2014. ABSEXCH-15842. Added because uninstalling doesn't remove the licence
    //  so the installed and licenced need to be checked separately.

    // Clear the FInstalled flag and FLicenced flag because not UK
    FInstalled := false;
    FLicenced  := false;
  end;

  if (FInstalled) then
  begin
    // Get an instance of the Credit Card Add-in
    ccGateway := TPaymentGateway.Create(nil);
  end;
End; // Create


//------------------------------------------------------------------------------
Destructor TCreditCardPaymentGateway.Destroy;
begin
  // ABSEXCH-16215. Release allocated resource.
  if Assigned(ccGateway) then
  begin
    // Release the resources on the COM object because its Dispose method and
    // destructor (finalizer) are never called, even when all its references have
    // been nulled.
    // Not the perfect solution, but it does make the COM Toolkit drop out of memory
    // as required.

    // PKR. 26/08/2015. ABSEXCH-16713 Toolkit apps that use the CC add-in get an access violation
    //  on shutdown.
    // Coat this call in a try..finally block to trap and sink the error.
    // Note:	Assigned() (used above) can't detect a dangling pointer - that is, one that isn't nil
    //  but no longer points to valid data.
    // So if the Add-in has already fallen out of memory (due to finalization code), we're covered.
    try
// PKR. 31/07/2015. ABSEXCH-16714. Temporary Quick and Dirty fix to stop an Access Violation in toolkit apps
      // Comment the following line out.  The side-effect of this is that The COM Toolkit stays in memory
      // after exiting.
      // PKR. 27/08/2015. ABSEXCH-16787. Line reinstated following the addition of the
      // try..finally block to sink the access violation which might occur due to the odd behaviour of
      //  the .NET garbage collector (see comment for ABSEXCH-16713 above).
      ccGateway.FreeResources;
    finally
    end;
  end;
  inherited Destroy; // Because it inherits from TInterfacedObject
end;


//-------------------------------------------------------------------------
Function TCreditCardPaymentGateway.GetCompanyCode : String;
Begin
  Result := FCompanyCode;
End;

//-------------------------------------------------------------------------
Procedure TCreditCardPaymentGateway.SetCompanyCode (Value : String);
Begin
  FCompanyCode := Value;

  ccGateway.SetCurrentCompanyCode(GetCompanyCode);

  // See if the add-in and its prerequisites have been installed.
//  IsCCAddinInstalled;

  // 24/09/2014. PKR. Request CC config for enabled flag
  FCompanyEnabled := ccGateway.IsCCEnabledForCompany(GetCompanyCode);
//  FCompanyEnabled := FInstalled and ccGateway.IsCCEnabledForCompany(GetCompanyCode);
End;

//------------------------------

Function TCreditCardPaymentGateway.GetInstalled : Boolean;
Begin
  Result := FInstalled
End;
Procedure TCreditCardPaymentGateway.SetInstalled (Value : Boolean);
Begin
  FInstalled := Value;
End;

//------------------------------
// PKR. 24/11/2014. ABSEXCH-15842. Added because uninstalling doesn't remove the licence
//  so the "installed" and "licenced" properties need to be checked separately.
Function TCreditCardPaymentGateway.GetLicenced : Boolean;
Begin
  Result := FLicenced
End;
Procedure TCreditCardPaymentGateway.SetLicenced (Value : Boolean);
Begin
  FLicenced := Value;
End;

//------------------------------

Function TCreditCardPaymentGateway.GetCompanyEnabled : Boolean;
Begin
  Result := FCompanyEnabled;
End;

//-------------------------------------------------------------------------

// Displays the Credit Card Payment Gateway's Configuration window
Procedure TCreditCardPaymentGateway.DisplayConfigurationWindow;
var
  mainHandle : HWnd;
Begin // DisplayConfigurationWindow
  // PKR. 11/02/2015. ABSEXCh-16123. Check that the add-in is still installed
  // before attempting to use it.
  if (not IsCCAddinInstalled) then
  begin
{$IFDEF Enter1}
    ShowMessage('The credit card add-in has been uninstalled.'#13#10'Contact your system administrator.');
{$ENDIF}
  end
  else
  begin
    ccGateway.SetCurrentCompanyCode(GetCompanyCode);

    mainHandle := Application.MainForm.Handle;

    Screen.Cursor := crHourglass;

    // Call the Configuration Window
    // Parameters are: Company code, superuser flag (true if logged in under system password)

    // PKR. 30/01/2015. ABSEXCH-16098.  Defaulting to logged in as system.
  {$ifdef RESTORETEST}
    // For testing only.  Display the config dialog as a superuser.  This will never occur on
    // the build machine.
    ShowMessage('Warning: Forced Superuser login');
    ccGateway.DisplayConfigurationDialog(mainHandle, GetCompanyCode, EntryRec.Login, true);
  {$else}
    ccGateway.DisplayConfigurationDialog(mainHandle, GetCompanyCode, EntryRec.Login, SBSIN);
  {$endif}

    // If the company's credit card enabled status has changed as a result of using
    //  the configuration dialog, we need to reflect the change.
    FCompanyEnabled :=  ccGateway.IsCCEnabledForCompany(GetCompanyCode);

    Screen.Cursor := crDefault;
  end;
End; // DisplayConfigurationWindow


//------------------------------------------------------------------------------
Function TCreditCardPaymentGateway.MakePayment(aRefundSummary  : TOrderPaymentsVATPayDetailsList;
                                               iOPPaymentInfo  : IOrderPaymentsTransactionInfo;
                                               aContactDetails : TAccountContact;
                                               aPaymentDetails : TCCPaymentDetails;
                                               aProvider       : int64;
                                               aMerchant       : int64) : integer;
var
  theTrans       : InvRec;
  theCust        : CustRec;
  transDetails   : ExchequerTransaction;
  delAddress     : addrTyp;
  delPostCode    : string;
  delCountry     : string;
  billingAddress : addrTyp;
  billingPostcode: string;
  billingCountry : string;
  lineIndex      : integer;
  aTLine         : TransactionLine;
  vatRate        : double;
  oVatType       : VATType;

  txStatusCheckForm : TccTxStatusForm;

  parentControl : TWinControl;

  refSummLine    :  OrderPaymentsVATPayDetailsRecType;
  eMessage       : string;
begin
  result :=  999;
  txStatusCheckForm := nil;

  // PKR. 11/02/2015. ABSEXCh-16123. Check that the add-in is still installed
  // before attempting to use it.
  if (not IsCCAddinInstalled) then
  begin
{$IFDEF Enter1}
    ShowMessage('The credit card add-in has been uninstalled');
{$ENDIF}
  end
  else
  begin
    ccGateway.SetCurrentCompanyCode(GetCompanyCode);

    // Get the transaction and customer details that we want to process
    theTrans := iOPPaymentInfo.optTransaction;
    theCust  := iOPPaymentInfo.optAccount;

    transDetails := CoExchequerTransaction.Create;

    // Populate fields common to all payment transactions
    transDetails.Set_ExchequerCompanyCode(Trim(theTrans.CustCode));
    transDetails.Set_SalesOrderReference(Trim(theTrans.OurRef));

    transDetails.Set_DescendentTransactionReference('');

    billingAddress  := theCust.Addr;
    billingPostcode := theCust.PostCode;
    billingCountry  := theCust.acCountry;

    // These need to be set to the contact selected on the payments form
    //  or the general contact from the company.
    if (aContactDetails <> nil) then
    begin
      transDetails.Set_ContactName(aContactDetails.contactDetails.acoContactName);
      transDetails.Set_ContactPhone(aContactDetails.contactDetails.acoContactPhoneNumber);
      transDetails.Set_ContactEmail(aContactDetails.contactDetails.acoContactEmailAddress);

      // If the contact has their own address, then use it.
      if (aContactDetails.contactDetails.acoContactHasOwnAddress) then
      begin
        billingAddress := aContactDetails.contactDetails.acoContactAddress;
        billingPostCode := aContactDetails.contactDetails.acoContactPostCode;
        billingCountry  := aContactDetails.contactDetails.acoContactCountry;
      end;
    end
    else
    begin
      // The contact is nil, so get the details from the company record
      transDetails.Set_ContactName(Trim(theCust.Contact));
      transDetails.Set_ContactPhone(Trim(theCust.Phone));
      transDetails.Set_ContactEmail(Trim(theCust.EmailAddr));
    end;

    // Delivery address is taken from the transaction.
    // If it is blank, then use the delivery address from the customer record
    // If that is blank, use the address from the customer record.
    // An address is deemed to be blank if its first line is blank.
    delAddress   := theTrans.DAddr;
    delPostCode  := Trim(theTrans.thDeliveryPostCode);
    delCountry   := Trim(theTrans.thDeliveryCountry);
    // PKR. 26/08/2015. ABSEXCH-16593 Unexpected validation error returned if Line 1 missing
    // PKR. 29/09/2015. Removed Country from this test because it is will be populated to a default value.
    if (delAddress[1] = '') and
       (delAddress[2] = '') and
       (delAddress[3] = '') and
       (delAddress[4] = '') and
       (delAddress[5] = '') and
       (delPostCode = '') then
    begin
      // Delivery address on the transaction is blank
      // Try the customer record delivery address.
      delAddress  := theCust.DAddr;
      delPostCode := theCust.acDeliveryPostCode;
      delCountry  := theCust.acCountry;
      if delAddress[1] = '' then
      begin
        // Customer delivery address is blank so use the customer record address
        delAddress  := billingAddress;
        delPostCode := billingPostCode;
        delCountry  := billingCountry;
      end;

      // The Delivery address is mandatory, and the Payment Portal objects
      // to not having a Delivery Postcode.
      if delPostCode = '' then
      begin
        // If the delivery address looks the same as the billing address, then use the billing postcode
        if (delAddress[1] = billingAddress[1]) and (delAddress[2] = billingAddress[2]) then
        begin
          delPostCode := billingPostCode;
          delCountry  := billingCountry;
        end
      end;
    end;

    // We have address details
    transDetails.Set_DeliveryAddress1(Trim(delAddress[1]));
    transDetails.Set_DeliveryAddress2(Trim(delAddress[2]));
    // ABSEXCH-15959. Change Town to Address[4] and County to Address[5]
    transDetails.Set_DeliveryAddress3_Town(Trim(delAddress[4]));
    transDetails.Set_DeliveryAddress4_County(Trim(delAddress[5]));
    // PKR. Changed to use new country field instead of delAddress[5]
    transDetails.Set_DeliveryAddress_Country(Trim(delCountry));
    transDetails.Set_DeliveryAddressPostCode(Trim(delPostCode));

    // Billing address is always the customer address
    transDetails.Set_BillingAddress1(Trim(billingAddress[1]));
    transDetails.Set_BillingAddress2(Trim(billingAddress[2]));
    // ABSEXCH-15959. Change Town to Address[4] and County to Address[5]
    transDetails.Set_BillingAddress3_Town(Trim(billingAddress[4]));
    transDetails.Set_BillingAddress4_County(Trim(billingAddress[5]));
    // PKR. Changed to use new country field instead of billingAddress[5]
    transDetails.Set_BillingAddress_Country(Trim(billingCountry));
    transDetails.Set_BillingAddressPostCode(Trim(billingPostCode));

    // PKR. 12/06/2015. ABSEXCH-16495. If the Billing Address is blank, use the delivery
    // address from the transaction as both delivery and billing addresses.
    if (Trim(billingAddress[1]) = '') then
    begin
      // Use the Delivery Address from the transaction
      transDetails.Set_BillingAddress1(Trim(theTrans.DAddr[1]));
      transDetails.Set_BillingAddress2(Trim(theTrans.DAddr[2]));
      transDetails.Set_BillingAddress3_Town(Trim(theTrans.DAddr[4]));
      transDetails.Set_BillingAddress4_County(Trim(theTrans.DAddr[5]));
      transDetails.Set_BillingAddressPostCode(Trim(theTrans.thDeliveryPostCode));
      transDetails.Set_BillingAddress_Country(Trim(theTrans.thDeliveryCountry));
    end;

    transDetails.Set_FullAmount(aPaymentDetails.FullPayment);

    transDetails.Set_CurrencySymbol(Trim(iOPPaymentInfo.optCurrencySymbol));
    transDetails.Set_CurrencyCode(iOPPaymentInfo.optCurrency);
    transDetails.Set_NetTotal(iOPPaymentInfo.GetTotalPaymentsGoods);
    transDetails.Set_VATTotal(iOPPaymentInfo.GetTotalPaymentsVAT);
    transDetails.Set_GrossTotal(iOPPaymentInfo.GetTotalPaymentsGoods + iOPPaymentInfo.GetTotalPaymentsVAT);
    transDetails.Set_PaymentReference(aPaymentDetails.PaymentReference);

    // Populate the required fields for this payment type

    // PKR. 03/02/2015. ABSEXCH-16112 Unable to take payment against previous authorisation
    // if the authorisation was against the SOR, but the payment is against a SIN or SDN.
    // If this transaction is a SIN or SDN, we have to provide the original SOR OurRef
    if (theTrans.InvDocHed = SIN) or (theTrans.InvDocHed = SDN) then
    begin
      transDetails.Set_DescendentTransactionReference(theTrans.thOrderPaymentOrderRef);
    end;

    // Set the payment request type
    // ABSEXCH-15870. PKR. 03/12/2014. Unable to submit a payment when Payment Reference is populated.
    // ABSEXCH-15874. PKR. 03/12/2014. Unable to request a Payment Authorisation
    case aPaymentDetails.CreditCardAction of
      ccaRequestPaymentAuthorisation:
        begin
          // PKR. 21/07/2015. ABSEXCH-16683.  EPP functionality changes.
          // This now means "Card Authentication"
          transDetails.Set_PaymentType(PaymentAction_CardAuthentication);
        end;
      ccaRequestPayment:
        begin
          transDetails.Set_PaymentType(PaymentAction_Payment);
        end;
      ccaRequestPaymentUsingExistingAuth:
        begin
          // PKR. 21/07/2015. ABSEXCH-16683.  EPP functionality changes.
          // This now means "Take Payment against an authenticated card"
          transDetails.Set_PaymentType(PaymentAction_PaymentAuthorisation);

          // PKR. 28/07/2015. ABSEXCH-16683. Card Authentication.
          if ((theTrans.thOrderPaymentFlags and thopfCreditCardAuthorisationTaken) > 0) then
          begin
            transDetails.Set_AuthenticationGUID(theTrans.thCreditCardReferenceNo);
          end;
        end;
    end;

    transDetails.Set_NetTotal(iOPPaymentInfo.optTransactionTotalGoods);
    transDetails.Set_VATTotal(iOPPaymentInfo.optTransactionTotalVAT);
    transDetails.Set_GrossTotal(iOPPaymentInfo.optTransactionTotal);

    // ABSEXCH-15996. PKR. 08/01/2015. Shopping Basket now required for ALL
    //  payment requests, including Authorise Only, due to WorldPay.

    // We need a ShoppingBasket for a payment request, so we must populate
    //  the transaction lines so we can build one in the add-in
    for lineIndex := 0 to aRefundSummary.Count-1 do
    begin
      // Get the line details from the Refund Summary
      refSummLine := aRefundSummary.Records[lineIndex];

      // PKR. 03/12/2014. ABSEXCH-15861.  SIN lines are doubling up
      // PKR. 04/03/2015. ABSEXCH-16226.  Use the line type to filter out the matching rows.
      if (((iOPPaymentInfo.optTransaction.InvDocHed in [SOR]) and (refSummLine.vpType = vptSORPayment)) or
          ((iOPPaymentInfo.optTransaction.InvDocHed in [SDN]) and (refSummLine.vpType = vptSDNPayment)) or
          ((iOPPaymentInfo.optTransaction.InvDocHed in [SIN]) and (refSummLine.vpType = vptSINPayment))) and
          // Filter out the additional description lines
          (refSummLine.vpSORABSLineNo <> 0) then
      begin
        // Create a new destination line
        aTLine := CoTransactionLine.Create;

        // Now populate it
        aTLine.Set_Description(refSummLine.vpDescription);
        aTLine.Set_StockCode('');
        if (refSummLine.vpVATCode = '') then
          aTLine.Set_VATCode('S')
        else
          aTLine.Set_VATCode(refSummLine.vpVATCode);

        aTLine.Set_Quantity(1); // Because it's an aggregate amount.

        oVatType := GetVATNo(refSummLine.vpVATCode, #0);
        vatRate := SyssVAT^.VATRates.VAT[oVatType].Rate;
        aTLine.Set_VATMultiplier(vatRate);

        aTLine.Set_TotalNetValue(refSummLine.vpGoodsValue);
        aTLine.Set_TotalVATValue(refSummLine.vpVATValue);
        aTLine.Set_TotalGrossValue(refSummLine.vpGoodsValue + refSummLine.vpVATValue);

        aTLine.Set_UnitPrice(refSummLine.vpGoodsValue);

        aTLine.Set_UnitDiscount(0);
        aTLine.Set_TotalDiscount(0);

        // Add the line to the transaction
        transDetails.AddLine(aTLine);
      end;
    end;

    // Validate the input data
    Result := Ord(ValidateInputData(transDetails, aProvider, aMerchant));

    // Process the data if it validated ok.
    if Result = 0 then
    begin
      //--------------------------------------------------------------------------
      // Pass the transaction through the gateway
      Try
        try
          // PKR. 25/11/2014. Added conditional define to prevent crashing when used with the toolkit
      {$IFDEF ENTER1}
          ccGateway.SetParentHandle(integer(Application.MainForm.Handle));
      {$ELSE}
          if FOwnerHandle <> 0 then
            ccGateway.SetParentHandle(integer(FOwnerHandle));
      {$ENDIF}

          fResponse := ccGateway.ProcessPayment(transDetails, aProvider, aMerchant);

          if (not fResponse.IsError) then
          begin
            // Display the polling dialog
        {$IFDEF ENTER1}
            parentControl := Controls.FindControl(FOwnerHandle); // Could be nil
            txStatusCheckForm := TccTxStatusForm.Create(parentControl);

            if (parentControl <> nil) then
            begin
              // Position the form centred on the parent
              txStatusCheckForm.Left := (parentControl.Width  - txStatusCheckForm.Width ) div 2 + parentControl.Left;
              txStatusCheckForm.Top  := (parentControl.Height - txStatusCheckForm.Height) div 2 + parentControl.Top;
            end;
        {$ELSE}
            //If we have an owner window handle use it as the parent of the form
            if FOwnerHandle <> 0 then
            begin
              txStatusCheckForm := TccTxStatusForm.CreateParented(FOwnerHandle);

              // The following lines allow the progress form to be embedded into the parent window
              txStatusCheckForm.borderIcons := [];
              txStatusCheckForm.borderStyle := bsNone;
              txStatusCheckForm.formStyle := fsNormal;
              txStatusCheckForm.Top := 0;
              txStatusCheckForm.Left := 0;
              Application.ProcessMessages;
            end;
        {$ENDIF}

            // Set up and display the Polling form
            txStatusCheckForm.SetPaymentGateway(ccGateway);
            txStatusCheckForm.SetTransactionID(fResponse.gatewayTransactionGuid);
            txStatusCheckForm.SetOurRef(theTrans.OurRef);

//            txStatusCheckForm.btnClose.Enabled := false;

            // ABSEXCH-15997. PKR. 07/01/2015.
            // This form is now used for checking Authorise Only as well as Payment
            //  requests, so we have to set it up accordingly.
            // By default, the status check form checks normal transaction statuses, and we only
            //  have to override it for an Authorise Only.

            // PKR. 21/07/2015. ABSEXCH-16683. Authorise only no longer supported.
            // ccaRequestPaymentAuthorisation now means Authenticate Card, which is handled like a payment.
//            if (aPaymentDetails.CreditCardAction = ccaRequestPaymentAuthorisation) then
//            begin
              // Authorisation only
//              txStatusCheckForm.SetCheckAuthoriseOnly(theTrans.OurRef, true);
//            end
//            else
//            begin

            // Payment request or Card Authentication
            if (fResponse.gatewayTransactionGuid = '') then
            begin
              txStatusCheckForm.btnClose.Enabled := true;
              txStatusCheckForm.richStatusLog.Lines.Add('No response from Exchequer Payment Portal.  Payment cannot be processed');
              txStatusCheckForm.btnClose.Enabled := true;
              Result := ord(gsiError);
              exit;
            end;

            txStatusCheckForm.SetTransactionID(fResponse.gatewayTransactionGuid);
//            end;

            // Display the transaction status polling form
            // ABSEXCH-15856. PKR. 05/12/2014. When the Payment form invoked the payment, it set
            // the cursor to hourglass because it can take a while to wake up the portal.
            // Now that we are showing a new GUI object, we can change it back again.
            Screen.Cursor := crDefault;

            // ABSEXCH-15978. PKR. 08/01/2015. Stop user from closing the payment window
            //  before the status check window.
            // PKR. 03/02/2015. Only show it modal if it's in Enter1 so that it doesn't
            // break toolkit apps.
  {$IFDEF ENTER1}
            txStatusCheckForm.ShowModal;
  {$ELSE}
            txStatusCheckForm.Show;
  {$ENDIF}

            // Don't really like this...
            while txStatusCheckForm.isCheckingStatus do
            begin
              Application.ProcessMessages;
              Sleep(100);
            end;

            // We need to get a status value from the Polling form to determine the true result of the transaction
            fTransactionResult := txStatusCheckForm.GetTransactionStatus;

            // PKR. 21/07/2015. ABSEXCH-16683. Authorise only no longer supported
//            if (aPaymentDetails.CreditCardAction = ccaRequestPaymentAuthorisation) then
//            begin
              // Authorisation only.
//              result := fTransactionResult;
//            end
//            else
//            begin
              // Payment request
              fResponse := txStatusCheckForm.GetTransactionResponse;
              if fResponse = nil then
              begin
                result := Ord(gsiError);
              end;
//            end;
          end // fResponse not error
          else
          begin
            // fResponse.isError is true, or the gatewayTransactionGuid is blank.
            result := Ord(gsiError);
          end;
        except
          on E : Exception do
          begin
            {$IFDEF ENTER1}
            eMessage := E.Message;

            // We don't like the "Object reference not set to..." message to be shown to users as it's too geeky.
            // Toolkit users will always get the original message.
            if (Pos('object reference not set to an instance of an object', lowercase(eMessage)) > 0) then
            begin
              // PKR. 01/04/2015. Error message was misleading.
              eMessage := 'An error has occurred in the Exchequer Payment Portal.'#13#10 +
                          'Please try again.';
            end;

            ShowMessage('Error processing Payment : ' + #13#10 + eMessage);
            Screen.Cursor := crDefault;
            {$ELSE}
              {$IFDEF COMTK}
                 //If called from the COM Toolkit use Dedicated Exception object which puts error message into Toolkit.LastErrorString
                 raise EToolkitException.Create('Error processing Payment: ' + QuotedStr(E.Message));
              {$ELSE}
                 //reraise the exception
                 raise;
               {$ENDIF not COMTK}
            {$ENDIF not Enter1}
          end;
        end;

        // ABSEXCH-15875. PKR. 05/12/2014. Cancelling a transaction at the Payment Provider is not passed back to the host app.
        // This was a bug in the Payment Portal. These code changes take advantage of the correct codes that are now passed back.
        // Exchequer uses 0 to mean success, but the portal uses 1, so we'll switch the first 2 results.
        case enumGatewayStatusIds(fTransactionResult) of
          gsiPending:
            begin
              Result := 1;
            end;
          gsiOK:
            begin
              Result := 0;
            end;
          gsiNotAuthed,
          gsiAbort,
          gsiRejected,
          gsiAuthenticated,
          gsiRegistered,
          gsiError:
            begin
              Result := fTransactionResult;
            end;
        end;

      Finally
        {$IFNDEF COMTK}
        if Assigned(txStatusCheckForm) then
        begin
          // PKR. 18/02/2015. ABSEXCH-16077, ABSEXCH-16170.  Handle loss of connection with payment provider.
          txStatusCheckForm.Free;
        end;
        Screen.Cursor := crDefault;
        {$ENDIF}
      End;
    end; // Data validated ok
  end;
end;

//==============================================================================
// Very simple data validation, mainly to avoid null values in mandatory fields.
function TCreditCardPaymentGateway.ValidateInputData(transDetails : ExchequerTransaction;
                                                     aProvider : integer; aMerchant : integer) : ccValidationErrors;
var
  aggAddress : widestring;
begin
  Result := veOK;

  // PKR. 26/08/2015. ABSEXCH-16593. Unexpected validation error if Line 1 missing.
  // Now exits after finding first error.

  // PKR. 05/02/2015. ABSEXCH-16120. ABSEXCH-16150 (duplicate).
  // Validate the contact name, which must be in Firstname Surname or Title Firstname Surname format.
  //  Title Surname is not allowed.

  // PKR. 15/05/2015. ABSEXCH-16424. Contact details no longer needed for Refunds
  // so only validate for other transaction types.
  // PKR. 04/11/2015. ABSEXCH-16725. Contact details don't need to be validated for Payment Authorisation
  // as the Payment Provider already has those details.
  if (transDetails.PaymentType <> PaymentAction_Refund) and
     (transDetails.PaymentType <> PaymentAction_PaymentAuthorisation) then
  begin
    if not ValidateContactName(transDetails.ContactName) then begin Result := veInvalidContactName; exit; end;
    if transDetails.ContactName = ''                     then begin Result := veInvalidContactName; exit; end;

    // Only these 4 address fields are mandatory.
    if transDetails.BillingAddress1 = ''        then begin Result := veInvalidBillingAddr1; exit; end;
    if transDetails.BillingAddress3_Town = ''   then begin Result := veInvalidBillingTown; exit; end;
    if transDetails.BillingAddressPostCode = '' then begin Result := veInvalidBillingPostcode; exit; end;
    if transDetails.BillingAddress_Country = '' then begin Result := veInvalidBillingCountry; exit; end;

    // Delivery address is not mandatory, but if any part is specified, then the other mandatory parts must be specified
    aggAddress := transDetails.DeliveryAddress1 +
                  transDetails.DeliveryAddress3_Town +
                  transDetails.DeliveryAddressPostCode;
    // Removed country from the test because it can be populated even if the rest of
    //  the delivery address is blank.

    if aggAddress <> '' then
    begin
      // We've specified part of the delivery address, so the rest must be valid, including the country
      if transDetails.DeliveryAddress1 = ''        then begin Result := veInvalidDelAddr1; exit; end;
      if transDetails.DeliveryAddress3_Town = ''   then begin Result := veInvalidDelTown; exit; end;
      if transDetails.DeliveryAddressPostCode = '' then begin Result := veInvalidDelPostcode; exit; end;
      if transDetails.DeliveryAddress_Country = '' then begin Result := veInvalidDelCountry; exit; end;
    end;
  end;

  // ABSEXCH-15954. PKR. 09/01/2015. These can be 0.  The Portal will use the defaults.
//  if aProvider = 0 then Result := veInvalidPaymentProvider;
//  if aMerchant = 0 then Result := veInvalidMerchantID;

  if transDetails.ExchequerCompanyCode = '' then begin Result := veInvalidCompanyCode; exit; end;
  if transDetails.SalesOrderReference = '' then begin Result := veInvalidSalesOrderReference; exit; end;

  if transDetails.CurrencySymbol = '' then begin Result := veInvalidCurrency; exit; end;

  if transDetails.NetTotal <= 0 then begin Result   := veInvalidNetTotal; exit; end;
  if transDetails.VATTotal < 0 then begin Result    := veInvalidVATTotal; exit; end;
  if transDetails.GrossTotal <= 0 then begin Result := veInvalidGrossTotal; exit; end;
end;

//==============================================================================
function TCreditCardPaymentGateway.ValidateContactName(aName : string) : boolean;
var
  exploder : TStringList;
  index    : integer;
begin
  Result := true; // Innocent until proven guilty
  exploder := TStringList.Create;

  exploder.delimiter := ' ';
  exploder.delimitedText := StringReplace(aName, '.', ' ', [rfReplaceAll]);
  if exploder.Count < 2 then
  begin
    // Need at least 2 names
    Result := false;
  end
  else
  begin
    // Have at least 2 names.  See if the first one is a title
    for index := Low(personalTitles) to High(personalTitles) do
    begin
      if exploder[0] = personalTitles[index] then
      begin
        // It's a title.  That's ok if there are 3 names, but not if there are 2.
        if exploder.Count = 2 then
          Result := false;

        // No need to check more titles.
        break;
      end;
    end; // for each title
  end;
end;

//==============================================================================
Function TCreditCardPaymentGateway.MakeRefund(aCustomer : CustRec;
                                              aContactDetails : TAccountContact;
                                              aOriginalOrder : InvRec;
                                              aCreditCardTransGUID : string;
                                              aRefundCurrency : string;
                                              aRefundSummary : TOrderPaymentsVATPayDetailsList;
                                              aRefundReason  :  string) : integer;
{ The minimum required data in the PaymentPortal shopping basket object to carry out
  a refund consists of:
  - The Original Transaction GUID
  - The Currency Code (ISO-4217)
  - Refund Gross Amount
  The gross amount does not have to match the original payment amount, which means that
  partial refunds are possible.
}
var
  transDetails   : ExchequerTransaction;
  aTLine         : TransactionLine;
  opTransLine    : OrderPaymentsVATPayDetailsRecType;
  index          : integer;
  RefundGrossAmount : double;
  RefundNetAmount   : double;
  parentControl : TWinControl;
  txStatusCheckForm : TccTxStatusForm;

  delAddress     : addrTyp;
  delPostCode    : string;
  delCountry     : string;
  billingAddress : addrTyp;
  billingPostcode: string;
  billingCountry : string;
  coCode         : string;

  vatRate        : double;
  oVatType       : VATType;
begin
  result :=  999;

  txStatusCheckForm := nil;

  // PKR. 11/02/2015. ABSEXCh-16123. Check that the add-in is still installed
  // before attempting to use it.
  if (not IsCCAddinInstalled) then
  begin
{$IFDEF Enter1}
    ShowMessage('The credit card add-in has been uninstalled');
{$ENDIF}
  end
  else
  begin
    coCode := GetCompanyCode;
    ccGateway.SetCurrentCompanyCode(coCode);

    // Create an outgoing transaction object, which will go to the Gateway
    transDetails := CoExchequerTransaction.Create;

    // PKR. 21/01/2015. Corrected to customer code.
    transDetails.Set_ExchequerCompanyCode(aOriginalOrder.CustCode);

    // Set it to Refund
    transDetails.Set_PaymentType(PaymentAction_Refund);

    transDetails.Set_SalesOrderReference(aOriginalOrder.OurRef);


    // These details are not strictly necessary any more as the Payments Portal will
    // only refund to the the card used for the original payment, so the address
    // details for that will be used.
    billingAddress  := aCustomer.Addr;
    billingPostcode := aCustomer.PostCode;
    billingCountry  := aCustomer.acCountry;

    // Contact details
    if (aContactDetails <> nil) then
    begin
      transDetails.Set_ContactName(aContactDetails.contactDetails.acoContactName);
      transDetails.Set_ContactPhone(aContactDetails.contactDetails.acoContactPhoneNumber);
      transDetails.Set_ContactEmail(aContactDetails.contactDetails.acoContactEmailAddress);

      // If the contact has their own address, then use it.
      if (aContactDetails.contactDetails.acoContactHasOwnAddress) then
      begin
        billingAddress := aContactDetails.contactDetails.acoContactAddress;
        billingPostCode := aContactDetails.contactDetails.acoContactPostCode;
        billingCountry  := aContactDetails.contactDetails.acoContactCountry;
      end;
    end
    else
    begin
      // The contact is nil, so get the details from the company record
      transDetails.Set_ContactName(Trim(aCustomer.Contact));
      transDetails.Set_ContactPhone(Trim(aCustomer.Phone));
      transDetails.Set_ContactEmail(Trim(aCustomer.EmailAddr));
    end;

    // Delivery address is taken from the transaction.
    // If it is blank, then use the delivery address from the customer record
    // If that is blank, use the address from the customer record.
    // An address is deemed to be blank if its first line is blank.
    delAddress   := aOriginalOrder.DAddr;
    delPostCode  := aOriginalOrder.thDeliveryPostCode;
    delCountry   := aOriginalOrder.thDeliveryCountry;

    if delAddress[1] = '' then
    begin
      // Delivery address on the transaction is blank
      // Try the customer record delivery address.
      delAddress  := aCustomer.DAddr;
      delPostCode := aCustomer.acDeliveryPostCode;
      delCountry  := aCustomer.acCountry;
      if delAddress[1] = '' then
      begin
        // Customer delivery address is blank so use the customer record address
        delAddress  := billingAddress;
        delPostCode := billingPostCode;
        delCountry  := billingCountry;
      end;
      // It seems that the Delivery address is mandatory, and the Payment Portal objects
      // to not having a Delivery Postcode.
      if delPostCode = '' then
      begin
        // If the delivery address looks the same as the billing address, then use the billing postcode
        if (delAddress[1] = billingAddress[1]) and (delAddress[2] = billingAddress[2]) then
        begin
          delPostCode := billingPostCode;
        end
      end;
      if delCountry = '' then
      begin
        delCountry := billingCountry;
      end;
    end;

    // Set the Delivery address.  This might be blank, but if it is, the credit card add-in
    //  will overwrite it with the billing address
    transDetails.Set_DeliveryAddress1(Trim(delAddress[1]));
    transDetails.Set_DeliveryAddress2(Trim(delAddress[2]));

    // ABSEXCH-15959. Change Town to Address[4] and County to Address[5]
    transDetails.Set_DeliveryAddress3_Town(Trim(delAddress[4]));
    transDetails.Set_DeliveryAddress4_County(Trim(delAddress[5]));
    // PKR. Changed to use new country field instead of delAddress[5]
    transDetails.Set_DeliveryAddress_Country(Trim(delCountry));
    transDetails.Set_DeliveryAddressPostCode(Trim(delPostCode));

    transDetails.Set_BillingAddress1(Trim(billingAddress[1]));
    transDetails.Set_BillingAddress2(Trim(billingAddress[2]));

    // ABSEXCH-15959. Change Town to Address[4] and County to Address[5]
    transDetails.Set_BillingAddress3_Town(Trim(billingAddress[4]));
    transDetails.Set_BillingAddress4_County(Trim(billingAddress[5]));
    // PKR. Changed to use new country field instead of billingAddress[5]
    transDetails.Set_BillingAddress_Country(Trim(billingCountry));
    transDetails.Set_BillingAddressPostCode(Trim(billingPostCode));

    transDetails.Set_DescendentTransactionReference(aCreditCardTransGUID);

    RefundGrossAmount := 0.0;  // Running totals
    RefundNetAmount   := 0.0;

    // Add the transaction lines (source list is a 0=based array)
    // There seem to be a lot more lines than absolutely necessary.  For example, when
    //  refunding one item, we get 3 lines in here.
    for index := 0 to aRefundSummary.Count-1 do
    begin
      // Get the source line
      opTransLine := aRefundSummary.Records[index];

      // PKR. 25/03/2015. ABSEXCH-16256. Filter out unwanted records to prevent doubling up
      if (
          ((aOriginalOrder.InvDocHed in [SOR]) and (opTransLine.vpType = vptSORValueRefund)) or
          ((aOriginalOrder.InvDocHed in [SIN]) and (opTransLine.vpType = vptSINValueRefund)) or
          ((aOriginalOrder.InvDocHed in [SIN]) and (opTransLine.vpType = vptSINStockRefund))
           // Only add the line if it has some value
         ) and (opTransLine.vpGoodsValue > 0) then
      begin
        // Create a new destination line
        aTLine := CoTransactionLine.Create;

        // Now populate it
        aTLine.Set_Description(opTransLine.vpDescription);
        aTLine.Set_StockCode('');
        aTLine.Set_Quantity(1); // Always 1 because it's a single refund against the order.
        aTLine.Set_VATCode(opTransLine.vpVATCode);

        aTLine.Set_TotalNetValue(opTransLine.vpGoodsValue);
        aTLine.Set_TotalVATValue(opTransLine.vpVATValue);
        aTLine.Set_TotalGrossValue(opTransLine.vpGoodsValue +
                                   opTransLine.vpVATValue);

        oVatType := GetVATNo(opTransLine.vpVATCode, #0);
        vatRate := SyssVAT^.VATRates.VAT[oVatType].Rate;
        aTLine.Set_VATMultiplier(vatRate);

        aTLine.Set_UnitDiscount(0);
        aTLine.Set_TotalDiscount(0);

        // Add the gross value to the total
        RefundGrossAmount := RefundGrossAmount + opTransLine.vpGoodsValue + opTransLine.vpVATValue;
        RefundNetAmount   := RefundNetAmount + opTransLine.vpGoodsValue;

        aTLine.Set_UnitPrice(opTransLine.vpGoodsValue);

        // Add the line to our transaction
        transDetails.AddLine(aTLine);
      end;
    end;

    //============================================================================
    //  Mandatory fields for a refund.
    //============================================================================
    // Add the sum of the line gross values
    transDetails.Set_GrossTotal(RefundGrossAmount);
    transDetails.Set_NetTotal(RefundNetAmount);

    transDetails.Set_VATTotal(RefundGrossAmount - RefundNetAmount);

    // Add the currency code (the add-in will convert this to an ISO-4217 code)
    transDetails.Set_CurrencySymbol(aRefundCurrency);

    // NOT SURE IF THIS IS RIGHT!
    // The original transaction GUID
    transDetails.Set_PaymentReference(aCreditCardTransGUID);
    //============================================================================

    // Validate the input data
    Result := Ord(ValidateInputData(transDetails, 1, 1));

    if Result = 0 then
    begin
      //--------------------------------------------------------------------------
      // Pass the transaction through the gateway
      try
        try
          // PKR. 25/11/2014. Added conditional define to prevent crashing
    {$IFDEF ENTER1}
          ccGateway.SetParentHandle(integer(Application.MainForm.Handle));
    {$ELSE}
          if FOwnerHandle <> 0 then
            ccGateway.SetParentHandle(integer(FOwnerHandle));
    {$ENDIF}

          fResponse := ccGateway.ProcessRefund(transDetails, aRefundReason);

          if not fResponse.IsError then
          begin
            // Display the polling dialog
    {$IFDEF ENTER1}
            parentControl := Controls.FindControl(FOwnerHandle); // Could be nil
            txStatusCheckForm := TccTxStatusForm.Create(parentControl);

            if (parentControl <> nil) then
            begin
              // Position the form centred on the parent
              txStatusCheckForm.Left := (parentControl.Width  - txStatusCheckForm.Width ) div 2 + parentControl.Left;
              txStatusCheckForm.Top  := (parentControl.Height - txStatusCheckForm.Height) div 2 + parentControl.Top;
            end;
    {$ELSE}
            //If we have an owner window handle use it as the parent of the form
            if FOwnerHandle <> 0 then
            begin
              txStatusCheckForm := TccTxStatusForm.CreateParented(FOwnerHandle);

              //The following lines allow the progress form to be embedded into the parent window
              txStatusCheckForm.borderIcons := [];
              txStatusCheckForm.borderStyle := bsNone;
              txStatusCheckForm.formStyle := fsNormal;
              txStatusCheckForm.Top := 0;
              txStatusCheckForm.Left := 0;
              Application.ProcessMessages;
            end;
    {$ENDIF}

            // Set up and display the Polling form
            txStatusCheckForm.SetPaymentGateway(ccGateway);
            txStatusCheckForm.SetTransactionID(fResponse.gatewayTransactionGuid);
            txStatusCheckForm.SetOurRef(aOriginalOrder.OurRef);

            txStatusCheckForm.btnClose.Enabled := false;

            // ABSEXCH-15978. PKR. 08/01/2015. Stop user from closing the payment window
            //  before the status check window.
  {$IFDEF ENTER1}
            txStatusCheckForm.ShowModal;
            txStatusCheckForm.Cursor := crHourglass;
  {$ELSE}
            txStatusCheckForm.Show;
  {$ENDIF}


            //----------------------------------------------------------------------
            // Don't really like this...
            while txStatusCheckForm.isCheckingStatus do
            begin
              Application.ProcessMessages;
              Sleep(100);
            end;
            //----------------------------------------------------------------------

            // We need to get a status value from the Polling form to determine the true result of the transaction
            fTransactionResult := txStatusCheckForm.GetTransactionStatus;
            fResponse := txStatusCheckForm.GetTransactionResponse;
          end
          else
          begin
            // All we know is that an error occurred in the portal.
            Result := 999;
          end;
        except
            on E : Exception do
            begin
              Result := Ord(gsiError);
              {$IFDEF ENTER1}
              Screen.Cursor := crDefault;
              ShowMessage('Error processing Refund : ' + #13#10 + E.Message);
              {$ELSE}
                {$IFDEF COMTK}
                   //If called from the COM Toolkit use Dedicated Exception object which puts error message into Toolkit.LastErrorString
                   raise EToolkitException.Create('Error processing Refund: ' + QuotedStr(E.Message));
                {$ELSE}
                   //reraise the exception
                   raise;
                 {$ENDIF not COMTK}
              {$ENDIF not Enter1}
              // PKR. 17/08/2015. ABSEXCH-16763.  Credit Card Refund not populating cc fileds on SRC Header
              Result := Ord(gsiError);
            end;
        end;
        //--------------------------------------------------------------------------

        if fResponse <> nil then
        begin
          // ABSEXCH-15875. PKR. 05/12/2014. Cancelling a transaction at the Payment Provider is not passed back to the host app.
          // This was a bug in the Payment Portal. These code changes take advantage of the correct codes that are now passed back.
          // Exchequer uses 0 to mean success, but the portal uses 1, so we'll switch the first 2 results.
          case enumGatewayStatusIds(fTransactionResult) of
            gsiPending:
              begin
                Result := 1;
              end;
            gsiOK:
              begin
                Result := 0;
              end;
            gsiNotAuthed,
            gsiAbort,
            gsiRejected,
            gsiAuthenticated,
            gsiRegistered,
            gsiError:
              begin
                Result := fTransactionResult;
              end;
          end;

          if fResponse.IsError then
          begin
            // Error status
            if Assigned(txStatusCheckForm) then
              txStatusCheckForm.Close;
          end;
        end
        else
        begin
          // Response is nil
          Result := fTransactionResult;

          if txStatusCheckForm <> nil then
            txStatusCheckForm.Close;
        end;
      finally
        {$IFNDEF COMTK}
        if Assigned(txStatusCheckForm) then
        begin
          txStatusCheckForm.Free;
        end;
        Screen.Cursor := crDefault;
        {$ENDIF}
      end;
    end;
  end;
end;


//==============================================================================
Function TCreditCardPaymentGateway.GetPaymentResponse : PaymentGatewayResponse;
begin
  result := fResponse;
end;

//==============================================================================

Function TCreditCardPaymentGateway.GetPaymentDefaults(out aGLCode : integer;
                                                      out aProvider : int64;
                                                      out aMerchantID : int64;
                                                      out aCostCentre : string;
                                                      out aDepartment : string;
                                                      aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10 : string) : Boolean;
var
  GLCode     : integer;
  Provider   : Int64;
  MerchantID : Int64;
  CostCentre : widestring;
  Department : widestring;
begin
  result := false;

  ccGateway.SetCurrentCompanyCode(GetCompanyCode);

  if ccGateway.GetPaymentDefaults(GLCode,
                                  Provider,
                                  MerchantID,
                                  CostCentre,
                                  Department,
                                  aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10) then
  begin
    aGLCode     := GLCode;
    aProvider   := Provider;
    aMerchantID := MerchantID;
    aCostCentre := CostCentre;
    aDepartment := Department;
    result      := true;
  end
  else
  begin
    // Call failed (no defaults configured), so return blanks.
    aGLCode     := 0;
    aProvider   := 0;
    aMerchantID := 0;
    aCostCentre := '';
    aDepartment := '';
  end;
end;


Function TCreditCardPaymentGateway.GetPaymentDefaultsEx(out aGLCode : integer;
                                                        out aProvider : int64;
                                                        out aMerchantID : int64;
                                                        out aCostCentre : string;
                                                        out aDepartment : string;
                                                        out aPaymentProviderDesc : string;
                                                        aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10 : string) : Boolean;
var
  GLCode     : integer;
  Provider   : Int64;
  MerchantID : Int64;
  CostCentre : widestring;
  Department : widestring;
  ProviderDesc : widestring;
begin
  result := false;

  ccGateway.SetCurrentCompanyCode(GetCompanyCode);

  if ccGateway.GetPaymentDefaultsEx(GLCode,
                                    Provider,
                                    MerchantID,
                                    CostCentre,
                                    Department,
                                    ProviderDesc,
                                    aUDF5, aUDF6, aUDF7, aUDF8, aUDF9, aUDF10) then
  begin
    aGLCode     := GLCode;
    aProvider   := Provider;
    aMerchantID := MerchantID;
    aCostCentre := CostCentre;
    aDepartment := Department;
    aPaymentProviderDesc := ProviderDesc;
    result      := true;
  end
  else
  begin
    // Call failed (no defaults configured), so return blanks.
    aGLCode     := 0;
    aProvider   := 0;
    aMerchantID := 0;
    aCostCentre := '';
    aDepartment := '';
    aPaymentProviderDesc := '';
  end;
end;


//------------------------------------------------------------------------------
//function TCreditCardPaymentGateway.GetTransactionStatus(aAuthTicket, aVendorTxCode : string) : PaymentGatewayResponse;
function TCreditCardPaymentGateway.GetTransactionStatus(aVendorTxCode : string) : PaymentGatewayResponse;
begin
  result := ccGateway.GetTransactionStatus(aVendorTxCode);
end;


//------------------------------------------------------------------------------
function TCreditCardPaymentGateway.GetTransactionResult : integer;
begin
  Result := fTransactionResult;
end;

//------------------------------------------------------------------------------
procedure TCreditCardPaymentGateway.SetOwnerHandle(aHandle : HWND);
begin
  FOwnerHandle := aHandle;
end;

//------------------------------------------------------------------------------
// PKR. 05/01/2015. Returns the status of the Payment Portal service.
Function TCreditCardPaymentGateway.GetServiceStatus() : boolean;
begin
  result := ccGateway.GetServiceStatus;
end;

//------------------------------------------------------------------------------
function TCreditCardPaymentGateway.UpdateTransactionContent(const gatewayTransactionGuid: WideString;
                                                             const receiptReference: WideString;
                                                             const customData: WideString) : integer;
begin
  Result := ccGateway.UpdateTransactionContent(gatewayTransactionGuid, receiptReference, customData);
end;

//------------------------------------------------------------------------------
//PR: 20/02/2015 Added function to return the error message from the error code
function CCGatewayErrorMessage(errCode : Integer) : string;
begin
  case ccValidationErrors(errCode) of
    veInvalidPaymentProvider:     Result := 'Payment data validation error : Invalid Payment Provider';
    veInvalidMerchantID:          Result := 'Payment data validation error : Invalid Merchant ID';
    veInvalidCompanyCode:         Result := 'Payment data validation error : Invalid Company Code';
    veInvalidSalesOrderReference: Result := 'Payment data validation error : Invalid Sales Order reference';
    veInvalidContactName:         Result := 'Payment data validation error : Invalid contact name.'#13#10 +
                  'Contact must have First Name and Surname specified.';
    veInvalidCurrency:            Result := 'Payment data validation error : Invalid currency code';
    veInvalidBillingAddr1:        Result := 'Payment data validation error : Invalid Billing Address';
    veInvalidBillingTown:         Result := 'Payment data validation error : Invalid Billing Town/City';
    veInvalidBillingCounty:       Result := 'Payment data validation error : Invalid Billing County';
    veInvalidBillingPostcode:     Result := 'Payment data validation error : Invalid Billing Postcode';
    veInvalidBillingCountry:      Result := 'Payment data validation error : Invalid Billing Country';
    veInvalidDelAddr1:            Result := 'Payment data validation error : Invalid Delivery Address';
    veInvalidDelTown:             Result := 'Payment data validation error : Invalid delivery Town/City';
    veInvalidDelCounty:           Result := 'Payment data validation error : Invalid Delivery County';
    veInvalidDelPostcode:         Result := 'Payment data validation error : Invalid Delivery Postcode';
    veInvalidDelCountry:          Result := 'Payment data validation error : Invalid Delivery Country';
    veInvalidNetTotal:            Result := 'Payment data validation error : Invalid Net Total';
    veInvalidVATTotal:            Result := 'Payment data validation error : Invalid VAT Total';
    veInvalidGrossTotal:          Result := 'Payment data validation error : Invalid Gross Total';
  end;
end;

//==============================================================================
//PR: 20/02/2015 Moved setting of message to CCGatewayErrorMessage function so it can be used by
//               the toolkit.
procedure CCGatewayReportValidationError(errCode : integer);
begin
  // Check for validation errors
  if (ccValidationErrors(errCode) >= veInvalidPaymentProvider) and
     (ccValidationErrors(errCode) <= veInvalidGrossTotal) then
  begin
    ShowMessage(CCGatewayErrorMessage(errCode));
  end;
end;

//==============================================================================
// PKR. 11/02/2015. ABSEXCH-16123.
// Determines if the Add-in is properly installed by checking for the existence
// of two key files.
// If there is a central Exchequer installation used by several users, if one
// user uninstalls, then it removes the files.  However, the other users don't see it
// as uninstalled, so their system crashes.  This partly fixes the problem. by
// setting it as uninstalled if the key files are missing.  However, it doesn't
// cover the situation where it is uninstalled AFTER the other workstations are
// already running.  That will be addressed by ABSEXCH-16161.

function IsCCAddinInstalled : Boolean;
//function TCreditCardPaymentGateway.IsCCAddinInstalled : Boolean;
var
  TmpStr      : ShortString;
  exchRootDir : string;
begin
  exchRootDir := '';
  Result := false;

  // Get the Exchequer installation directory
  with TRegistry.Create do
  begin
    try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      // Open the OLE Server CLSID key to get the GUID to lookup in the
      // CLSID section - safer than hard-coding the GUID in the code
      if OpenKey('Enterprise.OLEServer\Clsid', False) then
      begin
        // Read CLSID stored in default entry }
        TmpStr := ReadString ('');
        CloseKey;

        // Got CLSID - find entry in CLSID Section and check for registered .EXE }
        if OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) then
        begin
          // Get path of registered OLE Server .Exe
          TmpStr := ReadString ('');

          // Check the OLE Server actually exists and return the path if OK
          if FileExists (TmpStr) then
          begin
            exchRootDir := ExtractFilePath(TmpStr);
          end; // If FileExists (TmpStr)

          CloseKey;
        end; // If OpenKey('Clsid\'+TmpStr+'\LocalServer32', False)
      end; // If OpenKey('Enterprise.OLEServer\Clsid', False)

      // PKR. 18/05/2016.  - Minimum .NET is now 4.6.1
      // PKR. ABSEXCH-17604. 16/06/2016.  - Minimum .NET changed back to 4.5.1
      //  to avoid the need for existing customers to upgrade.
      // See if the CC Addin files have been registered, and we have the minimum
      //  version of .NET
      Result := KeyExists('GatewayCOM.GatewayCOMClass') and
                KeyExists('ExchequerPaymentGateway.PaymentGatewayPlugin') and
                DotNetInfo.Net451Installed;

      // See if the files exist in the Exchequer directory
      Result := Result and
                FileExists(exchRootDir + 'ExchequerPaymentGateway.dll') and
                FileExists(exchRootDir + 'Exchequer.Payments.Portal.COM.Client.dll');
    finally
      Free;
    end; // Try..Finally
  end; // With TRegistry.Create
end;

//==============================================================================


Initialization
  // This runs at application startup.

  CreditCardPaymentGatewayObj := NIL;
  CreditCardPaymentGatewayIntf := NIL;
Finalization
  // NB. Code in here runs BEFORE the class destructors.
  CreditCardPaymentGatewayObj := NIL;
  CreditCardPaymentGatewayIntf := NIL;
End.

